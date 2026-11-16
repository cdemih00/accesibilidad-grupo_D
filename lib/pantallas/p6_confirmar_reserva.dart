import 'package:flutter/material.dart';

import '../datos/modelos.dart';
import '../tema/colores.dart';
import '../tema/tema.dart';
import '../widgets/dialogo_confirmar.dart';
import '../widgets/fila_dato.dart';

/// P6 · Confirmación de reserva (RF5). Es un diálogo dentro de la ficha (P4):
/// resume qué se va a reservar y no hace nada hasta pulsar "Confirmar
/// reserva" (botón principal). "Cancelar y volver" es el botón secundario,
/// blanco con borde, y deja la ficha como estaba: antes era rojo, pero en
/// escala de grises se confundía con confirmar (revisión del 4.3).
///
/// Devuelve `true` si se ha confirmado.
Future<bool> mostrarConfirmacionReserva(BuildContext context, Anuncio anuncio) async {
  final confirmado = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      semanticLabel: 'Resumen de la reserva',
      scrollable: true,
      title: const Text('Resumen de la reserva'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          FilaResumen('Material', anuncio.nombre),
          FilaResumen('Tipo', anuncio.tipo.texto),
          FilaResumen('Precio', anuncio.precioTexto),
          FilaResumen('Fechas', anuncio.fechas),
          FilaResumen('Entrega', anuncio.entrega),
          const SizedBox(height: Espacio.m),
          Text(
            'Al confirmar se abre el chat con ${anuncio.dueno} para quedar.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColoresApp.textoSecundario),
          ),
          const SizedBox(height: Espacio.l),
          BotonesDialogo(
            textoConfirmar: 'Confirmar reserva',
            textoCancelar: 'Cancelar y volver',
            icono: Icons.check,
            alConfirmar: () => Navigator.pop(context, true),
            alCancelar: () => Navigator.pop(context, false),
          ),
        ],
      ),
    ),
  );
  return confirmado ?? false;
}
