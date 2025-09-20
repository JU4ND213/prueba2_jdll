import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FormProductos extends StatefulWidget {
  @override
  _FormProductosState createState() => _FormProductosState();
}

class _FormProductosState extends State<FormProductos> {
  final _formKey = GlobalKey<FormState>();
  final nombreCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final precioCtrl = TextEditingController();
  final imagenCtrl = TextEditingController();

  String? categoriaSeleccionada;
  List categorias = [];

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
        });
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al cargar categorías")));
    }
  }

  Future<void> saveProducto() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final response = await http.post(
        Uri.parse("http://10.0.2.2/flutter_store/productos.php"),
        body: {
          "nombre": nombreCtrl.text,
          "descripcion": descCtrl.text,
          "precio": precioCtrl.text,
          "categoria_id": categoriaSeleccionada,
          "imagen": imagenCtrl.text,
        },
      );

      if (response.statusCode == 200) {
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        throw Exception("Error al guardar");
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error al guardar producto")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Nuevo Producto")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nombreCtrl,
                decoration: InputDecoration(labelText: "Nombre"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Campo obligatorio" : null,
              ),
              TextFormField(
                controller: descCtrl,
                decoration: InputDecoration(labelText: "Descripción"),
              ),
              TextFormField(
                controller: precioCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Precio"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Campo obligatorio" : null,
              ),
              DropdownButtonFormField(
                decoration: InputDecoration(labelText: "Categoría"),
                items: categorias
                    .map<DropdownMenuItem<String>>(
                      (c) => DropdownMenuItem<String>(
                        value: c["id"].toString(),
                        child: Text(c["nombre"]),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  if (!mounted) return;
                  setState(() {
                    categoriaSeleccionada = v;
                  });
                },
                validator: (v) => v == null ? "Seleccione una categoría" : null,
              ),
              TextFormField(
                controller: imagenCtrl,
                decoration: InputDecoration(labelText: "URL Imagen (opcional)"),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: saveProducto, child: Text("Guardar")),
            ],
          ),
        ),
      ),
    );
  }
}
