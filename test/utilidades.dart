import 'package:emprestapp/datos/datos_app.dart';
import 'package:emprestapp/pantallas/p10_ajustes.dart';
import 'package:emprestapp/pantallas/p1_acceso.dart';
import 'package:emprestapp/pantallas/p1_crear_cuenta.dart';
import 'package:emprestapp/pantallas/p1_iniciar_sesion.dart';
import 'package:emprestapp/pantallas/p2_menu_principal.dart';
import 'package:emprestapp/pantallas/p3_buscar_material.dart';
import 'package:emprestapp/pantallas/p4_detalle_material.dart';
import 'package:emprestapp/pantallas/p5_chats.dart';
import 'package:emprestapp/pantallas/p5_conversacion.dart';
import 'package:emprestapp/pantallas/p7_publicar_material.dart';
import 'package:emprestapp/pantallas/p8_mis_reservas.dart';
import 'package:emprestapp/pantallas/p9_mis_anuncios.dart';
import 'package:emprestapp/tema/tema.dart';
import 'package:emprestapp/widgets/barra_opciones.dart';
import 'package:emprestapp/widgets/campo_texto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

/// Pone la pantalla del test del tamaño de un móvil normal (360 dp de ancho).
void usarPantallaDeMovil(WidgetTester tester, {double alto = 780}) {
  tester.view.physicalSize = Size(360 * 3, alto * 3);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
}

DatosApp datosConSesion() => DatosApp()..iniciarSesion('prueba@estudiantes.unileon.es');

/// Monta una pantalla suelta con el tema y el idioma de la aplicación.
/// [escalaTexto] simula el tamaño de letra del móvil (2 = 200 %).
Widget appDePrueba(DatosApp datos, Widget pantalla, {double escalaTexto = 1}) {
  return DatosScope(
    datos: datos,
    child: MaterialApp(
      theme: TemaApp.claro(),
      locale: const Locale('es', 'ES'),
      supportedLocales: const [Locale('es', 'ES')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      builder: (context, hijo) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(escalaTexto)),
        child: hijo!,
      ),
      home: pantalla,
    ),
  );
}

/// El botón (principal, secundario o de borrar) que tiene ese texto.
Finder boton(String texto) => find.ancestor(of: find.text(texto), matching: find.bySubtype<ButtonStyleButton>());

/// El botón con ese texto dentro del diálogo abierto.
Finder botonDelDialogo(String texto) => find.descendant(of: find.byType(AlertDialog), matching: boton(texto));

/// El campo de texto que tiene esa etiqueta encima.
Finder campo(String etiqueta) =>
    find.descendant(of: find.widgetWithText(CampoTexto, etiqueta), matching: find.byType(TextField));

/// Una opción de la barra de abajo.
Finder opcionDeLaBarra(String texto) => find.descendant(of: find.byType(BarraOpciones), matching: find.text(texto));

/// Todas las pantallas del inventario (la P6 es un diálogo y se prueba aparte).
final pantallasDeLaApp = <String, Widget Function(DatosApp datos)>{
  'P1 · Bienvenida': (_) => const PantallaAcceso(),
  'P1 · Crear cuenta': (_) => const PantallaCrearCuenta(),
  'P1 · Iniciar sesión': (_) => const PantallaIniciarSesion(),
  'P2 · Menú principal': (_) => const PantallaMenuPrincipal(),
  'P3 · Buscar material': (_) => const PantallaBuscarMaterial(),
  'P4 · Detalles del material': (datos) => PantallaDetalleMaterial(anuncio: datos.catalogo.first),
  'P5 · Chats': (_) => const PantallaChats(),
  'P5 · Conversación': (datos) => PantallaConversacion(conversacion: datos.conversaciones.first),
  'P7 · Publicar material': (_) => const PantallaPublicarMaterial(),
  'P8 · Mis reservas': (_) => const PantallaMisReservas(),
  'P9 · Mis anuncios': (_) => const PantallaMisAnuncios(),
  'P10 · Ajustes': (_) => const PantallaAjustes(),
};
