import 'package:nova_ferre/nova_ferre_exports.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().fetchMetrics();
      context.read<UserProvider>().fetchUsersAndRoles();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dash = context.watch<DashboardProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      body: RefreshIndicator(
        onRefresh: () => dash.fetchMetrics(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Resumen General",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Fila de Tarjetas (KPIs)
              LayoutBuilder(
                builder: (context, constraints) {
                  return GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: constraints.maxWidth > 600 ? 3 : 1,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 2.5,
                    children: [
                      _kpiCard(
                        "Ventas de Hoy",
                        "\$${(dash.metrics['total_hoy'] as num).toStringAsFixed(2)}",
                        Icons.monetization_on,
                        Colors.green,
                      ),
                      _kpiCard(
                        "Stock Crítico",
                        "${dash.metrics['bajo_stock']} Prod.",
                        Icons.warning_amber_rounded,
                        Colors.red,
                      ),
                      _kpiCard(
                        "Por Despachar",
                        "${dash.metrics['pendientes']} Pedidos",
                        Icons.local_shipping,
                        Colors.orange,
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 30),
              const Text(
                "Acciones Rápidas",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),

              // Botonera de navegación rápida
              Wrap(
                spacing: 15,
                runSpacing: 15,
                children: [
                  _quickAction(
                    context,
                    "Nueva Venta",
                    Icons.add_shopping_cart,
                    const SalesView(),
                  ),
                  _quickAction(
                    context,
                    "Ver Inventario",
                    Icons.inventory_2,
                    const InventoryView(),
                  ),
                  _quickAction(
                    context,
                    "Logística",
                    Icons.delivery_dining,
                    const LogisticsView(),
                  ),
                ],
              ),

              const SizedBox(height: 40),
              const Text(
                "Gestión de Usuarios",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              _buildUserManagement(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kpiCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.1),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 15),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.grey, fontSize: 14),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _quickAction(
    BuildContext context,
    String label,
    IconData icon,
    Widget page,
  ) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      onPressed: () {
        // Aquí puedes usar tu sistema de navegación (Router o Navigator)
      },
      icon: Icon(icon, color: const Color(0xFFE6683C)),
      label: Text(label),
    );
  }

  Widget _buildUserManagement() {
    final userProv = context.watch<UserProvider>();

    if (userProv.isLoading && userProv.users.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Usuarios Registrados",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddUserDialog(context),
                icon: const Icon(Icons.person_add),
                label: const Text("Agregar Usuario"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6683C),
                  foregroundColor: Colors.white,
                ),
              )
            ],
          ),
          const SizedBox(height: 15),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: userProv.users.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final user = userProv.users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: user.estadoUsuario ? const Color(0xFFF5F7F9) : Colors.red.withValues(alpha: 0.1),
                  child: Text(
                    user.nombreCompleto.substring(0, 1),
                    style: TextStyle(
                      fontWeight: FontWeight.bold, 
                      color: user.estadoUsuario ? Colors.black87 : Colors.red,
                    ),
                  ),
                ),
                title: Text(
                  user.nombreCompleto,
                  style: TextStyle(
                    decoration: user.estadoUsuario ? TextDecoration.none : TextDecoration.lineThrough,
                    color: user.estadoUsuario ? Colors.black87 : Colors.grey,
                  ),
                ),
                subtitle: Text("Rol: ${user.rol} | ID: ${user.id}"),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.grey),
                  onPressed: () => _showEditUserDialog(context, user),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    final userProv = context.read<UserProvider>();
    final nombreController = TextEditingController();
    final pinController = TextEditingController();
    int? selectedRolId;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return CustomDialog(
              title: "Nuevo Usuario",
              subtitle: "Ingrese los datos del empleado",
              icon: Icons.person_add,
              confirmLabel: "Registrar",
              isLoading: userProv.isLoading,
              onConfirm: () async {
                if (nombreController.text.isEmpty ||
                    pinController.text.isEmpty ||
                    selectedRolId == null) {
                  return;
                }

                // Obtener el nombre del rol seleccionado
                final rolData = userProv.roles.firstWhere((r) => r['id_rol'] == selectedRolId);
                final areaAsignada = rolData['nombre_rol'] as String;

                final error = await userProv.addUser(
                  nombre: nombreController.text.trim(),
                  pin: pinController.text.trim(),
                  idRol: selectedRolId!,
                  areaAsignada: areaAsignada,
                );

                if (!context.mounted) return;
                Navigator.pop(context);

                CustomNotification.show(
                  context,
                  error == null ? "Usuario registrado" : "Error: $error",
                  isSuccess: error == null,
                );
              },
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nombreController,
                    decoration: const InputDecoration(labelText: "Nombre Completo", prefixIcon: Icon(Icons.person)),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: pinController,
                    decoration: const InputDecoration(labelText: "PIN (Contraseña)", prefixIcon: Icon(Icons.lock)),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  if (userProv.roles.isNotEmpty)
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: "Rol del Usuario"),
                      value: selectedRolId,
                      items: userProv.roles.map((rol) {
                        return DropdownMenuItem<int>(
                          value: rol['id_rol'],
                          child: Text(rol['nombre_rol']),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setStateDialog(() => selectedRolId = val);
                      },
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEditUserDialog(BuildContext context, UserModel user) {
    final userProv = context.read<UserProvider>();
    final nombreController = TextEditingController(text: user.nombreCompleto);
    final pinController = TextEditingController();
    bool estado = user.estadoUsuario;
    int? selectedRolId;

    // Buscar el ID del rol actual en base a su nombre
    try {
      final rolMatch = userProv.roles.firstWhere((r) => r['nombre_rol'] == user.rol);
      selectedRolId = rolMatch['id_rol'];
    } catch (_) {}

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return CustomDialog(
              title: "Editar Usuario",
              subtitle: "Modifique los datos de ${user.nombreCompleto}",
              icon: Icons.edit,
              confirmLabel: "Guardar",
              isLoading: userProv.isLoading,
              onConfirm: () async {
                if (nombreController.text.isEmpty || selectedRolId == null) {
                  return;
                }

                final error = await userProv.updateUser(
                  idUsuario: user.id,
                  nombre: nombreController.text.trim(),
                  pin: pinController.text.trim(),
                  idRol: selectedRolId!,
                  estado: estado,
                );

                if (!context.mounted) return;
                Navigator.pop(context);

                CustomNotification.show(
                  context,
                  error == null ? "Usuario actualizado" : "Error: $error",
                  isSuccess: error == null,
                );
              },
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nombreController,
                    decoration: const InputDecoration(labelText: "Nombre Completo", prefixIcon: Icon(Icons.person)),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: pinController,
                    decoration: const InputDecoration(labelText: "Nuevo PIN (Dejar vacío para no cambiar)", prefixIcon: Icon(Icons.lock)),
                    keyboardType: TextInputType.number,
                    obscureText: true,
                  ),
                  const SizedBox(height: 15),
                  if (userProv.roles.isNotEmpty)
                    DropdownButtonFormField<int>(
                      decoration: const InputDecoration(labelText: "Rol del Usuario"),
                      value: selectedRolId,
                      items: userProv.roles.map((rol) {
                        return DropdownMenuItem<int>(
                          value: rol['id_rol'],
                          child: Text(rol['nombre_rol']),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setStateDialog(() => selectedRolId = val);
                      },
                    ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Estado:", style: TextStyle(fontWeight: FontWeight.bold)),
                      Switch(
                        value: estado,
                        onChanged: (val) {
                          setStateDialog(() => estado = val);
                        },
                        activeColor: Colors.green,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
