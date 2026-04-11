import 'package:nova_ferre/nova_ferre_exports.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  final List<String> _viewNames = [
    'Ventas',
    'Inventario',
    'Logística',
    'Dashboard',
    'Configuración',
  ];
  final List<Widget> _views = [
    const SalesView(),
    const InventoryView(),
    const LogisticsView(),
    const DashboardView(),
    const SettingsView(),
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width >= 900;

    final bool showBottomBar = !isDesktop && navProvider.currentIndex != 4;

    return PopScope(
      canPop: navProvider.currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        navProvider.setIndex(0);
      },
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Solo botón de retroceso si estamos en Configuración
          Widget? leadingWidget;
          if (navProvider.currentIndex == 4) {
            leadingWidget = IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => navProvider.setIndex(0),
            );
          }

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minWidth: 360,
                maxWidth: size.width > 360 ? size.width : 360,
                minHeight: size.height,
              ),
              child: Scaffold(
                appBar: AppBar(
                  toolbarHeight: 70,
                  backgroundColor: const Color.fromARGB(255, 44, 49, 54),
                  elevation: 0,
                  leading: leadingWidget,
                  title: Row(
                    children: [
                      Image.asset("assets/images/logoDarkPng.png", height: 40),
                      const SizedBox(width: 8),
                      if (constraints.maxWidth > 300)
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FittedBox(
                                child: RichText(
                                  text: const TextSpan(
                                    text: "Nova",
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: " Ferre",
                                        style: TextStyle(
                                          color: Color.fromARGB(
                                            255,
                                            230,
                                            104,
                                            60,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Text(
                                _viewNames[navProvider.currentIndex],
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  actions: [
                    if (isDesktop && constraints.maxWidth >= 850) ...[
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
                    ],
                    Padding(
                      padding: const EdgeInsets.only(left: 5, right: 15),
                      child: IconButton(
                        onPressed: () => navProvider.setIndex(4),
                        icon: CircleAvatar(
                          radius: 17,
                          backgroundColor: navProvider.currentIndex == 4
                              ? const Color.fromARGB(255, 230, 104, 60)
                              : Colors.white12,
                          child: const Icon(
                            Icons.person_outline,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Drawer eliminado completamente
                body: IndexedStack(
                  index: navProvider.currentIndex,
                  children: _views,
                ),
                bottomNavigationBar: showBottomBar
                    ? BottomNavigationBar(
                        currentIndex: navProvider.currentIndex,
                        onTap: (index) => navProvider.setIndex(index),
                        type: BottomNavigationBarType.fixed,
                        backgroundColor: const Color.fromARGB(255, 44, 49, 54),
                        selectedItemColor: const Color.fromARGB(
                          255,
                          230,
                          104,
                          60,
                        ),
                        unselectedItemColor: Colors.grey,
                        showUnselectedLabels: false,
                        items: const [
                          BottomNavigationBarItem(
                            icon: Icon(Icons.shopping_cart_outlined),
                            label: "Ventas",
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.inventory_2_outlined),
                            label: "Stock",
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.local_shipping_outlined),
                            label: "Logística",
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(Icons.analytics_outlined),
                            label: "Panel",
                          ),
                        ],
                      )
                    : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    int index,
    String label,
    IconData icon,
    int currentIndex,
  ) {
    if (currentIndex == index) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
      child: OutlinedButton.icon(
        onPressed: () => context.read<NavigationProvider>().setIndex(index),
        icon: Icon(icon, size: 15),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Color.fromARGB(255, 230, 104, 60)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
