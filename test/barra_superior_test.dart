import 'package:emprestapp/datos/datos_app.dart';
import 'package:emprestapp/pantallas/p4_detalle_material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utilidades.dart';

/// RNF2: con la letra al 200 % el título de la barra de arriba se lee entero.
/// Flutter lo deja en una línea y corta con "…" lo que no cabe; barraSuperior
/// lo mide y, si hace falta, lo baja a otra línea y la barra crece. Aquí se
/// carga Lexend para medir con la letra de verdad: la de los tests de Flutter
/// es mucho más ancha.
void main() {
  setUpAll(() async {
    final lexend = FontLoader('Lexend');
    for (final peso in ['Regular', 'Medium', 'SemiBold', 'Bold']) {
      lexend.addFont(rootBundle.load('assets/fuentes/Lexend-$peso.ttf'));
    }
    await lexend.load();
  });

  for (final MapEntry(key: nombre, value: crearPantalla) in pantallasDeLaApp.entries) {
    testWidgets('$nombre: el título de arriba se lee entero con el texto al 200 %', (tester) async {
      usarPantallaDeMovil(tester);
      final datos = datosConSesion();
      // En la aplicación todas llevan la flecha de atrás menos el menú (P2),
      // que es la primera pantalla después de entrar.
      await abrir(tester, datos, crearPantalla(datos), conFlechaAtras: !nombre.startsWith('P2'), escalaTexto: 2);

      final textos = find.descendant(of: find.byType(AppBar), matching: find.byType(RichText));
      for (final texto in tester.renderObjectList<RenderParagraph>(textos)) {
        expect(texto.didExceedMaxLines, isFalse, reason: '«${texto.text.toPlainText()}» se corta');
      }
    });
  }

  testWidgets('P4 · La barra solo crece cuando el título no cabe en una línea', (tester) async {
    usarPantallaDeMovil(tester);
    final datos = datosConSesion();
    final ficha = PantallaDetalleMaterial(anuncio: datos.catalogo.first);

    await abrir(tester, datos, ficha, conFlechaAtras: true, escalaTexto: 1);
    expect(tester.getSize(find.byType(AppBar)).height, kToolbarHeight);

    await abrir(tester, datos, ficha, conFlechaAtras: true, escalaTexto: 2);
    expect(tester.getSize(find.byType(AppBar)).height, greaterThan(kToolbarHeight));
  });
}

/// Monta la aplicación de prueba con [pantalla]. Con [conFlechaAtras] la abre
/// encima de otra, como en la aplicación, y la barra lleva la flecha de atrás,
/// que le quita sitio al título.
Future<void> abrir(
  WidgetTester tester,
  DatosApp datos,
  Widget pantalla, {
  required bool conFlechaAtras,
  required double escalaTexto,
}) async {
  await tester.pumpWidget(const SizedBox.shrink());
  await tester.pumpWidget(appDePrueba(datos, conFlechaAtras ? const SizedBox.shrink() : pantalla, escalaTexto: escalaTexto));
  if (conFlechaAtras) {
    tester.state<NavigatorState>(find.byType(Navigator)).push(MaterialPageRoute<void>(builder: (_) => pantalla));
  }
  await tester.pumpAndSettle();
}
