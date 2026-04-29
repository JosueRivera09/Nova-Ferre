import 'package:nova_ferre/nova_ferre_exports.dart';

class DashboardProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  Map<String, dynamic> _metrics = {
    'total_hoy': 0.0,
    'bajo_stock': 0,
    'pendientes': 0,
  };
  bool _isLoading = false;

  Map<String, dynamic> get metrics => _metrics;
  bool get isLoading => _isLoading;

  Future<void> fetchMetrics() async {
    _isLoading = true;
    notifyListeners();

    try {
      // 1. Total Ventas Hoy
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day).toIso8601String();
      
      final ventasResp = await _supabase
          .from('ventas')
          .select('total')
          .gte('fecha_venta', startOfDay);
          
      double totalHoy = 0.0;
      for (var v in (ventasResp as List)) {
        totalHoy += (v['total'] as num).toDouble();
      }

      // 2. Pedidos Pendientes
      final logResp = await _supabase
          .from('logistica')
          .select('id_despacho')
          .eq('estado_entrega', 'Pendiente');
      
      final pendientes = (logResp as List).length;

      // 3. Productos Bajo Stock
      final stockResp = await _supabase
          .from('productos')
          .select('id_producto')
          .lte('stock', 5)
          .eq('estado_activo', true);
          
      final bajoStock = (stockResp as List).length;

      _metrics = {
        'total_hoy': totalHoy,
        'bajo_stock': bajoStock,
        'pendientes': pendientes,
      };
    } catch (e) {
      debugPrint("Error Dashboard: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
