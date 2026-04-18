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
    "Construcción",
    "Electricidad",
    "Fontanería",
    "Pintura",
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return constraints.maxWidth > 700
            ? _buildDesktopLayout(context)
            : _buildMobileLayout(context);
      },
    );
  }

  // --- DISEÑOS ---
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 3, child: _buildCatalogo(context, isMobile: false)),
        VerticalDivider(width: 1, color: Colors.grey.withOpacity(0.2)),
        Expanded(flex: 2, child: _buildCarrito(context)),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
        Expanded(flex: 3, child: _buildCatalogo(context, isMobile: true)),
        const Divider(height: 1),
        Expanded(flex: 2, child: _buildCarrito(context)),
      ],
    );
  }

  // --- CATÁLOGO ---
  Widget _buildCatalogo(BuildContext context, {required bool isMobile}) {
    return Column(
      children: [
        _buildTopBar(isMobile),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: _isGridView ? _buildGrid() : _buildList(),
          ),
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 0.8,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 6, // Simulando datos
      itemBuilder: (context, index) => ProductCard(
        sku: "HER-26-000$index",
        name: "Producto de ejemplo $index",
        price: 25.50,
        category: "Herramientas",
        isGridView: true,
        onAdd: () {},
      ),
    );
  }

  Widget _buildList() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) => ProductCard(
        sku: "PIN-26-000$index",
        name: "Pintura Acrílica Pro $index",
        price: 45.00,
        category: "Pintura",
        isGridView: false,
        onAdd: () {},
      ),
    );
  }

  // --- CARRITO ---
  Widget _buildCarrito(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildCartHeader(),
          Expanded(
            child: ListView.builder(
              itemCount: 0, // Aquí irá salesProvider.items.length
              itemBuilder: (context, index) => CartItemTile(
                name: "Martillo Pro",
                price: 15.0,
                quantity: 2,
                onRemove: () {},
              ),
              // Mientras esté vacío:
              padding: EdgeInsets.zero,
            ),
          ),
          if (0 == 0) // Placeholder cuando no hay items
            const Expanded(
              child: Center(
                child: Text(
                  "Carrito vacío",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          _buildCheckoutSection(),
        ],
      ),
    );
  }

  // --- SUB-WIDGETS ---
  Widget _buildCartHeader() {
    return const Padding(
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(Icons.shopping_bag_outlined, color: Color(0xFFE6683C)),
          SizedBox(width: 8),
          Text(
            "Resumen de Venta",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                "\$0.00",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            onPressed: () {},
            child: const Text(
              "COBRAR",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(12),
      color: Colors.white,
      child: Column(
        children: [
          if (isMobile) ...[
            SizedBox(
              height: 40,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Buscar...",
                  prefixIcon: const Icon(
                    Icons.search,
                    size: 20,
                    color: Color(0xFFE6683C),
                  ),
                  filled: true,
                  fillColor: const Color(0xFFF5F7F9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          Row(
            children: [
              Expanded(child: _buildFilterScroll()),
              const SizedBox(width: 8),
              _buildLayoutToggle(),
            ],
          ),
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
                  fontSize: 11,
                ),
              ),
              selected: isSelected,
              onSelected: (val) => setState(() => _selectedCategory = cat),
              selectedColor: const Color(0xFFE6683C),
              backgroundColor: const Color(0xFFF5F7F9),
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLayoutToggle() {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          _buildLayoutIcon(Icons.grid_view_rounded, true),
          _buildLayoutIcon(Icons.view_list_rounded, false),
        ],
      ),
    );
  }

  Widget _buildLayoutIcon(IconData icon, bool isGrid) {
    bool isSelected = _isGridView == isGrid;
    return GestureDetector(
      onTap: () => setState(() => _isGridView = isGrid),
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isSelected ? const Color(0xFFE6683C) : Colors.grey,
        ),
      ),
    );
  }
}
