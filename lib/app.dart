import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'datos/datos_app.dart';
import 'navegacion/rutas.dart';
import 'tema/tema.dart';

/// Raíz de la aplicación: tema accesible, textos en español y rutas P1–P10.
class EmprestApp extends StatefulWidget {
  const EmprestApp({super.key, this.datos});

  /// Datos simulados. Los tests pasan unos nuevos para empezar siempre igual.
  final DatosApp? datos;

  @override
  State<EmprestApp> createState() => _EmprestAppState();
}

class _EmprestAppState extends State<EmprestApp> {
  late final DatosApp _datos = widget.datos ?? DatosApp();

  @override
  void dispose() {
    if (widget.datos == null) _datos.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DatosScope(
      datos: _datos,
      child: MaterialApp(
        title: 'EmprestApp',
        debugShowCheckedModeBanner: false,
        theme: TemaApp.claro(),
        // En español, para que TalkBack lea "Atrás", "Cerrar"... en los
        // botones estándar de Flutter.
        locale: const Locale('es', 'ES'),
        supportedLocales: const [Locale('es', 'ES')],
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        // "¿Hay sesión guardada?" del mapa de navegación: sin sesión se empieza
        // en la P1 y con sesión directamente en el menú (P2).
        onGenerateInitialRoutes: (_) => [
          Rutas.generar(RouteSettings(name: _datos.haySesion ? Rutas.menu : Rutas.acceso))!,
        ],
        onGenerateRoute: Rutas.generar,
      ),
    );
  }
}
