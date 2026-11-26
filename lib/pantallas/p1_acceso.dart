import 'package:flutter/material.dart';

import '../navegacion/rutas.dart';
import '../tema/colores.dart';
import '../tema/tema.dart';

/// P1 · Inicio de sesión y registro: pantalla de bienvenida (recorrido 1).
///
/// "Crear cuenta" es el botón principal e "Iniciar sesión" el secundario: en
/// la prueba de primer clic (3.5) una persona dudó porque los dos tenían la
/// misma importancia. Los botones van abajo, donde llega el pulgar (R5).
class PantallaAcceso extends StatelessWidget {
  const PantallaAcceso({super.key});

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, limites) => SingleChildScrollView(
            padding: const EdgeInsets.all(Espacio.m),
            child: ConstrainedBox(
              // Ocupa toda la pantalla para dejar los botones abajo, pero si el
              // texto es muy grande se puede desplazar.
              constraints: BoxConstraints(minHeight: limites.maxHeight - 2 * Espacio.m),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: Espacio.xl),
                    const ExcludeSemantics(
                      child: Icon(Icons.volunteer_activism_outlined, size: 72, color: ColoresApp.azul),
                    ),
                    const SizedBox(height: Espacio.m),
                    Semantics(
                      header: true,
                      container: true,
                      child: Text('EmprestApp', textAlign: TextAlign.center, style: textos.headlineLarge),
                    ),
                    const SizedBox(height: Espacio.s),
                    Text(
                      'Presta, alquila o regala material universitario a otros estudiantes de tu campus.',
                      textAlign: TextAlign.center,
                      style: textos.bodyLarge,
                    ),
                    const Spacer(),
                    const SizedBox(height: Espacio.xl),
                    FilledButton.icon(
                      onPressed: () => Navigator.pushNamed(context, Rutas.crearCuenta),
                      icon: const Icon(Icons.person_add_alt_1),
                      label: const Text('Crear cuenta'),
                    ),
                    const SizedBox(height: Espacio.m),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.pushNamed(context, Rutas.iniciarSesion),
                      icon: const Icon(Icons.login),
                      label: const Text('Iniciar sesión'),
                    ),
                    const SizedBox(height: Espacio.m),
                    Text(
                      'Para registrarte necesitas el correo de la Universidad de León.',
                      textAlign: TextAlign.center,
                      style: textos.bodyMedium?.copyWith(color: ColoresApp.textoSecundario),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
