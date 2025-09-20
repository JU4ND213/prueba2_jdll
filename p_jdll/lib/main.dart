import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'MenuScreen.dart';
import 'CategoriasScreen.dart';
import 'ProductosScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App de Productos',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/menu': (context) => MenuScreen(),
        '/categorias': (context) => CategoriasScreen(),
        '/productos': (context) => ProductosScreen(),
      },
    );
  }
}
