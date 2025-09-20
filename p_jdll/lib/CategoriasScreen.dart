import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CategoriasScreen extends StatefulWidget {
  const CategoriasScreen({super.key});

  @override
  _CategoriasScreenState createState() => _CategoriasScreenState();
}

class _CategoriasScreenState extends State<CategoriasScreen> {
  List categorias = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchCategorias();
  }

  Future<void> fetchCategorias() async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2/flutter_store/categorias.php"),
      );
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          categorias = json.decode(response.body);
          loading = false;
        });
      } else {
        throw Exception("Error en la API");
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al cargar categorías")));
    }
  }

  Future<void> addCategoria(String nombre) async {
    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2/flutter_store/categorias.php"),
        body: {"nombre": nombre},
      );
      if (response.statusCode == 200) {
        fetchCategorias();
      } else {
        throw Exception("Error al guardar");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al guardar categoría")));
    }
  }

  void _showAddDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Nueva Categoría"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: "Nombre"),
        ),
        actions: [
          TextButton(
            child: Text("Cancelar"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Guardar"),
            onPressed: () {
              if (controller.text.isNotEmpty) {
                addCategoria(controller.text);
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Categorías")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final cat = categorias[index];
                return ListTile(title: Text(cat["nombre"]));
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
