import 'package:emprestapp/pantallas/p3_buscar_material.dart';
import 'package:emprestapp/pantallas/p4_detalle_material.dart';
import 'package:emprestapp/pantallas/p7_publicar_material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utilidades.dart';

/// Pasa las guías de accesibilidad de Flutter (Accessibility Guideline API)
/// por todas las pantallas. Es el método de prueba de RNF1, RNF3 y RNF9.
void main() {
  for (final MapEntry(key: nombre, value: crearPantalla) in pantallasDeLaApp.entries) {
    testWidgets('$nombre cumple las guías de accesibilidad', (tester) async {
      usarPantallaDeMovil(tester);
      final semantica = tester.ensureSemantics();
      final datos = datosConSesion();
      await tester.pumpWidget(appDePrueba(datos, crearPantalla(datos)));
      await tester.pumpAndSettle();

      await comprobarGuias(tester);
      semantica.dispose();
    });
  }

  testWidgets('P3 · Filtros abiertos y uno marcado cumplen las guías de accesibilidad', (tester) async {
    usarPantallaDeMovil(tester);
    final semantica = tester.ensureSemantics();
    await tester.pumpWidget(appDePrueba(datosConSesion(), const PantallaBuscarMaterial()));
    await tester.tap(find.text('Filtros'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilterChip, 'Préstamo gratuito'));
    await tester.pumpAndSettle();

    await comprobarGuias(tester);
    semantica.dispose();
  });

  testWidgets('P7 · Paso de fotos con dos fotos añadidas cumple las guías de accesibilidad', (tester) async {
    usarPantallaDeMovil(tester);
    final semantica = tester.ensureSemantics();
    await tester.pumpWidget(appDePrueba(datosConSesion(), const PantallaPublicarMaterial()));
    await tester.tap(boton('Hacer foto'));
    await tester.pumpAndSettle();
    // Con una foto puesta, el botón queda más abajo: se baja hasta él.
    await tester.scrollUntilVisible(find.text('Elegir de la galería'), 300, scrollable: find.byType(Scrollable).first);
    await tester.tap(boton('Elegir de la galería'));
    await tester.pumpAndSettle();
    expect(find.text('Foto 2'), findsOneWidget);

    await comprobarGuias(tester);
    semantica.dispose();
  });

  testWidgets('P6 · Confirmación de reserva cumple las guías de accesibilidad', (tester) async {
    usarPantallaDeMovil(tester);
    final semantica = tester.ensureSemantics();
    final datos = datosConSesion();
    await tester.pumpWidget(appDePrueba(datos, PantallaDetalleMaterial(anuncio: datos.catalogo.first)));
    await tester.tap(boton('Reservar'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    await comprobarGuias(tester);
    semantica.dispose();
  });
}

Future<void> comprobarGuias(WidgetTester tester) async {
  // RNF3: zonas táctiles de al menos 48 × 48 (Android) y 44 × 44 (iOS).
  await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
  await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
  // RNF9: todo lo que se puede pulsar tiene un nombre para TalkBack.
  await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));

  // RNF1: contraste del texto (4,5:1 normal y 3:1 grande). Esta guía no tiene
  // en cuenta cuánto se ha desplazado una lista y, si no está arriba del todo
  // (el chat se abre abajo, en el último mensaje), mira en otro sitio de la
  // pantalla y da fallos falsos. Por eso se comprueba con la lista arriba.
  final listas = find.byType(Scrollable);
  if (listas.evaluate().isNotEmpty) {
    tester.state<ScrollableState>(listas.first).position.jumpTo(0);
    await tester.pumpAndSettle();
  }
  await expectLater(tester, meetsGuideline(textContrastGuideline));
}
