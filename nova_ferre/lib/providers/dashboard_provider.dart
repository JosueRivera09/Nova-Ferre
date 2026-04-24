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
      final response = await _supabase.rpc('obtener_metricas_dashboard');
      _metrics = Map<String, dynamic>.from(response);
    } catch (e) {
      debugPrint("Error Dashboard: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
