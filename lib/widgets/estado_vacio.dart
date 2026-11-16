import 'package:flutter/material.dart';

import '../tema/colores.dart';
import '../tema/tema.dart';

/// Lo que se enseña cuando una lista está vacía. Explica por qué y, si se
/// puede, da una salida con un botón, para que no sea un callejón sin salida.
class EstadoVacio extends StatelessWidget {
  const EstadoVacio({super.key, required this.icono, required this.texto, this.textoBoton, this.alPulsar});

  final IconData icono;
  final String texto;
  final String? textoBoton;
  final VoidCallback? alPulsar;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Espacio.l),
      child: Column(
        children: [
          ExcludeSemantics(child: Icon(icono, size: 56, color: Paleta.de(context).textoSecundario)),
          const SizedBox(height: Espacio.m),
          Text(texto, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
          if (textoBoton != null) ...[
            const SizedBox(height: Espacio.l),
            FilledButton(onPressed: alPulsar, child: Text(textoBoton!)),
          ],
        ],
      ),
    );
  }
}
