import 'package:flutter/material.dart';

class SearchBox extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SearchBox({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  // Escuchamos el controlador para saber cuándo mostrar la "X"
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_handleTextChange);
  }

  @override
  void dispose() {
    // Es importante quitar el listener al cerrar
    widget.controller.removeListener(_handleTextChange);
    super.dispose();
  }

  void _handleTextChange() {
    // Solo redibuja este widget pequeño, no toda la app
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      height: 40,
      margin: const EdgeInsets.only(right: 20),
      child: TextField(
        controller: widget.controller,
        onChanged: widget.onChanged,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        decoration: InputDecoration(
          hintText: 'Buscar...',
          hintStyle: const TextStyle(color: Colors.white54),
          prefixIcon: const Icon(Icons.search, size: 18, color: Colors.white54),

          // La "X" ahora es reactiva sin trabar el teclado
          suffixIcon: widget.controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white54,
                  ),
                  onPressed: () {
                    widget.controller.clear();
                    widget.onChanged('');
                  },
                )
              : null,

          filled: true,
          fillColor: Colors.white.withOpacity(0.08),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }
}
