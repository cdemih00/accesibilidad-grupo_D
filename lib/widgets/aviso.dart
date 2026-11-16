import 'package:flutter/material.dart';

import '../tema/colores.dart';
import '../tema/tema.dart';

/// Aviso de error o de éxito dentro de una pantalla, por ejemplo "Falta añadir
/// al menos una foto". Va sobre fondo blanco, con icono y texto a 14 sp en el
/// color del estado (4.1): rojo para los errores y verde y en negrita para las
/// confirmaciones. Así no depende solo del color (RNF10). TalkBack lo lee en
/// cuanto aparece porque es una "live region" (RNF6).
class Aviso extends StatelessWidget {
  const Aviso.error(this.texto, {super.key}) : esError = true;
  const Aviso.exito(this.texto, {super.key}) : esError = false;

  final String texto;
  final bool esError;

  @override
  Widget build(BuildContext context) {
    final color = esError ? ColoresApp.error : ColoresApp.exito;

    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(Espacio.m),
        decoration: BoxDecoration(
          color: ColoresApp.fondo,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 2),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExcludeSemantics(child: Icon(esError ? Icons.error_outline : Icons.check_circle_outline, color: color)),
            const SizedBox(width: Espacio.s),
            Expanded(
              child: Text(
                texto,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: esError ? FontWeight.w600 : FontWeight.w700,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Confirmación corta abajo de la pantalla (estado de éxito, 4.1): "Material
/// publicado", "Reserva confirmada"... En verde, en negrita y con ✓. Dura unos
/// segundos, se puede cerrar con su botón y TalkBack la lee al aparecer.
void mostrarMensaje(BuildContext context, String texto) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 6),
        content: Row(
          children: [
            const ExcludeSemantics(child: Icon(Icons.check_circle_outline, color: ColoresApp.exito)),
            const SizedBox(width: Espacio.s),
            Expanded(child: Text(texto)),
          ],
        ),
      ),
    );
}
