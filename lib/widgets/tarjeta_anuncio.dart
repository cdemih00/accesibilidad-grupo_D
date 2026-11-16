import 'package:flutter/material.dart';

import '../datos/modelos.dart';
import '../navegacion/rutas.dart';
import '../tema/colores.dart';
import '../tema/tema.dart';
import 'etiqueta_estado.dart';
import 'foto_material.dart';

/// Tarjeta de material del catálogo (P3) y de "Te puede interesar" (P2), como
/// la describe el apartado 4.1: borde gris, foto a la izquierda, datos
/// principales en #111827, secundarios en #475569 y el estado con su icono.
///
/// Toda la tarjeta es un único botón que abre la ficha (P4), y TalkBack la lee
/// de una vez: nombre, para qué sirve, tipo y estado.
class TarjetaAnuncio extends StatelessWidget {
  const TarjetaAnuncio({super.key, required this.anuncio});

  final Anuncio anuncio;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final icono = anuncio.fotos.isEmpty ? Icons.photo_outlined : anuncio.fotos.first.icono;

    return Card(
      child: MergeSemantics(
        child: Semantics(
          button: true,
          onTapHint: 'abrir la ficha',
          child: InkWell(
            onTap: () => Navigator.pushNamed(context, Rutas.detalle, arguments: anuncio),
            child: Padding(
              padding: const EdgeInsets.all(Espacio.m),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MarcoFoto(icono: icono, alto: 72, ancho: 72),
                  const SizedBox(width: Espacio.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(anuncio.nombre, style: textos.titleSmall),
                        Text(anuncio.paraQueSirve, style: textos.bodyMedium?.copyWith(color: ColoresApp.textoSecundario)),
                        Text(
                          anuncio.condicionesCortas,
                          // Con coma para que el lector no lea el punto medio.
                          semanticsLabel: anuncio.condicionesCortas.replaceAll(' · ', ', '),
                          style: textos.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: Espacio.s),
                        EtiquetaEstado(estado: anuncio.estado),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
