import 'package:flutter/material.dart';

import '../navegacion/rutas.dart';
import '../tema/colores.dart';
import '../tema/tema.dart';

enum SeccionBarra { inicio, buscar, publicar, chats }

/// "Barra de opciones" de abajo: Inicio, Buscar, Publicar y Chats (4.1).
///
/// - Cada opción lleva su icono y su texto a 14 sp, y TalkBack la lee (R3).
/// - La opción en la que estás va en azul, en negrita y con una raya encima,
///   así se reconoce también sin distinguir los colores.
/// - Está siempre en el mismo sitio, al alcance del pulgar (R5). "Inicio"
///   vuelve al menú principal desde cualquier pantalla principal (↩ P2 del
///   mapa) y "Publicar" es el botón global de publicar.
class BarraOpciones extends StatelessWidget {
  const BarraOpciones({super.key, required this.actual});

  /// Sección a la que pertenece la pantalla en la que se está.
  final SeccionBarra actual;

  static const _destinos = [
    _Destino(SeccionBarra.inicio, 'Inicio', Icons.home_outlined, Icons.home, Rutas.menu),
    _Destino(SeccionBarra.buscar, 'Buscar', Icons.search, Icons.search, Rutas.buscar),
    _Destino(SeccionBarra.publicar, 'Publicar', Icons.add_box_outlined, Icons.add_box, Rutas.publicar),
    _Destino(SeccionBarra.chats, 'Chats', Icons.chat_bubble_outline, Icons.chat_bubble, Rutas.chats),
  ];

  void _ir(BuildContext context, _Destino destino) {
    // Si ya estamos en esa pantalla no se hace nada.
    if (ModalRoute.of(context)?.settings.name == destino.ruta) return;
    irA(context, destino.ruta);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColoresApp.fondo,
      child: DecoratedBox(
        decoration: const BoxDecoration(border: Border(top: BorderSide(color: ColoresApp.separador))),
        child: SafeArea(
          top: false,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final destino in _destinos)
                Expanded(
                  child: _BotonDestino(
                    destino: destino,
                    seleccionado: destino.seccion == actual,
                    alPulsar: () => _ir(context, destino),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Destino {
  const _Destino(this.seccion, this.etiqueta, this.icono, this.iconoMarcado, this.ruta);

  final SeccionBarra seccion;
  final String etiqueta;
  final IconData icono;
  final IconData iconoMarcado;
  final String ruta;
}

class _BotonDestino extends StatelessWidget {
  const _BotonDestino({required this.destino, required this.seleccionado, required this.alPulsar});

  final _Destino destino;
  final bool seleccionado;
  final VoidCallback alPulsar;

  @override
  Widget build(BuildContext context) {
    final color = seleccionado ? ColoresApp.azul : ColoresApp.textoSecundario;

    return Semantics(
      container: true,
      button: true,
      selected: seleccionado,
      inMutuallyExclusiveGroup: true,
      label: destino.etiqueta,
      excludeSemantics: true,
      child: InkWell(
        onTap: alPulsar,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Raya encima de la opción actual.
              Container(
                height: 4,
                margin: const EdgeInsets.symmetric(horizontal: Espacio.m),
                color: seleccionado ? ColoresApp.azul : Colors.transparent,
              ),
              const SizedBox(height: Espacio.s),
              Icon(seleccionado ? destino.iconoMarcado : destino.icono, color: color),
              Padding(
                padding: const EdgeInsets.fromLTRB(Espacio.s, 0, Espacio.s, Espacio.s),
                // Con la letra muy grande, la palabra se reduce para caber en
                // su hueco en vez de cortarse. TalkBack lee igualmente el nombre.
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    destino.etiqueta,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: color,
                          fontWeight: seleccionado ? FontWeight.w800 : FontWeight.w500,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
