import 'package:flutter/material.dart';

import '../tema/colores.dart';
import '../tema/tema.dart';

/// Aviso de error o de éxito dentro de una pantalla, por ejemplo "Falta añadir
/// al menos una foto". Lleva icono y texto, no solo color (RNF10), y TalkBack
/// lo lee en cuanto aparece porque es una "live region" (RNF6).
class Aviso extends StatelessWidget {
  const Aviso.error(this.texto, {super.key}) : esError = true;
  const Aviso.exito(this.texto, {super.key}) : esError = false;

  final String texto;
  final bool esError;

  @override
  Widget build(BuildContext context) {
    final colores = Paleta.de(context);
    final fondo = esError ? colores.errorSuave : colores.exitoSuave;
    final colorTexto = esError ? colores.sobreErrorSuave : colores.sobreExitoSuave;
    final colorBorde = esError ? colores.error : colores.exito;

    return Semantics(
      container: true,
      liveRegion: true,
      child: Container(
        padding: const EdgeInsets.all(Espacio.m),
        decoration: BoxDecoration(
          color: fondo,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colorBorde, width: 1.5),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(esError ? Icons.error_outline : Icons.check_circle_outline, color: colorBorde),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                texto,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorTexto,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Mensaje corto en la parte de abajo (snackbar) para confirmar lo que acaba de
/// pasar: "Reserva confirmada", "Anuncio publicado"... Dura unos segundos, se
/// puede cerrar con su botón y TalkBack lo lee al aparecer.
void mostrarMensaje(BuildContext context, String texto) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(texto), duration: const Duration(seconds: 6)));
}
