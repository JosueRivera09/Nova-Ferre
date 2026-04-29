import 'package:nova_ferre/nova_ferre_exports.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InventoryProvider>().fetchCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    final invProv = context.watch<InventoryProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        title: const Text("Configuración", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Gestión de Categorías",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Categorías de Inventario",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showAddCategoryDialog(context),
                        icon: const Icon(Icons.add),
                        label: const Text("Agregar"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE6683C),
                          foregroundColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 15),
                  if (invProv.isLoading && invProv.categories.isEmpty)
                    const Center(child: CircularProgressIndicator())
                  else if (invProv.categories.isEmpty)
                    const Text("No hay categorías registradas")
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: invProv.categories.length,
                      separatorBuilder: (context, index) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final cat = invProv.categories[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: const Color(0xFFF5F7F9),
                            child: const Icon(Icons.category, color: Colors.grey),
                          ),
                          title: Text(cat['nombre_categoria']),
                          subtitle: Text("Prefijo: ${cat['prefijo']}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.grey),
                            onPressed: () => _showEditCategoryDialog(context, cat),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddCategoryDialog(BuildContext context) {
    final invProv = context.read<InventoryProvider>();
    final nombreController = TextEditingController();
    final prefijoController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: "Nueva Categoría",
          subtitle: "Ingrese los datos de la categoría",
          icon: Icons.category,
          confirmLabel: "Guardar",
          isLoading: invProv.isLoading,
          onConfirm: () async {
            if (nombreController.text.isEmpty || prefijoController.text.isEmpty) return;

            final error = await invProv.addCategory(
              nombre: nombreController.text.trim(),
              prefijo: prefijoController.text.trim().toUpperCase(),
            );

            if (!context.mounted) return;
            Navigator.pop(context);

            CustomNotification.show(
              context,
              error == null ? "Categoría guardada" : "Error: $error",
              isSuccess: error == null,
            );
          },
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: "Nombre Categoría (ej. Herramientas)", prefixIcon: Icon(Icons.label)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: prefijoController,
                decoration: const InputDecoration(labelText: "Prefijo (ej. HR-)", prefixIcon: Icon(Icons.short_text)),
                textCapitalization: TextCapitalization.characters,
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditCategoryDialog(BuildContext context, Map<String, dynamic> cat) {
    final invProv = context.read<InventoryProvider>();
    final nombreController = TextEditingController(text: cat['nombre_categoria']);
    final prefijoController = TextEditingController(text: cat['prefijo']);

    showDialog(
      context: context,
      builder: (context) {
        return CustomDialog(
          title: "Editar Categoría",
          subtitle: "Modifique los datos de la categoría",
          icon: Icons.edit,
          confirmLabel: "Actualizar",
          isLoading: invProv.isLoading,
          onConfirm: () async {
            if (nombreController.text.isEmpty || prefijoController.text.isEmpty) return;

            final error = await invProv.updateCategory(
              idCategoria: cat['id_categoria'],
              nombre: nombreController.text.trim(),
              prefijo: prefijoController.text.trim().toUpperCase(),
            );

            if (!context.mounted) return;
            Navigator.pop(context);

            CustomNotification.show(
              context,
              error == null ? "Categoría actualizada" : "Error: $error",
              isSuccess: error == null,
            );
          },
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nombreController,
                decoration: const InputDecoration(labelText: "Nombre Categoría", prefixIcon: Icon(Icons.label)),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: prefijoController,
                decoration: const InputDecoration(labelText: "Prefijo", prefixIcon: Icon(Icons.short_text)),
                textCapitalization: TextCapitalization.characters,
              ),
            ],
          ),
        );
      },
    );
  }
}
