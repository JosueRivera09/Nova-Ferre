import 'dart:ui';
import 'package:nova_ferre/nova_ferre_exports.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  // 1. Controlador persistente para la barra de búsqueda
  final TextEditingController _searchController = TextEditingController();
  String? _activeOverlay;

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
  void dispose() {
    // 2. Siempre liberar el controlador
    _searchController.dispose();
    super.dispose();
  }

  void _toggleOverlay(String panel) {
    setState(() {
      _activeOverlay = (_activeOverlay == panel) ? null : panel;
    });
  }

  void _onNavigate(int index) {
    final nav = context.read<NavigationProvider>();
    if (nav.currentIndex == index) return;

    nav.setIndex(index);

    // Refrescar datos según la pestaña seleccionada
    if (index == 0) {
      context.read<SalesProvider>().fetchProducts();
    } else if (index == 1) {
      context.read<InventoryProvider>().fetchInventory();
    } else if (index == 2) {
      context.read<LogisticsProvider>().fetchPendingDeliveries();
    } else if (index == 3) {
      context.read<DashboardProvider>().fetchMetrics();
    }
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = context.watch<NavigationProvider>();
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    const barColor = Color(0xFF2C3136);
    const accentColor = Color(0xFFE6683C);

    return PopScope(
      canPop: navProvider.currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        navProvider.setIndex(0);
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7F9),
        body: Row(
          children: [
            if (isDesktop) _buildSidebar(navProvider, barColor),
            Expanded(
              child: Column(
                children: [
                  _buildHeader(
                    navProvider,
                    isDesktop,
                    barColor,
                    _activeOverlay,
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        IgnorePointer(
                          ignoring: isDesktop && _activeOverlay != null,
                          child: IndexedStack(
                            index: navProvider.currentIndex,
                            children: _views,
                          ),
                        ),
                        if (isDesktop && _activeOverlay != null)
                          _buildBlurOverlay(),
                        if (isDesktop && _activeOverlay != null)
                          Align(
                            alignment: Alignment.topRight,
                            child: SidePanelOverlay(
                              title: _activeOverlay!,
                              onClose: () =>
                                  setState(() => _activeOverlay = null),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: !isDesktop
            ? _buildMobileNav(navProvider, barColor, accentColor)
            : null,
      ),
    );
  }

  // --- ESTRUCTURA DEL HEADER ACTUALIZADA ---

  Widget _buildHeader(
    NavigationProvider nav,
    bool isDesktop,
    Color color,
    String? activeOverlay,
  ) {
    return Container(
      color: color,
      child: SafeArea(
        bottom: false,
        child: Container(
          height: 70,
          padding: EdgeInsets.symmetric(horizontal: isDesktop ? 20 : 10),
          child: Row(
            children: [
              if (!isDesktop) ...[
                Image.asset("assets/images/logoDarkPng.png", height: 30),
                const SizedBox(width: 8),
              ],
              Expanded(
                child: Text(
                  _viewNames[nav.currentIndex],
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              // 3. Pasamos el controlador y una función para refrescar la UI (mostrar/ocultar 'X')
              if (isDesktop)
                SearchBox(
                  controller: _searchController,
                  onChanged: (val) {
                    nav.setSearchQuery(val);
                  },
                ),

              HeaderIcon(
                icon: Icons.notifications_none_outlined,
                isActive: activeOverlay == 'Notificaciones',
                onTap: () =>
                    isDesktop ? _toggleOverlay('Notificaciones') : null,
              ),
              HeaderIcon(
                icon: Icons.settings_outlined,
                isActive: activeOverlay == 'Ajustes',
                onTap: () =>
                    isDesktop ? _toggleOverlay('Ajustes') : _onNavigate(4),
              ),
              HeaderIcon(
                icon: Icons.person_outline,
                isActive: isDesktop
                    ? activeOverlay == 'Perfil'
                    : nav.currentIndex == 4,
                onTap: () =>
                    isDesktop ? _toggleOverlay('Perfil') : _onNavigate(4),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- RESTO DE MÉTODOS DE APOYO ---

  Widget _buildSidebar(NavigationProvider nav, Color color) {
    return Container(
      width: 160,
      color: color,
      child: Column(
        children: [
          const SizedBox(height: 5),
          Image.asset("assets/images/logoDarkPng.png", height: 60),
          Image.asset("assets/images/logoLetrasPng.png", width: 100),
          const SizedBox(height: 40),
          SidebarItem(
            index: 0,
            currentIndex: nav.currentIndex,
            icon: Icons.shopping_cart_outlined,
            label: "Ventas",
            onTap: _onNavigate,
          ),
          SidebarItem(
            index: 1,
            currentIndex: nav.currentIndex,
            icon: Icons.inventory_2_outlined,
            label: "Inventario",
            onTap: _onNavigate,
          ),
          SidebarItem(
            index: 2,
            currentIndex: nav.currentIndex,
            icon: Icons.local_shipping_outlined,
            label: "Logística",
            onTap: _onNavigate,
          ),
          SidebarItem(
            index: 3,
            currentIndex: nav.currentIndex,
            icon: Icons.analytics_outlined,
            label: "Dashboard",
            onTap: _onNavigate,
          ),
          const Spacer(),
          SidebarItem(
            index: 5,
            currentIndex: nav.currentIndex,
            icon: Icons.help_outline,
            label: "Soporte",
            onTap: (i) async {
              final url = Uri.parse('https://wa.me/+50586234079');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
          ),
          SidebarItem(
            index: 6,
            currentIndex: nav.currentIndex,
            icon: Icons.logout,
            label: "Salir",
            isLogout: true,
            onTap: (i) async {
              // Limpiar datos guardados
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('saved_id');
              await prefs.remove('saved_pin');
              
              if (!context.mounted) return;
              context.read<AuthProvider>().logout();
              
              // Navegar al Login limpiando el stack
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginView()),
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBlurOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => setState(() => _activeOverlay = null),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Container(color: Colors.black.withValues(alpha: 0.05)),
        ),
      ),
    );
  }

  Widget _buildMobileNav(
    NavigationProvider nav,
    Color barColor,
    Color accentColor,
  ) {
    return BottomNavigationBar(
      currentIndex: nav.currentIndex >= 4 ? 0 : nav.currentIndex,
      onTap: _onNavigate,
      type: BottomNavigationBarType.fixed,
      backgroundColor: barColor,
      selectedItemColor: accentColor,
      unselectedItemColor: Colors.white60,
      showUnselectedLabels: true,
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
    );
  }
}
