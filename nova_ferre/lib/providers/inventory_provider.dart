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
}
