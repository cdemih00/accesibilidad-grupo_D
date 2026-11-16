import 'package:flutter/material.dart';

import '../datos/datos_app.dart';
import '../datos/modelos.dart';
import '../navegacion/rutas.dart';
import '../tema/colores.dart';
import '../tema/tema.dart';
import '../widgets/aviso.dart';
import '../widgets/barra_opciones.dart';
import '../widgets/etiqueta_estado.dart';
import '../widgets/fila_dato.dart';
import '../widgets/foto_material.dart';
import 'p6_confirmar_reserva.dart';

/// P4 · Detalles del material (recorrido 2, RF4).
///
/// Fotos con su descripción (R7), condiciones en texto normal y con buen
/// contraste (R4) y estado escrito (R6). Las fotos van una debajo de otra, sin
/// carrusel, para no obligar a deslizar (R8).
class PantallaDetalleMaterial extends StatelessWidget {
  const PantallaDetalleMaterial({super.key, required this.anuncio});

  final Anuncio anuncio;

  Future<void> _reservar(BuildContext context) async {
    final confirmado = await mostrarConfirmacionReserva(context, anuncio);
    if (!confirmado || !context.mounted) return;
    final datos = DatosScope.of(context, escuchar: false);
    datos.reservar(anuncio);
    mostrarMensaje(context, 'Reserva confirmada. Ya puedes hablar con ${anuncio.dueno} para quedar.');
    Navigator.pushNamed(context, Rutas.conversacion, arguments: datos.conversacionDe(anuncio));
  }

  void _preguntarAlDueno(BuildContext context) {
    final datos = DatosScope.of(context, escuchar: false);
    Navigator.pushNamed(context, Rutas.conversacion, arguments: datos.conversacionDe(anuncio));
  }

  @override
  Widget build(BuildContext context) {
    // Para volver a dibujar la ficha cuando cambia el estado (al reservar).
    DatosScope.of(context);
    final textos = Theme.of(context).textTheme;
    final disponible = anuncio.estado == EstadoMaterial.disponible;
    final fotos = anuncio.fotos;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalles del material')),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // "Reservar" fijo abajo y a todo lo ancho: se alcanza con el pulgar
          // de cualquiera de las dos manos (R5).
          Container(
            padding: const EdgeInsets.all(Espacio.m),
            decoration: BoxDecoration(
              color: Paleta.de(context).fondo,
              border: Border(top: BorderSide(color: Paleta.de(context).separador)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!disponible) ...[
                  Text(
                    'Este material ya está reservado. Puedes preguntar al dueño cuándo vuelve a estar libre.',
                    style: textos.bodyMedium,
                  ),
                  const SizedBox(height: Espacio.s),
                ],
                FilledButton(
                  onPressed: disponible ? () => _reservar(context) : null,
                  child: const Text('Reservar'),
                ),
              ],
            ),
          ),
          const BarraOpciones(actual: SeccionBarra.buscar),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Espacio.m),
        children: [
          Semantics(header: true, child: Text(anuncio.nombre, style: textos.headlineSmall)),
          const SizedBox(height: Espacio.s),
          Align(alignment: AlignmentDirectional.centerStart, child: EtiquetaEstado(estado: anuncio.estado)),
          const SizedBox(height: Espacio.l),
          for (final (indice, foto) in fotos.indexed) ...[
            FotoMaterial(foto: foto, numero: indice + 1, total: fotos.length),
            const SizedBox(height: Espacio.l),
          ],
          _Apartado(titulo: 'Para qué sirve', hijos: [Text(anuncio.paraQueSirve)]),
          _Apartado(
            titulo: 'Condiciones',
            hijos: [
              FilaDato('Tipo', anuncio.tipo.texto),
              FilaDato('Precio', anuncio.precioTexto),
              FilaDato('Fechas', anuncio.fechas),
              FilaDato('Entrega', anuncio.entrega),
            ],
          ),
          _Apartado(titulo: 'Descripción', hijos: [Text(anuncio.descripcion)]),
          _Apartado(
            titulo: 'Dueño',
            hijos: [
              Text(anuncio.dueno),
              const SizedBox(height: Espacio.m),
              OutlinedButton.icon(
                onPressed: () => _preguntarAlDueno(context),
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Preguntar al dueño'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Apartado extends StatelessWidget {
  const _Apartado({required this.titulo, required this.hijos});

  final String titulo;
  final List<Widget> hijos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Espacio.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(header: true, child: Text(titulo, style: Theme.of(context).textTheme.titleMedium)),
          const SizedBox(height: Espacio.s),
          ...hijos,
        ],
      ),
    );
  }
}
