import 'package:flutter/material.dart';

import '../datos/datos_app.dart';
import '../datos/modelos.dart';
import '../navegacion/rutas.dart';
import '../tema/tema.dart';
import '../widgets/aviso.dart';
import '../widgets/barra_opciones.dart';
import '../widgets/dialogo_confirmar.dart';
import '../widgets/estado_vacio.dart';
import '../widgets/etiqueta_estado.dart';
import '../widgets/fila_dato.dart';

/// P9 · Mis anuncios: lo que he publicado. Desde cada anuncio se puede editar,
/// abrir el chat si alguien lo ha reservado o retirarlo confirmando antes (RF12).
class PantallaMisAnuncios extends StatelessWidget {
  const PantallaMisAnuncios({super.key});

  @override
  Widget build(BuildContext context) {
    final misAnuncios = DatosScope.of(context).misAnuncios;

    return Scaffold(
      appBar: AppBar(title: const Text('Mis anuncios')),
      bottomNavigationBar: const BarraOpciones(actual: SeccionBarra.inicio),
      body: ListView(
        padding: const EdgeInsets.all(Espacio.m),
        children: [
          // Cambio de la revisión de la semana 3 (3.7): en la prueba de primer
          // clic una persona buscó aquí cómo publicar, así que el botón también
          // está en esta pantalla. Se llama igual que en la barra (RNF5).
          FilledButton.icon(
            onPressed: () => Navigator.pushNamed(context, Rutas.publicar),
            icon: const Icon(Icons.add),
            label: const Text('Publicar material'),
          ),
          const SizedBox(height: Espacio.l),
          if (misAnuncios.isEmpty)
            const EstadoVacio(
              icono: Icons.sell_outlined,
              texto: 'Todavía no has publicado ningún material. Pulsa "Publicar material" para crear tu primer anuncio.',
            )
          else
            for (final anuncio in misAnuncios)
              Padding(
                padding: const EdgeInsets.only(bottom: Espacio.m),
                child: _TarjetaMiAnuncio(anuncio: anuncio),
              ),
        ],
      ),
    );
  }
}

class _TarjetaMiAnuncio extends StatelessWidget {
  const _TarjetaMiAnuncio({required this.anuncio});

  final Anuncio anuncio;

  Future<void> _retirar(BuildContext context) async {
    final retirar = await confirmarAccion(
      context,
      titulo: '¿Retirar el anuncio?',
      mensaje: '"${anuncio.nombre}" dejará de aparecer en el buscador. Esto no se puede deshacer.',
      textoConfirmar: 'Sí, retirar anuncio',
      textoCancelar: 'No, mantenerlo',
    );
    if (!retirar || !context.mounted) return;
    DatosScope.of(context, escuchar: false).retirar(anuncio);
    mostrarMensaje(context, 'Anuncio "${anuncio.nombre}" retirado.');
  }

  void _abrirChat(BuildContext context) {
    final conversacion = DatosScope.of(context, escuchar: false).conversacionDe(anuncio);
    Navigator.pushNamed(context, Rutas.conversacion, arguments: conversacion);
  }

  @override
  Widget build(BuildContext context) {
    final reservado = anuncio.estado == EstadoMaterial.reservado;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Espacio.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(header: true, child: Text(anuncio.nombre, style: Theme.of(context).textTheme.titleMedium)),
            const SizedBox(height: Espacio.s),
            Align(alignment: AlignmentDirectional.centerStart, child: EtiquetaEstado(estado: anuncio.estado)),
            const SizedBox(height: Espacio.s),
            FilaDato('Tipo', anuncio.tipo.texto),
            FilaDato('Precio', anuncio.precioTexto),
            FilaDato('Fechas', anuncio.fechas),
            const SizedBox(height: Espacio.m),
            if (reservado) ...[
              FilledButton.icon(
                onPressed: () => _abrirChat(context),
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text('Abrir chat'),
              ),
              const SizedBox(height: Espacio.s),
            ],
            OutlinedButton.icon(
              onPressed: () => Navigator.pushNamed(context, Rutas.publicar, arguments: anuncio),
              icon: const Icon(Icons.edit_outlined),
              label: Text('Editar', semanticsLabel: 'Editar el anuncio ${anuncio.nombre}'),
            ),
            // Más separación con la acción destructiva.
            const SizedBox(height: Espacio.l),
            OutlinedButton.icon(
              style: estiloBotonDestructivo(context),
              onPressed: () => _retirar(context),
              icon: const Icon(Icons.delete_outline),
              label: Text('Retirar anuncio', semanticsLabel: 'Retirar el anuncio ${anuncio.nombre}'),
            ),
          ],
        ),
      ),
    );
  }
}
