import 'package:nova_ferre/nova_ferre_exports.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _idController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 44, 49, 54),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 400,
            ), // Ancho para Web/Desktop
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Image.asset('assets/images/logoDarkPng.png', height: 120),

                  Image.asset('assets/images/logoLetrasPng.png', width: 220),
                  const SizedBox(height: 20),

                  const Text(
                    "Iniciar Sesión",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Campo de ID
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _idController,
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      focusColor: Color.fromARGB(255, 230, 104, 60),
                      errorStyle: TextStyle(color: Color(0xFFFFC107)),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: Color(0xFFFFC107)),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: Color(0xFFFFC107)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 230, 104, 60),
                        ),
                      ),
                      labelText: "ID de Usuario",
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.white,
                      ),
                      border: OutlineInputBorder(),
                      labelStyle: TextStyle(color: Colors.white),
                    ),
                    validator: (value) {
                      if (value == null || value.length != 6) {
                        return "El ID debe tener exactamente 6 caracteres";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),

                  // Campo de Contraseña
                  TextFormField(
                    style: TextStyle(color: Colors.white),
                    controller: _passwordController,
                    obscureText: true,

                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      errorStyle: TextStyle(color: Color(0xFFFFC107)),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: Color(0xFFFFC107)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 230, 104, 60),
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        borderSide: BorderSide(color: Color(0xFFFFC107)),
                      ),
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: "Contraseña",
                      prefixIcon: Icon(Icons.lock_outline, color: Colors.white),
                      border: OutlineInputBorder(),
                    ),

                    validator: (value) => (value == null || value.length < 6)
                        ? "Mínimo 6 caracteres"
                        : null,
                  ),
                  const SizedBox(height: 30),
                  const SizedBox(
                    width: 500,
                    child: Row(
                      children: [
                        Checkbox(
                          value: true,
                          onChanged: null,
                          side: BorderSide(color: Colors.white),
                          fillColor: WidgetStateProperty.fromMap({
                            WidgetState.selected: Color.fromARGB(
                              255,
                              230,
                              104,
                              60,
                            ),
                            WidgetState.hovered: Color.fromARGB(
                              255,
                              230,
                              104,
                              60,
                            ),
                            WidgetState.focused: Color.fromARGB(
                              255,
                              230,
                              104,
                              60,
                            ),
                          }),
                        ),
                        Text(
                          "Recuerdame",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),

                  // Botón de Acción
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 230, 104, 60),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Validación sencilla
                          if (_idController.text == '123456' &&
                              _passwordController.text == '123456') {
                            // Si es correcto, navegamos al Home
                            print("Acceso concedido a Nova Ferre");

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainLayout(),
                              ),
                            );
                          } else {
                            // Si es incorrecto, mostramos un aviso
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("ID o contraseña incorrectos"),
                                backgroundColor: Colors
                                    .amber, // Usando el color de advertencia que elegimos
                              ),
                            );
                          }
                        }
                      },
                      child: const Text(
                        "INGRESAR",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
