import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class SalesProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;

  List<ProductModel> _products = [];
  final List<CartItem> _cart = [];
  bool _isLoading = false;

  // Getters
  List<ProductModel> get products => _products;
  List<CartItem> get cart => _cart;
  bool get isLoading => _isLoading;
  double get total => _cart.fold(0.0, (sum, item) => sum + item.subtotal);

  // --- CARGAR PRODUCTOS ---
  Future<void> fetchProducts() async {
    try {
      _isLoading = true;
      Future.microtask(() => notifyListeners());

      final response = await _supabase
          .from('productos')
          .select('*, categorias(nombre_categoria)')
          .eq('estado_activo', true)
          .order('nombre_articulo');

      if (response != null) {
        final data = response as List<dynamic>;
        _products = data.map((item) => ProductModel.fromJson(item)).toList();
      }
    } catch (e) {
      debugPrint("Error fetchProducts: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // --- LÓGICA DEL CARRITO ---
  void addToCart(ProductModel product) {
    if (product.stock <= 0) return; // No agregar si no hay stock

    final index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (_cart[index].quantity + 1 > product.stock) {
        // No permitir exceder el stock
        return;
      }
      _cart[index].quantity++;
    } else {
      if (product.stock >= 1) {
        _cart.add(CartItem(product: product, quantity: 1));
      }
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _cart.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // --- PROCESAR VENTA (EL MÉTODO QUE FALTABA) ---
  Future<bool> processSale({
    required int userId,
    required String clienteNombre,
  }) async {
    if (_cart.isEmpty) return false;

    try {
      _isLoading = true;
      notifyListeners();

      // 1. Ejecutar la venta en el servidor
      final listaProductos = _cart.map((item) => {
        "id_producto": item.product.id,
        "cantidad": item.quantity,
        "precio": item.product.precioVenta
      }).toList();

      await _supabase.rpc('procesar_venta_completa', params: {
        'p_usuario_id': userId,
        'p_cliente': clienteNombre,
        'p_total': total,
        'p_detalles': listaProductos,
      });

      // --- AQUÍ ESTÁ EL TRUCO PARA EL TIEMPO REAL ---
      
      // 2. Limpiar el carrito localmente
      _cart.clear(); 

      // 3. Volver a pedir los productos a Supabase (para traer el stock nuevo)
      // Esto actualiza la lista _products que lee la UI
      await fetchProducts(); 

      // 4. ¡AVISAR A LA INTERFAZ!
      // Sin esta línea, la pantalla no se redibuja
      notifyListeners(); 

      return true;
    } catch (e) {
      debugPrint("Error: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

class CartItem {
  final ProductModel product;
  double quantity;
  CartItem({required this.product, required this.quantity});
  double get subtotal => product.precioVenta * quantity;
}
