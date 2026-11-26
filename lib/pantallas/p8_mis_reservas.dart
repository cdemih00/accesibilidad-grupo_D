import 'package:flutter/material.dart';

import '../datos/datos_app.dart';
import '../datos/modelos.dart';
import '../navegacion/rutas.dart';
import '../tema/colores.dart';
import '../tema/tema.dart';
import '../widgets/aviso.dart';
import '../widgets/barra_opciones.dart';
import '../widgets/barra_superior.dart';
import '../widgets/dialogo_confirmar.dart';
import '../widgets/estado_vacio.dart';
import '../widgets/fila_dato.dart';

/// P8 · Mis reservas: material reservado, fechas y estado. Desde cada reserva
/// se abre el chat o se cancela con un botón y confirmando antes (RF6, R8).
class PantallaMisReservas extends StatelessWidget {
  const PantallaMisReservas({super.key});

  @override
  Widget build(BuildContext context) {
    final reservas = DatosScope.of(context).reservas;

    return Scaffold(
      appBar: barraSuperior(context, 'Mis reservas'),
      bottomNavigationBar: const BarraOpciones(actual: SeccionBarra.inicio),
      body: ListView(
        padding: const EdgeInsets.all(Espacio.m),
        children: [
          if (reservas.isEmpty)
            EstadoVacio(
              icono: Icons.event_available_outlined,
              texto: 'No tienes ninguna reserva.',
              textoBoton: 'Buscar material',
              iconoBoton: Icons.search,
              alPulsar: () => irA(context, Rutas.buscar),
            )
          else
            for (final reserva in reservas)
              Padding(
                padding: const EdgeInsets.only(bottom: Espacio.m),
                child: _TarjetaReserva(reserva: reserva),
              ),
        ],
      ),
    );
  }
}

class _TarjetaReserva extends StatelessWidget {
  const _TarjetaReserva({required this.reserva});

  final Reserva reserva;

  Future<void> _cancelar(BuildContext context) async {
    final nombre = reserva.anuncio.nombre;
    final cancelar = await confirmarAccion(
      context,
      titulo: '¿Cancelar la reserva?',
      mensaje: 'Vas a cancelar la reserva de "$nombre". El material volverá a estar disponible para otras personas.',
      textoConfirmar: 'Cancelar reserva',
      textoCancelar: 'Volver sin cancelar',
      icono: Icons.event_busy_outlined,
    );
    if (!cancelar || !context.mounted) return;
    DatosScope.of(context, escuchar: false).cancelarReserva(reserva);
    mostrarMensaje(context, 'Reserva de "$nombre" cancelada.');
  }

  void _abrirChat(BuildContext context) {
    final conversacion = DatosScope.of(context, escuchar: false).conversacionDe(reserva.anuncio);
    Navigator.pushNamed(context, Rutas.conversacion, arguments: conversacion);
  }

  @override
  Widget build(BuildContext context) {
    final anuncio = reserva.anuncio;
    final textos = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Espacio.m),
        // Cada dato de la tarjeta se lee como un elemento propio, después del
        // nombre (encabezado). Sin esto se leía todo junto como encabezado.
        child: Semantics(
          container: true,
          explicitChildNodes: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(header: true, container: true, child: Text(anuncio.nombre, style: textos.titleSmall)),
              const SizedBox(height: Espacio.s),
              // Estado con icono y texto (RNF10).
              Row(
                children: [
                  const Icon(Icons.check_circle_outline, color: ColoresApp.exito, size: 20),
                  const SizedBox(width: Espacio.s),
                  Expanded(
                    child: Text(
                      'Reserva confirmada',
                      style: textos.labelMedium?.copyWith(color: ColoresApp.exito, fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Espacio.s),
              FilaDato('Fechas', anuncio.fechas),
              FilaDato('Devolución', reserva.devolucion),
              FilaDato('Dueño', anuncio.dueno),
              FilaDato('Entrega', anuncio.entrega),
              const SizedBox(height: Espacio.s),
              FilledButton.icon(
                onPressed: () => _abrirChat(context),
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Abrir chat'),
              ),
              // Más separación con la acción de borrar para no pulsarla sin querer (4.4).
              const SizedBox(height: Espacio.l),
              FilledButton.icon(
                style: estiloBotonDestructivo(context),
                onPressed: () => _cancelar(context),
                icon: const Icon(Icons.event_busy_outlined),
                label: Text('Cancelar reserva', semanticsLabel: 'Cancelar la reserva de ${anuncio.nombre}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
