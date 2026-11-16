import 'package:flutter/material.dart';

import '../tema/tema.dart';

/// Pide confirmación antes de una acción importante: cancelar una reserva,
/// retirar un anuncio, borrar una foto o cerrar sesión (4.4, R8, RF6, RF12).
///
/// El mensaje dice qué reserva, anuncio o foto se verá afectado, y los botones
/// nombran la acción y la alternativa ("Retirar anuncio" / "Volver sin
/// retirar"). El botón de confirmar solo es rojo si la acción borra algo
/// ([destructiva]); si no, es el principal azul. Devuelve `true` solo si se
/// pulsa confirmar. El título es lo primero que anuncia TalkBack.
Future<bool> confirmarAccion(
  BuildContext context, {
  required String titulo,
  required String mensaje,
  required String textoConfirmar,
  required String textoCancelar,
  required IconData icono,
  bool destructiva = true,
  bool cerrarTocandoFuera = true,
}) async {
  final confirmado = await showDialog<bool>(
    context: context,
    barrierDismissible: cerrarTocandoFuera,
    builder: (context) => AlertDialog(
      semanticLabel: titulo,
      scrollable: true,
      title: Text(titulo),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(mensaje),
          const SizedBox(height: Espacio.l),
          BotonesDialogo(
            textoConfirmar: textoConfirmar,
            textoCancelar: textoCancelar,
            icono: icono,
            destructiva: destructiva,
            alConfirmar: () => Navigator.pop(context, true),
            alCancelar: () => Navigator.pop(context, false),
          ),
        ],
      ),
    ),
  );
  return confirmado ?? false;
}

/// Los dos botones de un diálogo de confirmación (4.1): confirmar arriba y
/// cancelar debajo, a todo lo ancho y separados 8 dp. Cancelar es siempre el
/// botón secundario (blanco con borde), así no se confunde con confirmar
/// aunque no se distingan los colores (revisión del 4.3).
class BotonesDialogo extends StatelessWidget {
  const BotonesDialogo({
    super.key,
    required this.textoConfirmar,
    required this.textoCancelar,
    required this.icono,
    required this.alConfirmar,
    required this.alCancelar,
    this.destructiva = false,
  });

  final String textoConfirmar;
  final String textoCancelar;
  final IconData icono;
  final VoidCallback alConfirmar;
  final VoidCallback alCancelar;
  final bool destructiva;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FilledButton.icon(
          style: destructiva ? estiloBotonDestructivo(context) : null,
          onPressed: alConfirmar,
          icon: Icon(icono),
          label: Text(textoConfirmar),
        ),
        const SizedBox(height: Espacio.s),
        OutlinedButton.icon(
          onPressed: alCancelar,
          icon: const Icon(Icons.arrow_back),
          label: Text(textoCancelar),
        ),
      ],
    );
  }
}
