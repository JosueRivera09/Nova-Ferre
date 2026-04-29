import 'package:nova_ferre/ui/main/nova_ferre_exports.dart';

class UserProvider extends ChangeNotifier {
  final _supabase = Supabase.instance.client;
  List<UserModel> _users = [];
  List<Map<String, dynamic>> _roles = [];
  bool _isLoading = false;

  List<UserModel> get users => _users;
  List<Map<String, dynamic>> get roles => _roles;
  bool get isLoading => _isLoading;

  Future<void> fetchUsersAndRoles() async {
    _isLoading = true;
    notifyListeners();

    try {
      final rolesResponse = await _supabase.from('roles').select();
      _roles = List<Map<String, dynamic>>.from(rolesResponse);

      final usersResponse = await _supabase
          .from('usuarios')
          .select('*, usuario_roles(roles(*))')
          .order('id_usuario');
      _users = (usersResponse as List)
          .map((u) => UserModel.fromJson(u))
          .toList();
    } catch (e) {
      debugPrint("Error UserProvider: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> addUser({
    required String nombre,
    required String pin,
    required int idRol,
    required String areaAsignada,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _supabase.from('usuarios').insert({
        'nombre_completo': nombre,
        'pin_hash':
            pin, // PIN guardado directamente (en prod se debe encriptar)
        'estado_usuario': true,
        'area_asignada': areaAsignada,
      }).select();

      final newUserId = response[0]['id_usuario'];

      await _supabase.from('usuario_roles').insert({
        'id_usuario': newUserId,
        'id_rol': idRol,
      });

      await fetchUsersAndRoles();
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> updateUser({
    required int idUsuario,
    required String nombre,
    String? pin,
    required int idRol,
    required bool estado,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final data = {'nombre_completo': nombre, 'estado_usuario': estado};
      if (pin != null && pin.isNotEmpty) {
        data['pin_hash'] = pin;
      }

      await _supabase.from('usuarios').update(data).eq('id_usuario', idUsuario);

      // Update role (borrar el anterior y crear el nuevo)
      await _supabase
          .from('usuario_roles')
          .delete()
          .eq('id_usuario', idUsuario);
      await _supabase.from('usuario_roles').insert({
        'id_usuario': idUsuario,
        'id_rol': idRol,
      });

      await fetchUsersAndRoles();
      return null;
    } catch (e) {
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
