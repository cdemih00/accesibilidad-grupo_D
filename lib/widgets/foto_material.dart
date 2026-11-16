import 'package:flutter/material.dart';

import '../datos/modelos.dart';
import '../tema/colores.dart';
import '../tema/tema.dart';

/// Foto de un anuncio en la ficha (P4). La descripción que escribió el dueño
/// se ve debajo y es lo que lee TalkBack: "Foto 1 de 2: cámara negra..."
/// (R7, RF4, RNF9).
class FotoMaterial extends StatelessWidget {
  const FotoMaterial({super.key, required this.foto, required this.numero, required this.total});

  final Foto foto;
  final int numero;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      image: true,
      label: 'Foto $numero de $total: ${foto.descripcion}',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          MarcoFoto(icono: foto.icono, alto: 176),
          const SizedBox(height: Espacio.s),
          Text(
            foto.descripcion,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: ColoresApp.textoSecundario),
          ),
        ],
      ),
    );
  }
}

/// Recuadro gris claro con un icono que hace de foto en esta versión sin
/// imágenes. Es decorativo: quien lo usa decide qué tiene que leer TalkBack.
class MarcoFoto extends StatelessWidget {
  const MarcoFoto({super.key, required this.icono, this.alto = 176, this.ancho});

  final IconData icono;
  final double alto;
  final double? ancho;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        height: alto,
        width: ancho,
        decoration: BoxDecoration(color: ColoresApp.separador, borderRadius: BorderRadius.circular(12)),
        child: Icon(icono, size: alto * 0.4, color: ColoresApp.textoSecundario),
      ),
    );
  }
}
