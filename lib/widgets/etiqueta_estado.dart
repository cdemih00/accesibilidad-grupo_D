import 'package:flutter/material.dart';

import '../datos/modelos.dart';
import '../tema/colores.dart';
import '../tema/tema.dart';

/// Estado del material (4.1 y 4.3): "Disponible" en verde con ✓ y "Reservado"
/// en gris con un reloj. En escala de grises los dos colores se ven casi
/// iguales, así que el icono y el texto son los que los distinguen (R6,
/// RNF10). TalkBack lo lee como "Estado: Disponible".
class EtiquetaEstado extends StatelessWidget {
  const EtiquetaEstado({super.key, required this.estado});

  final EstadoMaterial estado;

  @override
  Widget build(BuildContext context) {
    final disponible = estado == EstadoMaterial.disponible;
    final color = disponible ? ColoresApp.exito : ColoresApp.textoSecundario;

    return Semantics(
      label: 'Estado: ${estado.texto}',
      excludeSemantics: true,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(disponible ? Icons.check_circle_outline : Icons.schedule, size: 20, color: color),
          const SizedBox(width: Espacio.s),
          Flexible(
            child: Text(
              estado.texto,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}
