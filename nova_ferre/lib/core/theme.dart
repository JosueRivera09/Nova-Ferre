import 'package:nova_ferre/nova_ferre_exports.dart';

class NovaFerreTheme {
  static const Color accentColor = Color(0xFF155DFC);

  // --- TEMA OSCURO (El principal de NovaFerre) ---
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorSchemeSeed: accentColor,
    scaffoldBackgroundColor: const Color(0xFF0F0F0F), // Casi negro
    textTheme: GoogleFonts.montserratTextTheme(ThemeData.dark().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      elevation: 0,
    ),
  );

  // --- TEMA CLARO (Para ambientes muy iluminados) ---
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorSchemeSeed: accentColor,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    textTheme: GoogleFonts.montserratTextTheme(ThemeData.light().textTheme),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 1,
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
