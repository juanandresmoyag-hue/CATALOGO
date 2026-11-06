import 'package:catalogo/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('filtra, abre la ficha y registra un componente', (tester) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const CatalogoSenatiApp());
    expect(find.text('Acceso al catálogo'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('login-username')), 'admin');
    await tester.enterText(find.byKey(const Key('login-password')), 'admin123');
    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 100)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Catálogo SENATI'), findsOneWidget);
    expect(find.text('Adaptador Ethernet'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Desktop'));
    await tester.pumpAndSettle();

    expect(find.text('Adaptador Ethernet'), findsOneWidget);
    expect(find.text('Audífonos Philips'), findsNothing);

    await tester.tap(find.text('Adaptador Ethernet'));
    await tester.pumpAndSettle();

    expect(find.text('Ficha técnica'), findsOneWidget);
    expect(find.text('Características del producto'), findsOneWidget);
    expect(find.text('Nombre'), findsOneWidget);
    expect(find.text('Adaptador Ethernet'), findsNWidgets(2));
    expect(find.text('Categoría'), findsOneWidget);
    expect(find.text('Desktop'), findsOneWidget);
    expect(find.text('Precio'), findsOneWidget);
    expect(find.text('S/. 59.00'), findsOneWidget);
    expect(find.text('Descripción'), findsOneWidget);
    expect(
      find.text(
        'Diseñado para convertir un puerto USB en una conexión de red RJ45 con velocidades de hasta 10/100/1000 Mbps.',
      ),
      findsOneWidget,
    );
    expect(find.text('Stock disponible en almacén'), findsOneWidget);

    await tester.tap(find.text('Volver al catálogo'));
    await tester.pumpAndSettle();
    expect(find.text('Catálogo SENATI'), findsOneWidget);

    await tester.tap(find.text('Nuevo componente'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Guardar componente'));
    await tester.pumpAndSettle();
    expect(find.text('Ingresa el nombre del componente'), findsOneWidget);
    expect(find.text('Selecciona una categoría'), findsOneWidget);

    await tester.enterText(
      find.widgetWithText(TextFormField, 'Nombre del componente'),
      'Monitor de prueba',
    );
    await tester.tap(find.text('Categoría'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Desktop').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Precio'),
      '450.00',
    );
    await tester.enterText(
      find.widgetWithText(TextFormField, 'Descripción técnica'),
      'Monitor Full HD para laboratorio',
    );

    await tester.tap(find.text('Guardar componente'));
    await tester.pumpAndSettle();

    expect(find.text('Monitor de prueba'), findsOneWidget);
    expect(find.text('S/. 450.00'), findsOneWidget);
  });

  testWidgets('rechaza credenciales inválidas y permite ingresar a Empleado', (
    tester,
  ) async {
    await tester.pumpWidget(const CatalogoSenatiApp());
    await tester.enterText(find.byKey(const Key('login-username')), 'admin');
    await tester.enterText(
      find.byKey(const Key('login-password')),
      'incorrecta',
    );
    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();

    expect(find.text('Usuario o contraseña incorrectos'), findsOneWidget);
    expect(find.text('Catálogo SENATI'), findsNothing);

    await tester.enterText(find.byKey(const Key('login-username')), 'Empleado');
    await tester.enterText(find.byKey(const Key('login-password')), '1234');
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('login-username')))
          .controller!
          .text,
      'Empleado',
    );
    expect(
      tester
          .widget<TextFormField>(find.byKey(const Key('login-password')))
          .controller!
          .text,
      '1234',
    );
    await tester.tap(find.text('Ingresar'));
    await tester.pumpAndSettle();
    expect(find.text('Iniciar sesión'), findsNothing);
  });
}
