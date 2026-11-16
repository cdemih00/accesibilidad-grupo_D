import 'package:emprestapp/pantallas/p4_detalle_material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utilidades.dart';

/// RNF2: con la letra del móvil al 200 % nada se corta ni se solapa. Si algo
/// se desborda, Flutter da un error y el test falla. Se recorre cada pantalla
/// hasta abajo para comprobar también lo que no se ve al principio.
void main() {
  for (final MapEntry(key: nombre, value: crearPantalla) in pantallasDeLaApp.entries) {
    testWidgets('$nombre funciona con el texto al 200 %', (tester) async {
      usarPantallaDeMovil(tester);
      final datos = datosConSesion();
      await tester.pumpWidget(appDePrueba(datos, crearPantalla(datos), escalaTexto: 2));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await recorrerHastaAbajo(tester);
    });
  }

  testWidgets('P6 · Confirmación de reserva funciona con el texto al 200 %', (tester) async {
    usarPantallaDeMovil(tester);
    final datos = datosConSesion();
    await tester.pumpWidget(
      appDePrueba(datos, PantallaDetalleMaterial(anuncio: datos.catalogo.first), escalaTexto: 2),
    );
    await tester.tap(boton('Reservar'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(botonDelDialogo('Confirmar reserva'), findsOneWidget);
  });
}

Future<void> recorrerHastaAbajo(WidgetTester tester) async {
  final lista = find.byType(Scrollable).first;
  for (var i = 0; i < 12; i++) {
    await tester.drag(lista, const Offset(0, -400), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }
}
