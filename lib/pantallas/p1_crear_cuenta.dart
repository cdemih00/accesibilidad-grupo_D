import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../datos/datos_app.dart';
import '../navegacion/rutas.dart';
import '../tema/colores.dart';
import '../tema/tema.dart';
import '../widgets/aviso.dart';

/// P1 · Crear cuenta (recorrido 1, RF1).
///
/// Dos pasos: datos (correo de la universidad y contraseña) y código de
/// verificación. Los errores dicen qué falla y cómo arreglarlo, salen debajo
/// del campo y TalkBack los lee (RNF6). Lo escrito no se borra al fallar
/// (RNF7) y se puede pedir otro código o cambiar el correo sin empezar de cero.
class PantallaCrearCuenta extends StatefulWidget {
  const PantallaCrearCuenta({super.key});

  @override
  State<PantallaCrearCuenta> createState() => _PantallaCrearCuentaState();
}

class _PantallaCrearCuentaState extends State<PantallaCrearCuenta> {
  final _formulario = GlobalKey<FormState>();
  final _correo = TextEditingController();
  final _contrasena = TextEditingController();
  final _codigo = TextEditingController();
  bool _codigoEnviado = false;
  bool _verContrasena = false;
  String? _errorCodigo;

  @override
  void dispose() {
    _correo.dispose();
    _contrasena.dispose();
    _codigo.dispose();
    super.dispose();
  }

  void _enviarCodigo() {
    if (!_formulario.currentState!.validate()) return;
    setState(() => _codigoEnviado = true);
    mostrarMensaje(context, 'Te hemos enviado un código a ${_correo.text.trim()}.');
  }

  void _verificar() {
    if (_codigo.text.trim() != DatosApp.codigoDePrueba) {
      setState(() {
        _errorCodigo = 'El código no es correcto. Escribe los 6 números que te hemos enviado a '
            '${_correo.text.trim()} o pide uno nuevo.';
      });
      return;
    }
    TextInput.finishAutofillContext();
    DatosScope.of(context, escuchar: false).iniciarSesion(_correo.text);
    Navigator.pushNamedAndRemoveUntil(context, Rutas.menu, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // "Atrás" en el paso del código vuelve a los datos sin perderlos.
      canPop: !_codigoEnviado,
      onPopInvokedWithResult: (salio, _) {
        if (!salio) setState(() => _codigoEnviado = false);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Crear cuenta')),
        body: SafeArea(
          child: AutofillGroup(
            child: ListView(
              padding: const EdgeInsets.all(Espacio.l),
              children: _codigoEnviado ? _pasoCodigo(context) : _pasoDatos(context),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _pasoDatos(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return [
      Semantics(header: true, child: Text('Paso 1 de 2: tus datos', style: textos.titleMedium)),
      const SizedBox(height: Espacio.l),
      Form(
        key: _formulario,
        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _correo,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autofillHints: const [AutofillHints.email],
              autocorrect: false,
              decoration: const InputDecoration(
                labelText: 'Correo de la universidad',
                hintText: 'nombre@estudiantes.unileon.es',
                helperText: 'Tiene que terminar en @unileon.es o en @estudiantes.unileon.es.',
              ),
              validator: (valor) {
                if (valor == null || valor.trim().isEmpty) return 'Escribe tu correo de la universidad.';
                if (!DatosApp.esCorreoDeLaUniversidad(valor)) {
                  return 'Tienes que usar tu correo de la universidad, que termina en @unileon.es '
                      'o en @estudiantes.unileon.es.';
                }
                return null;
              },
            ),
            const SizedBox(height: Espacio.l),
            TextFormField(
              controller: _contrasena,
              obscureText: !_verContrasena,
              autofillHints: const [AutofillHints.newPassword],
              onFieldSubmitted: (_) => _enviarCodigo(),
              decoration: InputDecoration(
                labelText: 'Contraseña',
                helperText: 'Mínimo 8 caracteres.',
                // Botón con texto en vez de un ojo suelto (R3).
                suffixIcon: TextButton(
                  onPressed: () => setState(() => _verContrasena = !_verContrasena),
                  child: Text(
                    _verContrasena ? 'Ocultar' : 'Mostrar',
                    semanticsLabel: _verContrasena ? 'Ocultar la contraseña' : 'Mostrar la contraseña',
                  ),
                ),
              ),
              validator: (valor) => (valor == null || valor.length < 8)
                  ? 'La contraseña tiene que tener al menos 8 caracteres.'
                  : null,
            ),
          ],
        ),
      ),
      const SizedBox(height: Espacio.xl),
      FilledButton(onPressed: _enviarCodigo, child: const Text('Enviar código')),
      const SizedBox(height: Espacio.m),
      TextButton(
        onPressed: () => Navigator.pushReplacementNamed(context, Rutas.iniciarSesion),
        child: const Text('¿Ya tienes cuenta? Inicia sesión'),
      ),
    ];
  }

  List<Widget> _pasoCodigo(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return [
      Semantics(header: true, child: Text('Paso 2 de 2: código de verificación', style: textos.titleMedium)),
      const SizedBox(height: Espacio.m),
      Text('Hemos enviado un código de 6 números a ${_correo.text.trim()}.', style: textos.bodyLarge),
      const SizedBox(height: Espacio.s),
      Text(
        'En esta versión de prueba el código es ${DatosApp.codigoDePrueba}.',
        style: textos.bodyMedium?.copyWith(color: Paleta.de(context).textoSecundario),
      ),
      const SizedBox(height: Espacio.l),
      TextField(
        controller: _codigo,
        keyboardType: TextInputType.number,
        // Permite que el teclado proponga el código o pegarlo (RF1).
        autofillHints: const [AutofillHints.oneTimeCode],
        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
        onChanged: (_) {
          if (_errorCodigo != null) setState(() => _errorCodigo = null);
        },
        onSubmitted: (_) => _verificar(),
        decoration: InputDecoration(
          labelText: 'Código de verificación',
          hintText: '6 números',
          errorText: _errorCodigo,
        ),
      ),
      const SizedBox(height: Espacio.xl),
      FilledButton(onPressed: _verificar, child: const Text('Verificar y entrar')),
      const SizedBox(height: Espacio.m),
      Wrap(
        spacing: Espacio.s,
        runSpacing: Espacio.s,
        children: [
          OutlinedButton(
            onPressed: () => mostrarMensaje(context, 'Te hemos enviado un código nuevo a ${_correo.text.trim()}.'),
            child: const Text('Pedir otro código'),
          ),
          TextButton(
            onPressed: () => setState(() => _codigoEnviado = false),
            child: const Text('Cambiar el correo'),
          ),
        ],
      ),
    ];
  }
}
