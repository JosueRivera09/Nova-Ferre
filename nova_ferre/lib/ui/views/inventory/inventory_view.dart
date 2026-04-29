import 'package:nova_ferre/nova_ferre_exports.dart';

class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  String _selectedFilter = "Todo";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final invProvider = context.read<InventoryProvider>();
      invProvider.fetchInventory();
      invProvider.fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final invProvider = context.watch<InventoryProvider>();
    final nav = context.watch<NavigationProvider>();
    final searchQuery = nav.searchQuery.toLowerCase();

    final filteredInventory = invProvider.inventory.where((p) {
      final matchesSearch =
          p.nombre.toLowerCase().contains(searchQuery) ||
          p.id.toLowerCase().contains(searchQuery);

      bool matchesFilter = true;
      if (_selectedFilter == "Crítico") {
        matchesFilter = p.stock <= 5;
      } else if (_selectedFilter == "Activos") {
        matchesFilter = p.estado == true;
      } else if (_selectedFilter == "Inactivos") {
        matchesFilter = p.estado == false;
      }

      return matchesSearch && matchesFilter;
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Control de Inventario",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3142),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Color(0xFFE6683C)),
            onPressed: () => invProvider.fetchInventory(),
          ),
        ],
      ),
      body: invProvider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFE6683C)),
            )
          : Column(
              children: [
                _buildHeaderStats(invProvider.inventory),
                _buildFilterRow(),
                const SizedBox(height: 10),
                _buildTableHeaders(),
                Expanded(child: _buildInventoryTable(filteredInventory)),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE6683C),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddProductDialog(context),
      ),
    );
  }

  Widget _buildFilterRow() {
    final filters = ["Todo", "Crítico", "Activos", "Inactivos"];
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final filter = filters[index];
          final isSelected = _selectedFilter == filter;
          return ChoiceChip(
            label: Text(filter),
            selected: isSelected,
            onSelected: (val) => setState(() => _selectedFilter = filter),
            selectedColor: const Color(0xFFE6683C),
            labelStyle: TextStyle(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderStats(List<ProductModel> products) {
    final lowStockCount = products.where((p) => p.stock <= 5).length;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          _statCard("Total Artículos", products.length.toString(), Colors.blue),
          const SizedBox(width: 15),
          _statCard("Stock Crítico", lowStockCount.toString(), Colors.red),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeaders() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF2C3136),
        borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
      ),
      child: const Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              "Nombre y Descripción",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Código",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Stock",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Estado",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Motivo",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              "Precio",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 40), // Espacio para el botón de editar
        ],
      ),
    );
  }

  Widget _buildInventoryTable(List<ProductModel> products) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
      ),
      child: products.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: Text("No se encontraron productos"),
              ),
            )
          : ListView.separated(
              itemCount: products.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final p = products[index];
                bool isLowStock = p.stock <= 5;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              p.descripcion ?? "Sin descripción",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(p.id, style: const TextStyle(fontSize: 12)),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "${p.stock.toInt()}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isLowStock ? Colors.red : Colors.green,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: p.estado
                                ? Colors.green.withValues(alpha: 0.1)
                                : Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            p.estado ? "Activo" : "Inactivo",
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: p.estado ? Colors.green : Colors.red,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          p.estado ? "-" : (p.motivoInactivo ?? "Sin motivo"),
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "\$${p.precioVenta.toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.edit_outlined,
                          color: Colors.grey,
                        ),
                        onPressed: () => _showEditStockDialog(context, p),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _showEditStockDialog(BuildContext context, ProductModel p) {
    final invProvider = context.read<InventoryProvider>();
    final nombreController = TextEditingController(text: p.nombre);
    final descController = TextEditingController(text: p.descripcion ?? '');
    final pCompraController = TextEditingController(
      text: p.precioCompra.toString(),
    );
    final pVentaController = TextEditingController(
      text: p.precioVenta.toString(),
    );
    final stockController = TextEditingController(text: p.stock.toString());
    final motivoController = TextEditingController(
      text: p.motivoInactivo ?? '',
    );

    // Find the category ID from the category name, or default if not found
    String? selectedCategoryId;
    try {
      if (invProvider.categories.isNotEmpty) {
        final catMatch = invProvider.categories.firstWhere(
          (c) => c['nombre_categoria'] == p.nombreCategoria,
          orElse: () => <String, dynamic>{},
        );
        if (catMatch.isNotEmpty) {
          selectedCategoryId = catMatch['id_categoria'].toString();
        }
      }
    } catch (e) {
      debugPrint("Error preselecting category: $e");
    }

    bool isActivo = p.estado;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return CustomDialog(
              title: "Editar Producto",
              subtitle: "Modifique la información del producto",
              icon: Icons.edit_note_rounded,
              confirmLabel: "Guardar Cambios",
              isLoading: invProvider.isLoading,
              onConfirm: () async {
                if (nombreController.text.isEmpty ||
                    pVentaController.text.isEmpty ||
                    stockController.text.isEmpty) {
                  return;
                }

                final error = await invProvider.updateProduct(
                  id: p.id,
                  nombre: nombreController.text.trim(),
                  descripcion: descController.text.trim(),
                  precioCompra: double.tryParse(pCompraController.text) ?? 0.0,
                  precioVenta: double.tryParse(pVentaController.text) ?? 0.0,
                  stock: double.tryParse(stockController.text) ?? 0.0,
                  idCategoria: selectedCategoryId,
                  estado: isActivo,
                  motivoInactivo: motivoController.text.trim(),
                );

                if (!context.mounted) return;
                Navigator.pop(context);

                CustomNotification.show(
                  context,
                  error == null ? "¡Producto Actualizado!" : "Error: $error",
                  isSuccess: error == null,
                );
              },
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: "Nombre",
                      prefixIcon: Icon(Icons.shopping_bag_outlined),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: "Descripción",
                      prefixIcon: Icon(Icons.description_outlined),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: pCompraController,
                          decoration: const InputDecoration(
                            labelText: "P. Compra",
                            prefixIcon: Icon(Icons.arrow_downward, size: 18),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: pVentaController,
                          decoration: const InputDecoration(
                            labelText: "P. Venta",
                            prefixIcon: Icon(Icons.arrow_upward, size: 18),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: stockController,
                    decoration: const InputDecoration(
                      labelText: "Stock",
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  // Selector de Estado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Estado:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ToggleButtons(
                        isSelected: [isActivo, !isActivo],
                        onPressed: (index) {
                          setStateDialog(() => isActivo = index == 0);
                        },
                        borderRadius: BorderRadius.circular(10),
                        selectedColor: Colors.white,
                        fillColor: isActivo ? Colors.green : Colors.red,
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text("Activo"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text("Inactivo"),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (!isActivo) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: motivoController,
                      decoration: const InputDecoration(
                        labelText: "Motivo de inactividad",
                        prefixIcon: Icon(Icons.warning_amber_rounded),
                      ),
                    ),
                  ],
                  const SizedBox(height: 15),
                  if (invProvider.categories.isNotEmpty)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: "Categoría"),
                      value: selectedCategoryId,
                      items: invProvider.categories.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat['id_categoria'].toString(),
                          child: Text(cat['nombre_categoria'] ?? 'Sin nombre'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setStateDialog(() => selectedCategoryId = val);
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showAddProductDialog(BuildContext context) {
    final invProvider = context.read<InventoryProvider>();
    final nombreController = TextEditingController();
    final descController = TextEditingController();
    final pCompraController = TextEditingController();
    final pVentaController = TextEditingController();
    final stockController = TextEditingController();
    final motivoController = TextEditingController();
    String? selectedCategoryId;
    bool isActivo = true;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return CustomDialog(
              title: "Nuevo Producto",
              subtitle: "Complete la información del producto",
              icon: Icons.add_business_rounded,
              confirmLabel: "Guardar",
              isLoading: invProvider.isLoading,
              onConfirm: () async {
                if (nombreController.text.isEmpty ||
                    pVentaController.text.isEmpty ||
                    stockController.text.isEmpty) {
                  return;
                }

                final error = await invProvider.addProduct(
                  nombre: nombreController.text.trim(),
                  descripcion: descController.text.trim(),
                  precioCompra: double.tryParse(pCompraController.text) ?? 0.0,
                  precioVenta: double.tryParse(pVentaController.text) ?? 0.0,
                  stock: double.tryParse(stockController.text) ?? 0.0,
                  idCategoria: selectedCategoryId,
                  estado: isActivo,
                  motivoInactivo: motivoController.text.trim(),
                );

                if (!context.mounted) return;
                Navigator.pop(context);

                CustomNotification.show(
                  context,
                  error == null ? "¡Producto Guardado!" : "Error: $error",
                  isSuccess: error == null,
                );
              },
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nombreController,
                    decoration: const InputDecoration(
                      labelText: "Nombre",
                      prefixIcon: Icon(Icons.shopping_bag_outlined),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: descController,
                    decoration: const InputDecoration(
                      labelText: "Descripción",
                      prefixIcon: Icon(Icons.description_outlined),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: pCompraController,
                          decoration: const InputDecoration(
                            labelText: "P. Compra",
                            prefixIcon: Icon(Icons.arrow_downward, size: 18),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          controller: pVentaController,
                          decoration: const InputDecoration(
                            labelText: "P. Venta",
                            prefixIcon: Icon(Icons.arrow_upward, size: 18),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: stockController,
                    decoration: const InputDecoration(
                      labelText: "Stock Inicial",
                      prefixIcon: Icon(Icons.inventory_2_outlined),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),
                  // Selector de Estado
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Estado:",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ToggleButtons(
                        isSelected: [isActivo, !isActivo],
                        onPressed: (index) {
                          setStateDialog(() => isActivo = index == 0);
                        },
                        borderRadius: BorderRadius.circular(10),
                        selectedColor: Colors.white,
                        fillColor: isActivo ? Colors.green : Colors.red,
                        children: const [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text("Activo"),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: Text("Inactivo"),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (!isActivo) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: motivoController,
                      decoration: const InputDecoration(
                        labelText: "Motivo de inactividad",
                        prefixIcon: Icon(Icons.warning_amber_rounded),
                      ),
                    ),
                  ],
                  const SizedBox(height: 15),
                  if (invProvider.categories.isNotEmpty)
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: "Categoría"),
                      value: selectedCategoryId,
                      items: invProvider.categories.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat['id_categoria'].toString(),
                          child: Text(cat['nombre_categoria'] ?? 'Sin nombre'),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setStateDialog(() => selectedCategoryId = val);
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
