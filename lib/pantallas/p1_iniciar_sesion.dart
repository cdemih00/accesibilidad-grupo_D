import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../datos/datos_app.dart';
import '../navegacion/rutas.dart';
import '../tema/colores.dart';
import '../tema/tema.dart';

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
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: SafeArea(
        child: AutofillGroup(
          child: Form(
            key: _formulario,
            autovalidateMode: AutovalidateMode.onUserInteractionIfError,
            child: ListView(
              padding: const EdgeInsets.all(Espacio.l),
              children: [
                Text(
                  'Entra con el correo de la universidad y tu contraseña.',
                  style: textos.bodyLarge,
                ),
                const SizedBox(height: Espacio.l),
                TextFormField(
                  controller: _correo,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email, AutofillHints.username],
                  autocorrect: false,
                  decoration: const InputDecoration(
                    labelText: 'Correo de la universidad',
                    hintText: 'nombre@estudiantes.unileon.es',
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
                  autofillHints: const [AutofillHints.password],
                  onFieldSubmitted: (_) => _entrar(),
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    suffixIcon: TextButton(
                      onPressed: () => setState(() => _verContrasena = !_verContrasena),
                      child: Text(
                        _verContrasena ? 'Ocultar' : 'Mostrar',
                        semanticsLabel: _verContrasena ? 'Ocultar la contraseña' : 'Mostrar la contraseña',
                      ),
                    ),
                  ),
                  validator: (valor) => (valor == null || valor.isEmpty) ? 'Escribe tu contraseña.' : null,
                ),
                const SizedBox(height: Espacio.xl),
                FilledButton(onPressed: _entrar, child: const Text('Iniciar sesión')),
                const SizedBox(height: Espacio.m),
                TextButton(
                  onPressed: () => Navigator.pushReplacementNamed(context, Rutas.crearCuenta),
                  child: const Text('¿No tienes cuenta? Crear cuenta'),
                ),
                const SizedBox(height: Espacio.s),
                Text(
                  'Versión de prueba: vale cualquier contraseña.',
                  textAlign: TextAlign.center,
                  style: textos.bodyMedium?.copyWith(color: Paleta.de(context).textoSecundario),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
