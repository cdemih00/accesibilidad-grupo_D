import 'package:flutter/material.dart';

import '../datos/modelos.dart';
import '../tema/tema.dart';
import '../widgets/fila_dato.dart';

/// P6 · Confirmación de reserva (RF5). Es un diálogo dentro de la ficha (P4):
/// resume qué se va a reservar y no hace nada hasta pulsar "Confirmar
/// reserva". "Cancelar y volver" deja la ficha como estaba.
///
/// Devuelve `true` si se ha confirmado.
Future<bool> mostrarConfirmacionReserva(BuildContext context, Anuncio anuncio) async {
  final confirmado = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      semanticLabel: '¿Confirmas la reserva?',
      scrollable: true,
      title: const Text('¿Confirmas la reserva?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FilaDato('Material', anuncio.nombre),
          FilaDato('Tipo', anuncio.tipo.texto),
          FilaDato('Precio', anuncio.precioTexto),
          FilaDato('Fechas', anuncio.fechas),
          FilaDato('Entrega', anuncio.entrega),
          const SizedBox(height: Espacio.m),
          Text('Al confirmar se abre el chat con ${anuncio.dueno} para quedar.'),
        ],
      ),
      actionsOverflowButtonSpacing: Espacio.s,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Cancelar y volver'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Confirmar reserva'),
        ),
      ],
    ),
  );
  return confirmado ?? false;
}
