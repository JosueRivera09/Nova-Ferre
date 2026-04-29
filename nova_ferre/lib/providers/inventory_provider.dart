import 'package:nova_ferre/nova_ferre_exports.dart';

class InventoryProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<ProductModel> _inventory = [];
  bool _isLoading = false;

  List<ProductModel> get inventory => _inventory;
  bool get isLoading => _isLoading;

  // Cargar inventario completo
  Future<void> fetchInventory() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('productos')
          .select('*, categorias(nombre_categoria)')
          .order('nombre_articulo');

      _inventory = (response as List)
          .map((p) => ProductModel.fromJson(p))
          .toList();
    } catch (e) {
      debugPrint("Error en Inventario: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Actualizar stock manualmente (Entradas)
  Future<bool> updateProductStock(String productId, double newStock) async {
    try {
      await _supabase
          .from('productos')
          .update({'stock': newStock})
          .eq('id_producto', productId);
      await fetchInventory(); // Refrescar lista
      return true;
    } catch (e) {
      return false;
    }
  }

  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> get categories => _categories;

  Future<void> fetchCategories() async {
    try {
      final response = await _supabase.from('categorias').select();
      _categories = List<Map<String, dynamic>>.from(response);
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }
  }

  Future<String?> addCategory({required String nombre, required String prefijo}) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _supabase.from('categorias').insert({
        'nombre_categoria': nombre,
        'prefijo': prefijo,
      });
      await fetchCategories();
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> updateCategory({required int idCategoria, required String nombre, required String prefijo}) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _supabase.from('categorias').update({
        'nombre_categoria': nombre,
        'prefijo': prefijo,
      }).eq('id_categoria', idCategoria);
      await fetchCategories();
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> addProduct({
    required String nombre,
    String? descripcion,
    required double precioCompra,
    required double precioVenta,
    required double stock,
    String? idCategoria,
    bool estado = true,
    String? motivoInactivo,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = {
        'nombre_articulo': nombre,
        'descripcion': descripcion,
        'precio_compra': precioCompra,
        'precio_venta': precioVenta,
        'stock': stock,
        'estado_activo': estado,
        'motivo_inactivo': !estado ? motivoInactivo : null,
      };

      if (idCategoria != null) {
        data['id_categoria'] = idCategoria;
      }

      await _supabase.from('productos').insert(data);
      await fetchInventory();
      return null;
    } catch (e) {
      debugPrint("Error addProduct: $e");
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<String?> updateProduct({
    required String id,
    required String nombre,
    String? descripcion,
    required double precioCompra,
    required double precioVenta,
    required double stock,
    String? idCategoria,
    bool estado = true,
    String? motivoInactivo,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = {
        'nombre_articulo': nombre,
        'descripcion': descripcion,
        'precio_compra': precioCompra,
        'precio_venta': precioVenta,
        'stock': stock,
        'estado_activo': estado,
        'motivo_inactivo': !estado ? motivoInactivo : null,
      };

      if (idCategoria != null) {
        data['id_categoria'] = idCategoria;
      } else {
        data['id_categoria'] = null; // Or handle category removal if needed
      }

      await _supabase.from('productos').update(data).eq('id_producto', id);
      await fetchInventory();
      return null;
    } catch (e) {
      debugPrint("Error updateProduct: $e");
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
