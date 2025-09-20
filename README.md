# Prueba2_jdll - App Flutter de Productos

Este proyecto es una aplicación Flutter que permite **gestionar productos y categorías** desde un backend en PHP/MySQL.  
La app incluye:

- Pantalla de inicio (`HomeScreen`) con bienvenida y botón para explorar.
- Menú principal (`MenuScreen`) con acceso a:
  - Productos (`ProductosScreen`): Listado y CRUD básico.
  - Categorías (`CategoriasScreen`): Listado y CRUD básico.
- Formularios para agregar productos (`FormProductos`) y categorías.
- Conexión HTTP con endpoints PHP (`productos.php`, `categorias.php`) que interactúan con la base de datos MySQL.

## Requisitos

- Flutter >= 3.0
- PHP >= 7.4
- MySQL
- Emulador Android o dispositivo físico
- Servidor local (XAMPP, WAMP o similar) para los scripts PHP

## Instalación

1. Clonar el repositorio:
```bash
git clone https://github.com/JU4ND213/prueba2_jdll.git
cd prueba2_jdll
```
2.Instalar dependencias Flutter:
```bash
flutter pub get
```

3.Configurar la base de datos MySQL:
```bash
CREATE DATABASE flutter_store;
USE flutter_store;

CREATE TABLE categorias (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL
);

CREATE TABLE productos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  descripcion TEXT,
  precio DECIMAL(10,2) NOT NULL,
  categoria_id INT,
  imagen VARCHAR(255),
  FOREIGN KEY (categoria_id) REFERENCES categorias(id)
);
```

4.Colocar los archivos PHP (productos.php, categorias.php, conexion.php) en el servidor local y ajustar la URL de la API en los .dart (http://10.0.2.2/flutter_store/...).

5.Ejecutar la app:
```bash
flutter run
```
*Uso

Desde el menú principal, navegar a Productos para ver el listado y agregar nuevos productos.

Navegar a Categorías para ver, agregar y seleccionar categorías.

Todas las acciones guardan los datos directamente en la base de datos MySQL.

*Notas

En el emulador de Android, usar 10.0.2.2 para apuntar al localhost del servidor.

Los formularios validan campos obligatorios antes de enviar la información.
