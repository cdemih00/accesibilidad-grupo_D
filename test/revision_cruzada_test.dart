import 'package:emprestapp/app.dart';
import 'package:emprestapp/datos/modelos.dart';
import 'package:emprestapp/widgets/tarjeta_anuncio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utilidades.dart';

void main() {
  for (final reservado in [false, true]) {
    testWidgets('Revisión cruzada: ficha accesible y reserva coherente (reservado=$reservado)', (tester) async {
      usarPantallaDeMovil(tester);
      final datos = datosConSesion();
      final anuncio = datos.catalogo.first;
      anuncio.estado = reservado ? EstadoMaterial.reservado : EstadoMaterial.disponible;
      await tester.pumpWidget(EmprestApp(datos: datos));
      await tester.pumpAndSettle();
      await tester.tap(boton('Buscar material'));
      await tester.pumpAndSettle();
      final tarjeta = find.byWidgetPredicate((w) => w is TarjetaAnuncio && w.anuncio == anuncio);
      expect(find.descendant(of: tarjeta, matching: find.text('Ver detalle ›')), findsOneWidget);
      expect(
        find.descendant(of: tarjeta, matching: find.text('Puedes consultar la ficha; no disponible para reservar.')),
        reservado ? findsOneWidget : findsNothing,
      );
      await tester.ensureVisible(tarjeta);
      await tester.tap(tarjeta);
      await tester.pumpAndSettle();
      expect(find.text('Detalles del material'), findsOneWidget);
      final reservar = tester.widget<ButtonStyleButton>(boton('Reservar'));
      if (reservado) {
        expect(reservar.onPressed, isNull);
      } else {
        expect(reservar.onPressed, isNotNull);
        await tester.tap(boton('Reservar'));
        await tester.pumpAndSettle();
        expect(find.text('Resumen de la reserva'), findsOneWidget);
        expect(botonDelDialogo('Confirmar reserva'), findsOneWidget);
        expect(tester.widget<AlertDialog>(find.byType(AlertDialog)).semanticLabel, 'Resumen de la reserva');
        await tester.tap(botonDelDialogo('Cancelar y volver'));
        await tester.pumpAndSettle();
        expect(anuncio.estado, EstadoMaterial.disponible);
      }
      expect(tester.takeException(), isNull);
    });
  }
}
