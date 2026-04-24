import 'package:nova_ferre/nova_ferre_exports.dart';

class LogisticsProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _pendingDeliveries = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get pendingDeliveries => _pendingDeliveries;
  bool get isLoading => _isLoading;

  Future<void> fetchPendingDeliveries() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('logistica')
          .select('*, ventas(cliente_nombre, fecha_venta, total)')
          .eq('estado_entrega', 'Pendiente')
          .order('id_despacho', ascending: false);

      _pendingDeliveries = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint("Error en Logística: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Marcar como entregado
  Future<bool> markAsDelivered(String dispatchId, int userId) async {
    try {
      await _supabase
          .from('logistica')
          .update({
            'estado_entrega': 'Entregado',
            'fecha_entrega': DateTime.now().toIso8601String(),
            'actualizado_por': userId,
          })
          .eq('id_despacho', dispatchId);

      await fetchPendingDeliveries(); // Refrescar lista
      return true;
    } catch (e) {
      return false;
    }
  }
}
