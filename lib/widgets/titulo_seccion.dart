import 'package:flutter/material.dart';

import '../tema/tema.dart';

/// Título de una sección (20 sp, en negrita) con un botón secundario opcional
/// al lado, por ejemplo "Mis reservas — Ver mis reservas" en el menú principal
/// o "Fotos — Editar" al revisar un anuncio.
///
/// El título se marca como encabezado para que con TalkBack se pueda saltar
/// de sección en sección. Si no cabe en una línea (texto grande), el botón
/// pasa debajo en vez de cortarse.
class TituloSeccion extends StatelessWidget {
  const TituloSeccion({
    super.key,
    required this.titulo,
    this.textoBoton,
    this.etiquetaBoton,
    this.iconoBoton,
    this.alPulsar,
  });

  final String titulo;
  final String? textoBoton;

  /// Lo que lee TalkBack en el botón si el texto visible no basta fuera de
  /// contexto ("Editar" → "Editar las fotos").
  final String? etiquetaBoton;
  final IconData? iconoBoton;
  final VoidCallback? alPulsar;

  @override
  Widget build(BuildContext context) {
    final texto = textoBoton;
    return Padding(
      padding: const EdgeInsets.only(bottom: Espacio.s),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: Espacio.s,
        runSpacing: Espacio.s,
        children: [
          Semantics(
            header: true,
            container: true,
            child: Text(titulo, style: Theme.of(context).textTheme.titleMedium),
          ),
          if (texto != null)
            iconoBoton == null
                ? OutlinedButton(onPressed: alPulsar, child: Text(texto, semanticsLabel: etiquetaBoton))
                : OutlinedButton.icon(
                    onPressed: alPulsar,
                    icon: Icon(iconoBoton),
                    label: Text(texto, semanticsLabel: etiquetaBoton),
                  ),
        ],
      ),
    );
  }
}
