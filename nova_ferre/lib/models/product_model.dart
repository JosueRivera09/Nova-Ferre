class ProductModel {
  final String id;
  final String nombre;
  final String? descripcion;
  final double precioVenta;
  final double stock;
  final String nombreCategoria;

  ProductModel({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.precioVenta,
    required this.stock,
    required this.nombreCategoria,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    // SEGURIDAD: Supabase a veces devuelve la relación como Lista o como Mapa
    final categoriaRaw = json['categorias'];
    String catName = 'Sin Categoría';

    if (categoriaRaw is Map) {
      catName = categoriaRaw['nombre_categoria'] ?? 'Sin Categoría';
    } else if (categoriaRaw is List && categoriaRaw.isNotEmpty) {
      catName = categoriaRaw[0]['nombre_categoria'] ?? 'Sin Categoría';
    }

    return ProductModel(
      id: json['id_producto']?.toString() ?? '',
      nombre: json['nombre_articulo'] ?? 'Sin nombre',
      descripcion: json['descripcion'],
      // SEGURIDAD: Convertimos a double de forma robusta
      precioVenta: double.tryParse(json['precio_venta'].toString()) ?? 0.0,
      stock: double.tryParse(json['stock'].toString()) ?? 0.0,
      nombreCategoria: catName,
    );
  }
}
