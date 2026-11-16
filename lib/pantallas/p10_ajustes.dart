import 'package:flutter/material.dart';

import '../datos/datos_app.dart';
import '../navegacion/rutas.dart';
import '../tema/tema.dart';
import '../widgets/barra_opciones.dart';
import '../widgets/dialogo_confirmar.dart';

/// P10 · Ajustes: datos de la cuenta, avisos y cerrar sesión (salida del mapa
/// de navegación, que vuelve a la P1). Es una pantalla auxiliar a la que se
/// llega desde el menú principal.
class PantallaAjustes extends StatelessWidget {
  const PantallaAjustes({super.key});

  Future<void> _cerrarSesion(BuildContext context) async {
    final cerrar = await confirmarAccion(
      context,
      titulo: '¿Cerrar sesión?',
      mensaje: 'Para volver a entrar tendrás que escribir tu correo y tu contraseña.',
      textoConfirmar: 'Cerrar sesión',
      textoCancelar: 'No, seguir dentro',
    );
    if (!cerrar || !context.mounted) return;
    DatosScope.of(context, escuchar: false).cerrarSesion();
    Navigator.pushNamedAndRemoveUntil(context, Rutas.acceso, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final datos = DatosScope.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      bottomNavigationBar: const BarraOpciones(actual: SeccionBarra.inicio),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: Espacio.s),
        children: [
          const _Apartado('Cuenta'),
          ListTile(
            leading: const ExcludeSemantics(child: Icon(Icons.person_outline)),
            title: const Text('Nombre de usuario'),
            subtitle: Text(datos.nombre),
          ),
          ListTile(
            leading: const ExcludeSemantics(child: Icon(Icons.mail_outline)),
            title: const Text('Correo'),
            subtitle: Text(datos.correo ?? ''),
          ),
          const Divider(),
          const _Apartado('Avisos'),
          SwitchListTile(
            title: const Text('Mensajes nuevos'),
            subtitle: const Text('Te avisamos cuando alguien te escribe.'),
            value: datos.avisosDeMensajes,
            onChanged: (activado) => datos.cambiarAvisos(mensajes: activado),
          ),
          SwitchListTile(
            title: const Text('Recordatorio de devolución'),
            subtitle: const Text('Te avisamos un día antes de tener que devolver algo.'),
            value: datos.avisosDeDevolucion,
            onChanged: (activado) => datos.cambiarAvisos(devolucion: activado),
          ),
          const Divider(),
          const _Apartado('Apariencia'),
          // Modo claro u oscuro (4.3). Se escucha el valor para que la opción
          // marcada cambie aunque el tema se quede igual.
          ValueListenableBuilder<ThemeMode>(
            valueListenable: datos.modoTema,
            builder: (context, modoTema, _) => RadioGroup<ThemeMode>(
              groupValue: modoTema,
              onChanged: (modo) {
                if (modo != null) datos.modoTema.value = modo;
              },
              child: const Column(
                children: [
                  RadioListTile<ThemeMode>(
                    value: ThemeMode.system,
                    title: Text('Como en el móvil'),
                    subtitle: Text('Claro u oscuro según los ajustes del móvil.'),
                  ),
                  RadioListTile<ThemeMode>(value: ThemeMode.light, title: Text('Modo claro')),
                  RadioListTile<ThemeMode>(value: ThemeMode.dark, title: Text('Modo oscuro')),
                ],
              ),
            ),
          ),
          const Divider(),
          const _Apartado('Accesibilidad'),
          const ListTile(
            leading: ExcludeSemantics(child: Icon(Icons.text_fields)),
            title: Text('Tamaño del texto'),
            subtitle: Text(
              'La aplicación usa el tamaño de letra que tengas puesto en los ajustes del móvil, '
              'así que se cambia desde ahí.',
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(Espacio.m),
            child: OutlinedButton.icon(
              style: estiloBotonDestructivo(context),
              onPressed: () => _cerrarSesion(context),
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Apartado extends StatelessWidget {
  const _Apartado(this.titulo);

  final String titulo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(Espacio.m, Espacio.m, Espacio.m, Espacio.s),
      child: Semantics(header: true, child: Text(titulo, style: Theme.of(context).textTheme.titleMedium)),
    );
  }
}
