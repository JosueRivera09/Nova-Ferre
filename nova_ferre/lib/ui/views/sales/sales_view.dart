import 'dart:ui';

import 'package:nova_ferre/ui/main/nova_ferre_exports.dart';

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
        VerticalDivider(width: 1, color: Colors.grey.withValues(alpha: 0.2)),
        SizedBox(width: 350, child: _buildCarrito(context, sales)),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, SalesProvider sales) {
    final screenHeight = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: screenHeight * 0.6,
            child: _buildCatalogo(context, sales, isMobile: true),
          ),
          const Divider(height: 1),
          SizedBox(
            height: screenHeight * 0.5,
            child: _buildCarrito(context, sales),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogo(
    BuildContext context,
    SalesProvider sales, {
    required bool isMobile,
  }) {
    final nav = context.watch<NavigationProvider>();
    final searchQuery = nav.searchQuery.toLowerCase();

    final filteredProducts = sales.products.where((p) {
      final matchesCategory =
          _selectedCategory == "Todos" ||
          p.nombreCategoria == _selectedCategory;
      final matchesSearch =
          p.nombre.toLowerCase().contains(searchQuery) ||
          p.id.toLowerCase().contains(searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();

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
        maxCrossAxisExtent: 180,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
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
          stock: p.stock,
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
          stock: p.stock,
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
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {PointerDeviceKind.touch, PointerDeviceKind.mouse},
      ),
      child: SingleChildScrollView(
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
      builder: (dialogContext) => Consumer<SalesProvider>(
        builder: (_, salesWatch, __) => CustomDialog(
          title: "Confirmar Cobro",
          subtitle: "Verifique los detalles antes de procesar",
          icon: Icons.shopping_cart_checkout_rounded,
          confirmLabel: "Cobrar Ahora",
          isLoading: salesWatch.isLoading,
          onConfirm: () async {
            final cliente = nameController.text.trim();
            if (cliente.isEmpty) return;

            final currentContext = context;

            final ok = await salesWatch.processSale(
              userId: auth.user!.id,
              clienteNombre: cliente,
            );

            if (!dialogContext.mounted) return;
            Navigator.pop(dialogContext);

            if (ok) {
              if (currentContext.mounted) {
                currentContext
                    .read<LogisticsProvider>()
                    .fetchPendingDeliveries();
                currentContext.read<DashboardProvider>().fetchMetrics();
                CustomNotification.show(
                  currentContext,
                  "¡Venta finalizada y stock actualizado!",
                  isSuccess: true,
                );
              }
            } else {
              if (currentContext.mounted) {
                CustomNotification.show(
                  currentContext,
                  "Error al procesar la venta",
                  isSuccess: false,
                );
              }
            }
          },
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Resumen del Total
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F7F9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Total a Pagar:",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Color(0xFF4F5D75),
                      ),
                    ),
                    Text(
                      "\$${salesWatch.total.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE6683C),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Campo del Cliente
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Nombre del Cliente",
                  hintText: "Ej. Juan Pérez",
                  prefixIcon: const Icon(Icons.person_outline_rounded),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                      color: Color(0xFFE6683C),
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
