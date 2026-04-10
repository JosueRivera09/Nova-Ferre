import 'nova_ferre_exports.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NavigationProvider())],
      child: const NovaFerreApp(),
    ),
  );
}

class NovaFerreApp extends StatelessWidget {
  const NovaFerreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "NovaFerre",

      // Apuntamos directo al MainLayout que vas a crear
      //home: const MainLayout(),
      // Ejemplo de flujo real
      home: const LoginView(),
    );
  }
}
