import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../datos/datos_app.dart';
import '../navegacion/rutas.dart';
import '../tema/colores.dart';
import '../tema/tema.dart';
import '../widgets/barra_superior.dart';
import '../widgets/campo_texto.dart';
import 'p1_crear_cuenta.dart';

/// P1 · Iniciar sesión (recorrido 1, RF2).
///
/// Los campos llevan `autofillHints` para que el móvil pueda rellenar la
/// contraseña guardada. Es una simulación: vale cualquier contraseña con un
/// correo de la universidad.
class PantallaIniciarSesion extends StatefulWidget {
  const PantallaIniciarSesion({super.key});

  @override
  State<PantallaIniciarSesion> createState() => _PantallaIniciarSesionState();
}

class _PantallaIniciarSesionState extends State<PantallaIniciarSesion> {
  final _formulario = GlobalKey<FormState>();
  final _correo = TextEditingController();
  final _contrasena = TextEditingController();
  bool _verContrasena = false;

  @override
  void dispose() {
    _correo.dispose();
    _contrasena.dispose();
    super.dispose();
  }

  void _entrar() {
    if (!_formulario.currentState!.validate()) return;
    TextInput.finishAutofillContext();
    DatosScope.of(context, escuchar: false).iniciarSesion(_correo.text);
    Navigator.pushNamedAndRemoveUntil(context, Rutas.menu, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: barraSuperior(context, 'Iniciar sesión'),
      body: SafeArea(
        child: AutofillGroup(
          child: Form(
            key: _formulario,
            autovalidateMode: AutovalidateMode.onUserInteractionIfError,
            child: ListView(
              padding: const EdgeInsets.all(Espacio.m),
              children: [
                Text('Entra con el correo de la universidad y tu contraseña.', style: textos.bodyLarge),
                const SizedBox(height: Espacio.l),
                CampoTexto(
                  etiqueta: 'Correo de la universidad',
                  controlador: _correo,
                  pista: 'nombre@estudiantes.unileon.es',
                  teclado: TextInputType.emailAddress,
                  accionTeclado: TextInputAction.next,
                  autorrelleno: const [AutofillHints.email, AutofillHints.username],
                  autocorreccion: false,
                  validador: validarCorreoUniversidad,
                ),
                const SizedBox(height: Espacio.l),
                CampoTexto(
                  etiqueta: 'Contraseña',
                  controlador: _contrasena,
                  oculto: !_verContrasena,
                  autorrelleno: const [AutofillHints.password],
                  alEnviar: (_) => _entrar(),
                  validador: (valor) => (valor == null || valor.isEmpty) ? 'Escribe tu contraseña.' : null,
                ),
                CasillaVerContrasena(
                  valor: _verContrasena,
                  alCambiar: (valor) => setState(() => _verContrasena = valor),
                ),
                const SizedBox(height: Espacio.l),
                FilledButton.icon(onPressed: _entrar, icon: const Icon(Icons.login), label: const Text('Iniciar sesión')),
                const SizedBox(height: Espacio.m),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pushReplacementNamed(context, Rutas.crearCuenta),
                  icon: const Icon(Icons.person_add_alt_1),
                  label: const Text('¿No tienes cuenta? Crear cuenta'),
                ),
                const SizedBox(height: Espacio.m),
                Text(
                  'Versión de prueba: vale cualquier contraseña.',
                  textAlign: TextAlign.center,
                  style: textos.bodyMedium?.copyWith(color: ColoresApp.textoSecundario),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
