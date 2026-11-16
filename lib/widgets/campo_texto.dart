import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../tema/colores.dart';
import '../tema/tema.dart';

/// Campo de texto con la etiqueta fuera, encima (4.1, RNF4): se ve siempre,
/// antes, durante y después de escribir, y nunca se usa solo el placeholder.
///
/// La etiqueta y el campo se leen juntos con TalkBack ("Correo de la
/// universidad, campo de texto"). El error sale debajo en rojo, con icono, y
/// TalkBack lo lee en cuanto aparece (RNF6). Funciona dentro de un Form con
/// [validador], o con [error] cuando el error lo decide la pantalla.
class CampoTexto extends StatelessWidget {
  const CampoTexto({
    super.key,
    required this.etiqueta,
    required this.controlador,
    this.pista,
    this.ayuda,
    this.validador,
    this.error,
    this.teclado,
    this.accionTeclado,
    this.autorrelleno,
    this.oculto = false,
    this.lineasMinimas,
    this.lineasMaximas = 1,
    this.mayusculas = TextCapitalization.none,
    this.autocorreccion = true,
    this.formateadores,
    this.sufijo,
    this.foco,
    this.alCambiar,
    this.alEnviar,
    this.alLado,
  });

  final String etiqueta;
  final TextEditingController controlador;

  /// Texto de ejemplo dentro del campo. Nunca sustituye a la etiqueta.
  final String? pista;

  /// Ayuda debajo del campo, a 14 sp.
  final String? ayuda;
  final FormFieldValidator<String>? validador;
  final String? error;
  final TextInputType? teclado;
  final TextInputAction? accionTeclado;
  final Iterable<String>? autorrelleno;
  final bool oculto;
  final int? lineasMinimas;

  /// `null` para que crezca con lo que se escribe.
  final int? lineasMaximas;
  final TextCapitalization mayusculas;
  final bool autocorreccion;
  final List<TextInputFormatter>? formateadores;
  final String? sufijo;
  final FocusNode? foco;
  final ValueChanged<String>? alCambiar;
  final ValueChanged<String>? alEnviar;

  /// Botón a la derecha del campo, como "Buscar" o "Enviar".
  final Widget? alLado;

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final validar = validador;

    return FormField<String>(
      validator: validar == null ? null : (_) => validar(controlador.text),
      builder: (estado) {
        final mensajeError = error ?? estado.errorText;
        final campo = TextField(
          controller: controlador,
          focusNode: foco,
          obscureText: oculto,
          keyboardType: teclado,
          textInputAction: accionTeclado,
          autofillHints: autorrelleno,
          minLines: lineasMinimas,
          maxLines: oculto ? 1 : lineasMaximas,
          textCapitalization: mayusculas,
          autocorrect: autocorreccion && !oculto,
          enableSuggestions: !oculto,
          inputFormatters: formateadores,
          onChanged: (valor) {
            estado.didChange(valor);
            alCambiar?.call(valor);
          },
          onSubmitted: alEnviar,
          decoration: InputDecoration(
            hintText: pista,
            suffixText: sufijo,
            // Con un error, el borde pasa a rojo de 2 dp (4.1).
            enabledBorder: mensajeError == null ? null : _bordeError,
            focusedBorder: mensajeError == null ? null : _bordeError,
          ),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  // Etiqueta y campo son un solo elemento para TalkBack.
                  child: MergeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(etiqueta, style: textos.labelMedium?.copyWith(color: ColoresApp.texto)),
                        const SizedBox(height: Espacio.s),
                        campo,
                      ],
                    ),
                  ),
                ),
                if (alLado != null) ...[const SizedBox(width: Espacio.s), alLado!],
              ],
            ),
            if (mensajeError != null) ...[
              const SizedBox(height: Espacio.s),
              MensajeError(mensajeError),
            ] else if (ayuda != null) ...[
              const SizedBox(height: Espacio.s),
              Text(ayuda!, style: textos.bodySmall?.copyWith(color: ColoresApp.textoSecundario)),
            ],
          ],
        );
      },
    );
  }
}

const _bordeError = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(12)),
  borderSide: BorderSide(color: ColoresApp.error, width: 2),
);

/// Mensaje de error (4.1): texto e icono en rojo, a 14 sp. Es una "live
/// region", así que TalkBack lo lee en cuanto aparece (RNF6).
class MensajeError extends StatelessWidget {
  const MensajeError(this.texto, {super.key});

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      liveRegion: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ExcludeSemantics(child: Icon(Icons.error_outline, color: ColoresApp.error, size: 20)),
          const SizedBox(width: Espacio.s),
          Expanded(
            child: Text(
              texto,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: ColoresApp.error,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
