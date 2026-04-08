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
      title: 'NovaFerre',

      // Configuración básica del Tema (Dark Mode)
      /*theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color(0xFF155DFC), // Tu azul vibrante
      ),*/

      // Apuntamos directo al MainLayout que vas a crear
      home: const MainLayout(),
    );
  }
}
