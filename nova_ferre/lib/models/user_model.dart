class UserModel {
  final int id;
  final String nombreCompleto;
  final String? urlAvatar;
  final String rol;
  final bool mantenerSesion;

  UserModel({
    required this.id,
    required this.nombreCompleto,
    this.urlAvatar,
    required this.rol,
    required this.mantenerSesion,
  });

  /// Mapea la respuesta de Supabase (JSON) a nuestro objeto UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // 1. Extraemos la lista de roles de la relación usuario_roles
    // Supabase devuelve las relaciones como listas: [ { roles: { nombre_rol: "..." } } ]
    final List? rolesList = json['usuario_roles'] as List?;

    // 2. Buscamos el nombre del rol de forma segura (A prueba de RangeError)
    String nombreRol = 'Sin Rol';
    if (rolesList != null && rolesList.isNotEmpty) {
      final firstRoleEntry = rolesList[0];
      if (firstRoleEntry['roles'] != null) {
        nombreRol = firstRoleEntry['roles']['nombre_rol'] ?? 'Sin Rol';
      }
    }

    return UserModel(
      id: json['id_usuario'] ?? 0,
      nombreCompleto: json['nombre_completo'] ?? 'Usuario sin nombre',
      urlAvatar: json['url_avatar'],
      rol: nombreRol,
      mantenerSesion: json['mantener_sesion'] ?? false,
    );
  }

  /// Convierte el objeto a JSON (útil para guardar en local si fuera necesario)
  Map<String, dynamic> toJson() {
    return {
      'id_usuario': id,
      'nombre_completo': nombreCompleto,
      'url_avatar': urlAvatar,
      'mantener_sesion': mantenerSesion,
      // El rol suele ser informativo en el cliente
      'rol': rol,
    };
  }

  /// Método para copiar el usuario cambiando solo algunos campos
  UserModel copyWith({
    int? id,
    String? nombreCompleto,
    String? urlAvatar,
    String? rol,
    bool? mantenerSesion,
  }) {
    return UserModel(
      id: id ?? this.id,
      nombreCompleto: nombreCompleto ?? this.nombreCompleto,
      urlAvatar: urlAvatar ?? this.urlAvatar,
      rol: rol ?? this.rol,
      mantenerSesion: mantenerSesion ?? this.mantenerSesion,
    );
  }
}
