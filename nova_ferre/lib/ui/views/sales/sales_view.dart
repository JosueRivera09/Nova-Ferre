import 'package:flutter/material.dart';

class SalesView extends StatelessWidget {
  const SalesView({super.key});

  @override
  Widget build(BuildContext context) {
    // LayoutBuilder detecta el tamaño del espacio disponible en tiempo real
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 700) {
          return _buildDesktopLayout(context);
        } else {
          return _buildMobileLayout(context);
        }
      },
    );
  }

  // --- DISEÑO ESCRITORIO
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: SizedBox(
            height: double.infinity,
            child: _buildCatalogo(context, isMobile: false),
          ),
        ),

        VerticalDivider(
          width: 1,
          thickness: 1,
          color: Colors.grey.withOpacity(0.2),
        ),

        // Carrito (40%)
        Expanded(
          flex: 2,
          child: SizedBox(
            height: double.infinity, // Obliga a ocupar todo el alto
            child: _buildCarrito(context, isMobile: false),
          ),
        ),
      ],
    );
  }

  // --- DISEÑO MÓVIL
  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCatalogo(context, isMobile: true),
          const Divider(height: 1),
          _buildCarrito(context, isMobile: true),
        ],
      ),
    );
  }

  // --- COMPONENTE: CATÁLOGO ---
  Widget _buildCatalogo(BuildContext context, {required bool isMobile}) {
    return Column(
      mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 230, 104, 60),
                ),
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              isDense: true,
              prefixIcon: const Icon(
                Icons.search,
                color: Color.fromARGB(255, 230, 104, 60),
              ),
              hintText: "Buscar producto",
            ),
          ),
        ),

        isMobile
            ? const SizedBox(
                height: 300,
                child: Center(child: Text("Grid de Productos")),
              )
            : const Expanded(child: Center(child: Text("Grid de Productos"))),
      ],
    );
  }

  // --- COMPONENTE: CARRITO ---
  Widget _buildCarrito(BuildContext context, {required bool isMobile}) {
    return Container(
      color: Theme.of(context).cardColor.withOpacity(0.5),
      child: Column(
        mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(
              child: Row(
                children: [
                  Icon(
                    Icons.shopping_cart_checkout_outlined,
                    color: Color.fromARGB(255, 230, 104, 60),
                  ),
                  SizedBox(width: 20),
                  Text(
                    "Carrito de Compras",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),
          // Área de lista de productos
          isMobile
              ? const SizedBox(
                  height: 200,
                  child: Center(child: Text("Lista de productos")),
                )
              : const Expanded(
                  child: Center(child: Text("Lista de productos")),
                ),

          const Divider(),
          // Sección fija de totales al fondo
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const Text(
                  "Total: \$0.00",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 230, 104, 60),
                    minimumSize: const Size(double.infinity, 45),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "COBRAR",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
