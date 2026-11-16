import 'package:flutter/material.dart';

import '../tema/tema.dart';

/// Pide confirmación antes de una acción que no se puede deshacer: cancelar
/// una reserva, retirar un anuncio, quitar una foto o cerrar sesión (R8, RF6,
/// RF12). Devuelve `true` solo si se pulsa el botón de confirmar.
///
/// El título del diálogo es lo primero que anuncia TalkBack al abrirse.
Future<bool> confirmarAccion(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  required String textoConfirmar,
  String textoCancelar = 'No, volver',
  bool destructiva = true,
  bool cerrarTocandoFuera = true,
}) async {
  final confirmado = await showDialog<bool>(
    context: context,
    barrierDismissible: cerrarTocandoFuera,
    builder: (context) => AlertDialog(
      semanticLabel: titulo,
      scrollable: true,
      title: Text(titulo),
      content: Text(mensaje),
      actionsOverflowButtonSpacing: Espacio.s,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(textoCancelar),
        ),
        FilledButton(
          style: destructiva
              ? FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                )
              : null,
          onPressed: () => Navigator.pop(context, true),
          child: Text(textoConfirmar),
        ),
      ],
    ),
  );
  return confirmado ?? false;
}
