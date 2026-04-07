import 'package:nova_ferre/nova_ferre_exports.dart';

// Importaremos tus vistas aquí (por ahora usaremos Placeholders)
// import 'views/sales/sales_view.dart';
// import 'views/inventory/inventory_view.dart';
// ...

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // 1. El "cerebro" de la navegación
  int _currentIndex = 0;

  // 2. Lista de nombres para el título dinámico
  final List<String> _viewNames = [
    'Ventas y Facturación',
    'Gestión de Inventario',
    'Logística y Entregas',
    'Panel de Control Gerencial',
  ];

  // 3. Las pantallas que se mostrarán (Placeholder por ahora)
  final List<Widget> _views = [
    const Center(child: Text("Pantalla de Ventas")),
    const Center(child: Text("Pantalla de Inventario")),
    const Center(child: Text("Pantalla de Logística")),
    const Center(child: Text("Pantalla de Dashboard")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: const Color.fromARGB(255, 44, 49, 54),
        elevation: 0,

        // --- PARTE IZQUIERDA: LOGO Y TEXTO ---
        title: Row(
          children: [
            Image.asset("assets/images/logoDarkPng.png", height: 60),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Nova Ferre",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 1.2,
                  ),
                ),
                Text(
                  "Sección: ${_viewNames[_currentIndex]}",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color.fromARGB(255, 182, 178, 178),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),

        // --- PARTE DERECHA: BOTONES DE NAVEGACIÓN ---
        actions: [
          _buildNavButton(0, "Ventas", Icons.shopping_cart_outlined),
          _buildNavButton(1, "Inventario", Icons.inventory_2_outlined),
          _buildNavButton(2, "Logística", Icons.local_shipping_outlined),
          _buildNavButton(3, "Dashboard", Icons.analytics_outlined),
          const SizedBox(width: 20),
        ],
      ),

      // --- CUERPO: PERSISTENCIA DE PANTALLAS ---
      body: IndexedStack(index: _currentIndex, children: _views),
    );
  }

  // Widget personalizado para los botones de navegación
  Widget _buildNavButton(int index, String label, IconData icon) {
    // REGLA DE ORO: Si es la pantalla activa, el botón desaparece
    if (_currentIndex == index) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 18),
      child: OutlinedButton.icon(
        onPressed: () {
          setState(() {
            _currentIndex = index; // Cambia la pantalla y redibuja
          });
        },
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(
            color: Color(0xFF155DFC),
            width: 1.5,
          ), // Borde azul NovaFerre
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
      ),
    );
  }
}
