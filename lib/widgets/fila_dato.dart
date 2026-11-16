import 'package:flutter/material.dart';

import '../tema/colores.dart';
import '../tema/tema.dart';

/// Una línea "Etiqueta: valor", por ejemplo "Tipo: Préstamo gratuito". Va en un
/// solo texto para que TalkBack la lea entera y en orden.
class FilaDato extends StatelessWidget {
  const FilaDato(this.etiqueta, this.valor, {super.key});

  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Espacio.s),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(text: '$etiqueta: ', style: const TextStyle(fontWeight: FontWeight.w700)),
            TextSpan(text: valor),
          ],
        ),
      ),
    );
  }
}

/// Fila del resumen del diálogo de confirmación de reserva: el dato a la
/// izquierda en gris y el valor a la derecha en negrita, con una línea debajo.
/// Si no cabe en una línea (texto grande), el valor pasa debajo.
class FilaResumen extends StatelessWidget {
  const FilaResumen(this.etiqueta, this.valor, {super.key});

  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return Semantics(
      label: '$etiqueta: $valor',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: Espacio.s),
        decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: ColoresApp.separador))),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          spacing: Espacio.m,
          children: [
            Text(etiqueta, style: textos.bodyMedium?.copyWith(color: ColoresApp.textoSecundario)),
            Text(valor, style: textos.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
