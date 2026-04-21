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
    final index = _cart.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _cart[index].quantity++;
    } else {
      _cart.add(CartItem(product: product, quantity: 1));
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

      // 1. Insertar la cabecera de la venta
      // Nota: El id_venta se genera automáticamente por el Trigger en la DB
      final ventaResponse = await _supabase
          .from('ventas')
          .insert({
            'id_usuario_vendedor': userId,
            'cliente_nombre': clienteNombre,
            'total': total,
          })
          .select()
          .single();

      final String idVentaGenerada = ventaResponse['id_venta'];

      // 2. Insertar los detalles de la venta uno por uno
      for (var item in _cart) {
        await _supabase.from('detalle_ventas').insert({
          'id_venta': idVentaGenerada,
          'id_producto': item.product.id,
          'cantidad': item.quantity,
          'precio_unitario_historico': item.product.precioVenta,
        });

        // 3. Actualizar Stock usando la función RPC de Postgres
        await _supabase.rpc(
          'restar_stock',
          params: {'p_id': item.product.id, 'p_cantidad': item.quantity},
        );
      }

      // Limpiar todo tras el éxito
      clearCart();
      await fetchProducts(); // Refrescar stock en la lista
      return true;
    } catch (e) {
      debugPrint("Error en processSale: $e");
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
