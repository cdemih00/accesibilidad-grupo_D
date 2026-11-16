import 'package:flutter/material.dart';

import '../datos/modelos.dart';
import '../tema/colores.dart';
import '../tema/tema.dart';

/// Estado del material ("Disponible" / "Reservado") con texto, icono y color a
/// la vez, para que no dependa solo del color (R6, RNF10). TalkBack lo lee
/// como "Estado: Disponible".
class EtiquetaEstado extends StatelessWidget {
  const EtiquetaEstado({super.key, required this.estado});

  final EstadoMaterial estado;

  @override
  Widget build(BuildContext context) {
    final disponible = estado == EstadoMaterial.disponible;
    final colores = Paleta.de(context);
    final fondo = disponible ? colores.exitoSuave : colores.reservadoSuave;
    final colorTexto = disponible ? colores.sobreExitoSuave : colores.sobreReservadoSuave;
    final colorIcono = disponible ? colores.exito : colores.reservado;

    return Semantics(
      label: 'Estado: ${estado.texto}',
      excludeSemantics: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: Espacio.xs),
        decoration: BoxDecoration(
          color: fondo,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorIcono),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(disponible ? Icons.check_circle : Icons.event_busy, size: 18, color: colorIcono),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                estado.texto,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(color: colorTexto),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
