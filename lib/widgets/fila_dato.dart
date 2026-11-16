import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(vertical: Espacio.xs),
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
