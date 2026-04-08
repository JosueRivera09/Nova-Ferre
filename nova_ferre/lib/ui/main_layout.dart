import 'package:nova_ferre/nova_ferre_exports.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // 1. Lista de nombres para el título dinámico
  final List<String> _viewNames = [
    'Ventas',
    'Inventario',
    'Logística',
    'Dashboard',
  ];

  // dirección de las vistas (orden debe coincidir con los botones de navegación)
  final List<Widget> _views = [
    const SalesView(),
    const InventoryView(),
    const LogisticsView(),
    const DashboardView(),
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final isDesktop = MediaQuery.of(context).size.width >= 800;

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
                RichText(
                  text: TextSpan(
                    text: "Nova",
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: " Ferre",
                        style: const TextStyle(
                          fontSize: 25,
                          color: Color.fromARGB(255, 230, 104, 60),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  " ${_viewNames[navProvider.currentIndex]}",
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
        actions: isDesktop
            ? [
                _buildNavButton(
                  context,
                  0,
                  "Ventas",
                  Icons.shopping_cart_outlined,
                  navProvider.currentIndex,
                ),
                _buildNavButton(
                  context,
                  1,
                  "Inventario",
                  Icons.inventory_2_outlined,
                  navProvider.currentIndex,
                ),
                _buildNavButton(
                  context,
                  2,
                  "Logística",
                  Icons.local_shipping_outlined,
                  navProvider.currentIndex,
                ),
                _buildNavButton(
                  context,
                  3,
                  "Dashboard",
                  Icons.analytics_outlined,
                  navProvider.currentIndex,
                ),
                const SizedBox(width: 20),
              ]
            : null,
      ),

      // --- CUERPO: PERSISTENCIA DE PANTALLAS ---
      body: IndexedStack(index: navProvider.currentIndex, children: _views),

      // --- NAVEGACIÓN MÓVIL ---
      bottomNavigationBar: !isDesktop
          ? BottomNavigationBar(
              currentIndex: navProvider.currentIndex,
              onTap: (index) =>
                  context.read<NavigationProvider>().setIndex(index),
              type: BottomNavigationBarType.fixed,
              backgroundColor: const Color.fromARGB(255, 44, 49, 54),
              selectedItemColor: const Color.fromARGB(255, 230, 104, 60),
              unselectedItemColor: Colors.grey,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_cart_outlined),
                  label: "Ventas",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.inventory_2_outlined),
                  label: "Inventario",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.local_shipping_outlined),
                  label: "Logística",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.analytics_outlined),
                  label: "Dashboard",
                ),
              ],
            )
          : null,
    );
  }

  // Widget personalizado para los botones de navegación
  Widget _buildNavButton(
    BuildContext context,
    int index,
    String label,
    IconData icon,
    int currentIndex,
  ) {
    // REGLA DE ORO: Si es la pantalla activa, el botón desaparece
    if (currentIndex == index) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 18),
      child: OutlinedButton.icon(
        onPressed: () {
          context.read<NavigationProvider>().setIndex(index);
        },
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(
            color: Color.fromARGB(255, 230, 104, 60),
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
