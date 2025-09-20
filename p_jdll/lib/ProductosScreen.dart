import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'FormProductos.dart';

class ProductosScreen extends StatefulWidget {
  @override
  _ProductosScreenState createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  List productos = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    fetchProductos();
  }

  Future<void> fetchProductos() async {
    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2/flutter_store/productos.php"),
      );
      if (response.statusCode == 200) {
        if (!mounted) return;
        setState(() {
          productos = json.decode(response.body);
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
      ).showSnackBar(SnackBar(content: Text("Error al cargar productos")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Productos")),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: productos.length,
              itemBuilder: (context, index) {
                final prod = productos[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: prod["imagen"] != null && prod["imagen"] != ""
                            ? Image.network(prod["imagen"], fit: BoxFit.cover)
                            : Icon(Icons.image_not_supported, size: 80),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              prod["nombre"],
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "\$${prod["precio"]}",
                              style: TextStyle(color: Colors.green),
                            ),
                            Text(
                              "Categoría: ${prod["categoria_nombre"] ?? ''}",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FormProductos()),
          );
          fetchProductos(); // refresca la lista al volver
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
