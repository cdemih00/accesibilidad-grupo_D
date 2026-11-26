import 'package:flutter/material.dart';

import '../tema/tema.dart';

/// Estado de carga: un círculo que gira y un texto que dice qué se está
/// haciendo, por ejemplo "Publicando el anuncio…". No depende solo de la
/// animación, porque el texto se ve, y TalkBack lo lee en cuanto aparece porque
/// es una "live region", igual que los mensajes de error (RNF6).
class IndicadorCarga extends StatelessWidget {
  const IndicadorCarga(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      child: Row(
        children: [
          // El círculo solo acompaña: lo que se lee es el texto.
          const ExcludeSemantics(
            child: SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 3)),
          ),
          const SizedBox(width: Espacio.m),
          Expanded(
            child: Text(texto, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
