import 'package:nova_ferre/ui/main/nova_ferre_exports.dart';

class AuthProvider extends ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;

  // Getters para acceder a la info desde la UI
  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;

  final _authService = AuthService();

  // Función principal de acceso
  Future<bool> login(int id, String pin) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userResponse = await _authService.login(id, pin);

      if (userResponse != null) {
        _user = userResponse;
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      debugPrint("Error en AuthProvider: $e");
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Cerrar sesión
  void logout() {
    _user = null;
    notifyListeners();
  }
}
