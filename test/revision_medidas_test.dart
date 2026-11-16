import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:emprestapp/pantallas/p3_buscar_material.dart';
import 'package:emprestapp/pantallas/p5_conversacion.dart';
import 'package:emprestapp/widgets/barra_opciones.dart';
import 'utilidades.dart';

void main() {
  testWidgets('Mediciones complementarias de RNF3 y escalado', (tester) async {
    usarPantallaDeMovil(tester);
    final datos = datosConSesion();
    await tester.pumpWidget(appDePrueba(datos, const PantallaBuscarMaterial()));
    await tester.pumpAndSettle();
    final nav = find.descendant(of: find.byType(BarraOpciones), matching: find.byType(InkWell));
    expect(nav, findsNWidgets(4));
    final rects = List.generate(4, (i) => tester.getRect(nav.at(i)));
    for(var i=0;i<4;i++) {
      print('NAV $i ${rects[i]}');
      if(i>0) print('NAV gap ${rects[i].left-rects[i-1].right}');
    }
    final search = tester.getRect(boton('Buscar'));
    final input = tester.getRect(campo('¿Qué buscas?'));
    print('BUSCAR $search CAMPO $input GAP ${search.left-input.right}');
    await tester.tap(find.text('Filtros'));
    await tester.pumpAndSettle();
    for (final e in find.byType(FilterChip).evaluate()) {
      final r = tester.getRect(find.byElementPredicate((x) => x==e));
      print('FILTRO ${(e.widget as FilterChip).label} $r');
    }
    await tester.pumpWidget(appDePrueba(datos, PantallaConversacion(conversacion: datos.conversaciones.first)));
    await tester.pumpAndSettle();
    for(final label in ['¿Sigue disponible?', '¿Dónde quedamos?', 'Te lo devuelvo mañana', '¡Gracias!']) {
      print('RESPUESTA $label ${tester.getRect(boton(label))}');
    }
    await tester.pumpWidget(appDePrueba(datos, const PantallaBuscarMaterial(), escalaTexto:2));
    await tester.pumpAndSettle();
    final fitted=find.descendant(of: find.byType(BarraOpciones), matching:find.byType(FittedBox));
    for(final e in fitted.evaluate()) {
      final r=e.renderObject as RenderFittedBox;
      final factor=r.size.width/r.child!.size.width;
      print('NAV texto200 caja=${r.size} contenido=${r.child!.size} factor=$factor');
    }
    expect(tester.takeException(), isNull);
  });
}
