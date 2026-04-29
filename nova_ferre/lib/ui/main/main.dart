import 'nova_ferre_exports.dart';

void main() async {
  // 1. Asegura que los bindings de Flutter estén listos para tareas asíncronas
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializa Supabase con las credenciales de tu proyecto
  // Estas constantes deben estar definidas en lib/core/constants.dart
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  runApp(
    MultiProvider(
      providers: [
        // Control de navegación
        ChangeNotifierProvider(create: (_) => NavigationProvider()),

        // El cerebro de la sesión (Login, Roles, Usuario actual)
        ChangeNotifierProvider(create: (_) => AuthProvider()),

        // Control de ventas y carrito
        ChangeNotifierProvider(create: (_) => SalesProvider()),

        // Gestión de inventario
        ChangeNotifierProvider(create: (_) => InventoryProvider()),

        // logistica manejo de estado
        ChangeNotifierProvider(create: (_) => LogisticsProvider()),

        //dashboard control
        ChangeNotifierProvider(create: (_) => DashboardProvider()),

        // Gestión de usuarios
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: const NovaFerreApp(),
    ),
  );
}

class NovaFerreApp extends StatelessWidget {
  const NovaFerreApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3. Obtenemos el estado de autenticación para decidir qué pantalla mostrar
    final authProvider = context.watch<AuthProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Nova-Ferre",

      // Aplicamos el visual de la marca
      // theme: AppTheme.lightTheme, // Definido en lib/core/theme.dart
      //darkTheme: AppTheme.darkTheme,

      // Lógica de acceso:
      // Si el usuario está autenticado va al MainLayout, si no, al Login.
      home: authProvider.isAuthenticated
          ? const MainLayout()
          : const LoginView(),
    );
  }
}
