import 'package:nova_ferre/nova_ferre_exports.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _pinController = TextEditingController();

  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final savedId = prefs.getString('saved_id');
    final savedPin = prefs.getString('saved_pin');

    if (savedId != null && savedPin != null) {
      setState(() {
        _idController.text = savedId;
        _pinController.text = savedPin;
        _rememberMe = true;
      });
      // Intentar auto login
      _handleLogin();
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    // 1. Validación local
    if (!_formKey.currentState!.validate()) return;

    // 2. Estado de carga
    setState(() => _isLoading = true);

    try {
      // 3. Obtener el Provider
      final authProvider = context.read<AuthProvider>();
      final id = int.tryParse(_idController.text) ?? 0;

      // 4. Intento de Login real en Supabase a través del Provider
      final success = await authProvider.login(id, _pinController.text);

      if (!mounted) return;

      if (success) {
        // Guardar o borrar credenciales según "Recordar"
        final prefs = await SharedPreferences.getInstance();
        if (_rememberMe) {
          await prefs.setString('saved_id', _idController.text);
          await prefs.setString('saved_pin', _pinController.text);
        } else {
          await prefs.remove('saved_id');
          await prefs.remove('saved_pin');
        }

        // ÉXITO: Navegamos al MainLayout limpiando el stack
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainLayout()),
          (route) => false,
        );
      } else {
        // ERROR: Credenciales inválidas
        CustomNotification.show(
          context, 
          "ID o PIN incorrectos. Verifique sus datos.", 
          isSuccess: false,
        );
      }
    } catch (e) {
      if (mounted) {
        CustomNotification.show(
          context, 
          "Error inesperado en el acceso", 
          isSuccess: false,
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2C3136),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // --- LOGOTIPOS ---
                  Image.asset('assets/images/logoDarkPng.png', height: 100),
                  const SizedBox(height: 10),
                  Image.asset('assets/images/logoLetrasPng.png', width: 180),
                  const SizedBox(height: 40),

                  const Text(
                    "Acceso al Sistema",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // --- INPUTS ---
                  AuthInputField(
                    controller: _idController,
                    label: "ID de Usuario",
                    icon: Icons.person_outline,
                    keyboardType: TextInputType.number,
                    validator: (v) => (v == null || v.length != 6)
                        ? "Ingrese su código de 6 dígitos"
                        : null,
                  ),
                  const SizedBox(height: 20),
                  AuthInputField(
                    controller: _pinController,
                    label: "PIN de Seguridad",
                    icon: Icons.lock_outline,
                    isPassword: true,
                    keyboardType: TextInputType.number,
                    validator: (v) =>
                        (v == null || v.length < 4) ? "Mínimo 4 dígitos" : null,
                  ),

                  const SizedBox(height: 15),

                  _buildRememberMe(),

                  const SizedBox(height: 40),

                  // --- BOTÓN DE ACCIÓN ---
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE6683C),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _isLoading ? null : _handleLogin,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "INGRESAR",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMe() {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: _rememberMe,
            activeColor: const Color(0xFFE6683C),
            side: const BorderSide(color: Colors.white54),
            onChanged: (val) => setState(() => _rememberMe = val!),
          ),
        ),
        const SizedBox(width: 10),
        const Text(
          "Recordar sesión",
          style: TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }
}
