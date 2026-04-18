import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  Future<UserModel?> login(int idUsuario, String pin) async {
    try {
      // 1. Buscando el usuario con el ID, PIN y estado activo
      // Usando .maybeSingle() para que devuelva un registro o null
      final response = await _supabase
          .from('usuarios')
          .select('*, usuario_roles(roles(nombre_rol))')
          .eq('id_usuario', idUsuario)
          .eq(
            'pin_hash',
            pin,
          ) // En producción usaríamos un hash, aquí el PIN directo
          .eq('estado_usuario', true) // Solo si está activo
          .maybeSingle();

      if (response == null) return null;

      // 2. Mapeamos la respuesta al modelo
      return UserModel.fromJson(response);
    } catch (e) {
      print("Error en Login: $e");
      return null;
    }
  }
}
