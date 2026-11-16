import 'package:flutter/material.dart';

import '../navegacion/rutas.dart';

enum SeccionBarra { inicio, buscar, publicar, chats }

/// "Barra de opciones" de abajo: Inicio, Buscar, Publicar y Chats.
///
/// - Está siempre en el mismo sitio y al alcance del pulgar (R5).
/// - Cada icono lleva su texto debajo y TalkBack lo lee (R3).
/// - "Inicio" vuelve al menú principal desde cualquier pantalla (↩ P2 del
///   mapa) y "Publicar" es el botón global de publicar que se buscaba en la
///   prueba de primer clic.
class BarraOpciones extends StatelessWidget {
  const BarraOpciones({super.key, required this.actual});

  /// Sección a la que pertenece la pantalla en la que se está.
  final SeccionBarra actual;

  static const _rutas = {
    SeccionBarra.inicio: Rutas.menu,
    SeccionBarra.buscar: Rutas.buscar,
    SeccionBarra.publicar: Rutas.publicar,
    SeccionBarra.chats: Rutas.chats,
  };

  @override
  Widget build(BuildContext context) {
    // Línea de arriba para separar la barra del contenido, que en el modo
    // claro tiene un fondo muy parecido.
    return DecoratedBox(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant))),
      child: _barra(context),
    );
  }

  Widget _barra(BuildContext context) {
    return NavigationBar(
      selectedIndex: actual.index,
      onDestinationSelected: (indice) {
        final ruta = _rutas[SeccionBarra.values[indice]]!;
        // Si ya estamos en esa pantalla no se hace nada.
        if (ModalRoute.of(context)?.settings.name == ruta) return;
        irA(context, ruta);
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Inicio'),
        NavigationDestination(icon: Icon(Icons.search), label: 'Buscar'),
        NavigationDestination(icon: Icon(Icons.add_box_outlined), selectedIcon: Icon(Icons.add_box), label: 'Publicar'),
        NavigationDestination(
          icon: Icon(Icons.chat_bubble_outline),
          selectedIcon: Icon(Icons.chat_bubble),
          label: 'Chats',
        ),
      ],
    );
  }
}
