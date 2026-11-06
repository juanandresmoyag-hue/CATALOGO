# Catálogo SENATI

Aplicación Flutter multiplataforma para consultar y registrar componentes
tecnológicos del inventario de los laboratorios.

## Funcionalidades

- Inicio de sesión para acceder al catálogo.
- Catálogo con búsqueda y filtros por categoría.
- Registro de componentes mediante formulario con validación.
- Ficha técnica con precio estimado y estado de inventario.
- Catálogo inicial cargado desde `assets/products.json`.
- Los componentes nuevos se mantienen en memoria durante la sesión.

## Usuarios de demostración

- Usuario `admin`, contraseña `admin123`.
- Usuario `Empleado`, contraseña `1234`.

Estas credenciales están incluidas en la aplicación como acceso de demostración;
no sustituyen un sistema de autenticación seguro para producción.

## Estructura

- `lib/models/`: modelo de producto y categorías.
- `assets/products.json`: catálogo inicial de productos.
- `lib/screens/`: inicio de sesión, catálogo principal y ficha técnica.
- `lib/widgets/`: formulario modal de registro.

## Ejecutar

```bash
flutter run
```

Verificar las pruebas de interfaz:

```bash
flutter test
```

## Publicar en Vercel

`vercel.json` configura Vercel para descargar Flutter 3.47.9, preparar el
entorno web, instalar las dependencias y compilar la aplicación en `build/web`.
Sube el proyecto completo al repositorio conectado con Vercel y deja como
directorio raíz del proyecto la carpeta donde está `vercel.json`.
