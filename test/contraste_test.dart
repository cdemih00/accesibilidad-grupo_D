import 'package:emprestapp/tema/colores.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';

/// Comprueba la tabla de contrastes de las dos paletas (apartados 4.2 y 4.3):
/// cada combinación con su ratio, el mínimo que le toca y PASS/FAIL.
void main() {
  for (final paleta in [Paleta.clara, Paleta.oscura]) {
    group('Contraste del ${paleta.nombre.toLowerCase()} (WCAG 2.2)', () {
      for (final par in paleta.paresMedidos) {
        test(par.nombre, () {
          expect(
            par.ratio,
            greaterThanOrEqualTo(par.minimo),
            reason: '${par.nombre}: ${par.ratio.toStringAsFixed(2)}:1, y el mínimo es ${par.minimo}:1',
          );
        });
      }
    });

    test('Tabla de contrastes del ${paleta.nombre.toLowerCase()} para la memoria', () {
      String hex(Color color) => '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
      String numero(double valor) => valor.toStringAsFixed(2).replaceAll('.', ',').replaceAll(',00', '');
      final tabla = StringBuffer('${paleta.nombre}\n| Combinación | Colores | Ratio | Mínimo | Resultado |\n|---|---|---|---|---|\n');
      for (final par in paleta.paresMedidos) {
        tabla.writeln(
          '| ${par.nombre} | ${hex(par.delante)} / ${hex(par.fondo)} | ${numero(par.ratio)}:1 | '
          '${numero(par.minimo)}:1 | ${par.cumple ? 'PASS' : 'FAIL'} |',
        );
      }
      debugPrint(tabla.toString());
      expect(paleta.paresMedidos.every((par) => par.cumple), isTrue);
    });
  }
}
