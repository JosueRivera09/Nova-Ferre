import 'package:nova_ferre/nova_ferre_exports.dart';

class InventoryView extends StatefulWidget {
  const InventoryView({super.key});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  @override
  void initState() {
    super.initState();
    // Llamada al provider al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryProvider>().fetchInventory();
    });
  }

  @override
  Widget build(BuildContext context) {
    final invProvider = context.watch<InventoryProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Control de Inventario",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
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
                Expanded(child: _buildInventoryTable(invProvider.inventory)),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFE6683C),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddProductDialog(context),
      ),
    );
  }

  Widget _buildHeaderStats(List<ProductModel> products) {
    final lowStockCount = products
        .where((p) => p.stock <= 5)
        .length; // Ejemplo stock min

    return Container(
      padding: const EdgeInsets.all(20),
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
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryTable(List<ProductModel> products) {
    return ListView.separated(
      itemCount: products.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final p = products[index];
        bool isLowStock =
            p.stock <=
            5; // Aquí podrías usar p.stockMinimo si lo agregaste al modelo

        return ListTile(
          leading: CircleAvatar(
            backgroundColor: isLowStock
                ? Colors.red.withOpacity(0.1)
                : const Color(0xFFF5F7F9),
            child: Text(
              p.id.substring(0, 3),
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(
            p.nombre,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("${p.nombreCategoria} • SKU: ${p.id}"),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                "${p.stock} und.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isLowStock ? Colors.red : Colors.green,
                ),
              ),
              Text(
                "\$${p.precioVenta.toStringAsFixed(2)}",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          onTap: () => _showEditStockDialog(context, p),
        );
      },
    );
  }

  // --- DIÁLOGOS (PLACEHOLDERS PARA CONECTAR) ---
  void _showEditStockDialog(BuildContext context, ProductModel p) {
    // Aquí irá la lógica para aumentar/disminuir stock
  }

  void _showAddProductDialog(BuildContext context) {
    // Aquí irá el formulario para insertar nuevo producto
  }
}
