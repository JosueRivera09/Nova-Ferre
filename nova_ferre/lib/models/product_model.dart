class ProductModel {
  final String id;
  final String nombre;
  final String? descripcion;
  final double precioCompra;
  final double precioVenta;
  final double stock;
  final String nombreCategoria;
  final bool estado; // true: Activo, false: Inactivo
  final String? motivoInactivo;

  ProductModel({
    required this.id,
    required this.nombre,
    this.descripcion,
    required this.precioCompra,
    required this.precioVenta,
    required this.stock,
    required this.nombreCategoria,
    this.estado = true,
    this.motivoInactivo,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
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
      precioCompra: double.tryParse(json['precio_compra']?.toString() ?? '0') ?? 0.0,
      precioVenta: double.tryParse(json['precio_venta']?.toString() ?? '0') ?? 0.0,
      stock: double.tryParse(json['stock']?.toString() ?? '0') ?? 0.0,
      nombreCategoria: catName,
      estado: json['estado_activo'] ?? true,
      motivoInactivo: json['motivo_inactivo'],
    );
  }
}
