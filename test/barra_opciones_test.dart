import 'package:emprestapp/pantallas/p3_buscar_material.dart';
import 'package:emprestapp/widgets/barra_opciones.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utilidades.dart';

void main() {
  for (final escala in [1.0, 2.0]) {
    testWidgets('Barra: zonas de 48dp separadas 8dp con texto x$escala', (
      tester,
    ) async {
      usarPantallaDeMovil(tester);
      await tester.pumpWidget(
        appDePrueba(
          datosConSesion(),
          const PantallaBuscarMaterial(),
          escalaTexto: escala,
        ),
      );
      await tester.pumpAndSettle();
      final botones = find.descendant(
        of: find.byType(BarraOpciones),
        matching: find.byType(InkWell),
      );
      expect(botones, findsNWidgets(4));
      Rect? anterior;
      for (var i = 0; i < 4; i++) {
        final zona = tester.getRect(botones.at(i));
        expect(zona.width, greaterThanOrEqualTo(48));
        if (escala == 2) expect(zona.width, greaterThanOrEqualTo(150));
        expect(zona.height, greaterThanOrEqualTo(48));
        if (anterior != null) {
          final separacion = zona.top == anterior.top
              ? zona.left - anterior.right
              : zona.top - anterior.bottom;
          expect(separacion, greaterThanOrEqualTo(8));
        }
        anterior = zona;
      }
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'Barra: conserva escala del texto x$escala sin reducir etiquetas',
      (tester) async {
        usarPantallaDeMovil(tester);
        await tester.pumpWidget(
          appDePrueba(
            datosConSesion(),
            const PantallaBuscarMaterial(),
            escalaTexto: escala,
          ),
        );
        await tester.pumpAndSettle();
        final barra = tester.renderObject(find.byType(BarraOpciones));
        for (final etiqueta in ['Inicio', 'Buscar', 'Publicar', 'Chats']) {
          final texto = find.descendant(
            of: find.byType(BarraOpciones),
            matching: find.text(etiqueta),
          );
          final render = tester.renderObject(texto);
          expect(
            render.getTransformTo(barra).entry(0, 0),
            closeTo(1, 0.001),
            reason: etiqueta,
          );
        }
        expect(tester.takeException(), isNull);
      },
    );
  }
}
