import 'package:nova_ferre/nova_ferre_exports.dart';

class SalesView extends StatefulWidget {
  const SalesView({super.key});

  @override
  State<SalesView> createState() => _SalesViewState();
}

class _SalesViewState extends State<SalesView> {
  bool _isGridView = true;
  String _selectedCategory = "Todos";

  final List<String> _categories = [
    "Todos",
    "Herramientas",
    "Pinturas",
    "Electricidad",
    "Plomería",
    "Tornillería",
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SalesProvider>().fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final salesProvider = context.watch<SalesProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return constraints.maxWidth > 800
              ? _buildDesktopLayout(context, salesProvider)
              : _buildMobileLayout(context, salesProvider);
        },
      ),
    );
  }

  // --- DISEÑOS DE PANTALLA ---
  Widget _buildDesktopLayout(BuildContext context, SalesProvider sales) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _buildCatalogo(context, sales, isMobile: false),
        ),
        VerticalDivider(width: 1, color: Colors.grey.withOpacity(0.2)),
        SizedBox(width: 350, child: _buildCarrito(context, sales)),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, SalesProvider sales) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: _buildCatalogo(context, sales, isMobile: true),
        ),
        const Divider(height: 1),
        Expanded(flex: 2, child: _buildCarrito(context, sales)),
      ],
    );
  }

  // --- CATÁLOGO ---
  Widget _buildCatalogo(
    BuildContext context,
    SalesProvider sales, {
    required bool isMobile,
  }) {
    final filteredProducts = _selectedCategory == "Todos"
        ? sales.products
        : sales.products
              .where((p) => p.nombreCategoria == _selectedCategory)
              .toList();

    return Column(
      children: [
        _buildTopBar(isMobile),
        Expanded(
          child: sales.isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Color(0xFFE6683C)),
                )
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: _isGridView
                      ? _buildGrid(filteredProducts, sales)
                      : _buildList(filteredProducts, sales),
                ),
        ),
      ],
    );
  }

  Widget _buildGrid(List<ProductModel> products, SalesProvider sales) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final p = products[index];
        return ProductCard(
          sku: p.id,
          name: p.nombre,
          price: p.precioVenta,
          category: p.nombreCategoria,
          isGridView: true,
          onAdd: () => sales.addToCart(p),
        );
      },
    );
  }

  Widget _buildList(List<ProductModel> products, SalesProvider sales) {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        final p = products[index];
        return ProductCard(
          sku: p.id,
          name: p.nombre,
          price: p.precioVenta,
          category: p.nombreCategoria,
          isGridView: false,
          onAdd: () => sales.addToCart(p),
        );
      },
    );
  }

  // --- CARRITO ---
  Widget _buildCarrito(BuildContext context, SalesProvider sales) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildCartHeader(sales),
          Expanded(
            child: sales.cart.isEmpty
                ? const Center(
                    child: Text(
                      "Carrito vacío",
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: sales.cart.length,
                    itemBuilder: (context, index) {
                      final item = sales.cart[index];
                      return CartItemTile(
                        name: item.product.nombre,
                        price: item.product.precioVenta,
                        // SOLUCIÓN AL ERROR: Convertimos double a int para el widget
                        quantity: item.quantity.toInt(),
                        onRemove: () => sales.removeFromCart(item.product.id),
                      );
                    },
                  ),
          ),
          _buildCheckoutSection(context, sales),
        ],
      ),
    );
  }

  // --- COMPONENTES DE LA INTERFAZ ---
  Widget _buildCartHeader(SalesProvider sales) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          const Icon(Icons.shopping_bag_outlined, color: Color(0xFFE6683C)),
          const SizedBox(width: 8),
          const Text("Resumen", style: TextStyle(fontWeight: FontWeight.bold)),
          const Spacer(),
          if (sales.cart.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
              onPressed: () => sales.clearCart(),
            ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection(BuildContext context, SalesProvider sales) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Total:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "\$${sales.total.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFE6683C),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE6683C),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: sales.cart.isEmpty
                ? null
                : () => _showCheckoutDialog(context, sales),
            child: const Text("COBRAR", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // --- MÉTODOS DE LA BARRA SUPERIOR ---
  Widget _buildTopBar(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Row(
        children: [
          Expanded(child: _buildFilterScroll()),
          const SizedBox(width: 8),
          _buildLayoutToggle(),
        ],
      ),
    );
  }

  Widget _buildFilterScroll() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _categories.map((cat) {
          bool isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(
                cat,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              selected: isSelected,
              onSelected: (val) => setState(() => _selectedCategory = cat),
              selectedColor: const Color(0xFFE6683C),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLayoutToggle() {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            Icons.grid_view,
            color: _isGridView ? const Color(0xFFE6683C) : Colors.grey,
          ),
          onPressed: () => setState(() => _isGridView = true),
        ),
        IconButton(
          icon: Icon(
            Icons.view_list,
            color: !_isGridView ? const Color(0xFFE6683C) : Colors.grey,
          ),
          onPressed: () => setState(() => _isGridView = false),
        ),
      ],
    );
  }

  void _showCheckoutDialog(BuildContext context, SalesProvider sales) {
    final nameController = TextEditingController(text: "Cliente General");
    final auth = context.read<AuthProvider>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirmar Venta"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: "Nombre del Cliente"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            // Deshabilitamos el botón si el nombre está vacío o si ya está cargando
            onPressed: (sales.isLoading || nameController.text.trim().isEmpty)
                ? null
                : () async {
                    final ok = await sales.processSale(
                      userId: auth.user!.id,
                      clienteNombre: nameController.text.trim(),
                    );

                    if (!mounted) return;

                    // Cerramos el diálogo
                    Navigator.pop(context);

                    // Mostramos el resultado
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ok ? "¡Venta NF Exitosa!" : "Error al procesar venta",
                        ),
                        backgroundColor: ok ? Colors.green : Colors.redAccent,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
            child: sales.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text("Vender"),
          ),
        ],
      ),
    );
  }
}
