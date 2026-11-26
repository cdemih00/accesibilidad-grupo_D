import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../datos/datos_app.dart';
import '../navegacion/rutas.dart';
import '../tema/colores.dart';
import '../tema/tema.dart';
import '../widgets/aviso.dart';
import '../widgets/barra_superior.dart';
import '../widgets/campo_texto.dart';

/// Mensajes de error del apartado 4.4 para el correo (también los usa la
/// pantalla de iniciar sesión).
String? validarCorreoUniversidad(String? valor) {
  if (valor == null || valor.trim().isEmpty) return 'Escribe tu correo de la universidad.';
  if (!DatosApp.esCorreoDeLaUniversidad(valor)) {
    return 'Ese correo no es de la universidad. Usa tu correo @estudiantes.unileon.es o @unileon.es.';
  }
  return null;
}

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
      setState(() => _errorCodigo = 'El código no es correcto. Revísalo o solicita uno nuevo.');
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
        appBar: barraSuperior(context, 'Crear cuenta'),
        body: SafeArea(
          child: AutofillGroup(
            child: ListView(
              padding: const EdgeInsets.all(Espacio.m),
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
      Semantics(header: true, container: true, child: Text('Paso 1 de 2: tus datos', style: textos.titleMedium)),
      const SizedBox(height: Espacio.l),
      Form(
        key: _formulario,
        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CampoTexto(
              etiqueta: 'Correo de la universidad',
              controlador: _correo,
              pista: 'nombre@estudiantes.unileon.es',
              ayuda: 'Tiene que terminar en @estudiantes.unileon.es o en @unileon.es.',
              teclado: TextInputType.emailAddress,
              accionTeclado: TextInputAction.next,
              autorrelleno: const [AutofillHints.email],
              autocorreccion: false,
              validador: validarCorreoUniversidad,
            ),
            const SizedBox(height: Espacio.l),
            CampoTexto(
              etiqueta: 'Contraseña',
              controlador: _contrasena,
              ayuda: 'Mínimo 8 caracteres.',
              oculto: !_verContrasena,
              autorrelleno: const [AutofillHints.newPassword],
              alEnviar: (_) => _enviarCodigo(),
              validador: (valor) => (valor == null || valor.length < 8)
                  ? 'La contraseña tiene que tener al menos 8 caracteres.'
                  : null,
            ),
            CasillaVerContrasena(
              valor: _verContrasena,
              alCambiar: (valor) => setState(() => _verContrasena = valor),
            ),
          ],
        ),
      ),
      const SizedBox(height: Espacio.l),
      FilledButton.icon(
        onPressed: _enviarCodigo,
        icon: const Icon(Icons.mail_outline),
        label: const Text('Enviar código'),
      ),
      const SizedBox(height: Espacio.m),
      OutlinedButton.icon(
        onPressed: () => Navigator.pushReplacementNamed(context, Rutas.iniciarSesion),
        icon: const Icon(Icons.login),
        label: const Text('¿Ya tienes cuenta? Inicia sesión'),
      ),
    ];
  }

  List<Widget> _pasoCodigo(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    return [
      Semantics(header: true, container: true, child: Text('Paso 2 de 2: código de verificación', style: textos.titleMedium)),
      const SizedBox(height: Espacio.m),
      Text('Hemos enviado un código de 6 números a ${_correo.text.trim()}.', style: textos.bodyLarge),
      const SizedBox(height: Espacio.s),
      Text(
        'En esta versión de prueba el código es ${DatosApp.codigoDePrueba}.',
        style: textos.bodyMedium?.copyWith(color: ColoresApp.textoSecundario),
      ),
      const SizedBox(height: Espacio.l),
      CampoTexto(
        etiqueta: 'Código de verificación',
        controlador: _codigo,
        pista: '6 números',
        teclado: TextInputType.number,
        // Permite que el teclado proponga el código o pegarlo (RF1).
        autorrelleno: const [AutofillHints.oneTimeCode],
        formateadores: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(6)],
        error: _errorCodigo,
        alCambiar: (_) {
          if (_errorCodigo != null) setState(() => _errorCodigo = null);
        },
        alEnviar: (_) => _verificar(),
      ),
      const SizedBox(height: Espacio.l),
      FilledButton.icon(
        onPressed: _verificar,
        icon: const Icon(Icons.login),
        label: const Text('Verificar y entrar'),
      ),
      const SizedBox(height: Espacio.m),
      Wrap(
        spacing: Espacio.s,
        runSpacing: Espacio.s,
        children: [
          OutlinedButton.icon(
            onPressed: () => mostrarMensaje(context, 'Te hemos enviado un código nuevo a ${_correo.text.trim()}.'),
            icon: const Icon(Icons.refresh),
            label: const Text('Pedir otro código'),
          ),
          OutlinedButton.icon(
            onPressed: () => setState(() => _codigoEnviado = false),
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Cambiar el correo'),
          ),
        ],
      ),
    ];
  }
}

/// Casilla "Mostrar la contraseña" debajo del campo: una opción con texto, en
/// vez de un ojo suelto dentro del campo (R3).
class CasillaVerContrasena extends StatelessWidget {
  const CasillaVerContrasena({super.key, required this.valor, required this.alCambiar});

  final bool valor;
  final ValueChanged<bool> alCambiar;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: valor,
      onChanged: (marcado) => alCambiar(marcado ?? false),
      title: const Text('Mostrar la contraseña'),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
    );
  }
}
