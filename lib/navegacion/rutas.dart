import 'package:flutter/material.dart';

import '../datos/modelos.dart';
import '../pantallas/p10_ajustes.dart';
import '../pantallas/p1_acceso.dart';
import '../pantallas/p1_crear_cuenta.dart';
import '../pantallas/p1_iniciar_sesion.dart';
import '../pantallas/p2_menu_principal.dart';
import '../pantallas/p3_buscar_material.dart';
import '../pantallas/p4_detalle_material.dart';
import '../pantallas/p5_chats.dart';
import '../pantallas/p5_conversacion.dart';
import '../pantallas/p7_publicar_material.dart';
import '../pantallas/p8_mis_reservas.dart';
import '../pantallas/p9_mis_anuncios.dart';

/// Rutas de la aplicación. Cada una es una pantalla del inventario de la
/// semana 3 (apartado 3.1) y siguen el mapa de navegación (3.2). La P6 no
/// tiene ruta porque es un diálogo que se abre encima de la P4.
abstract final class Rutas {
  static const acceso = '/acceso'; // P1 · bienvenida
  static const crearCuenta = '/acceso/crear-cuenta'; // P1 · registro
  static const iniciarSesion = '/acceso/iniciar-sesion'; // P1 · entrar
  static const menu = '/menu'; // P2 · Menú principal
  static const buscar = '/buscar'; // P3 · Buscar material
  static const detalle = '/detalle'; // P4 · Detalles del material (recibe el Anuncio)
  static const chats = '/chats'; // P5 · lista de chats
  static const conversacion = '/chats/conversacion'; // P5 · un chat (recibe la Conversacion)
  static const publicar = '/publicar'; // P7 · Publicar material (o editar, si recibe un Anuncio)
  static const misReservas = '/mis-reservas'; // P8 · Mis reservas
  static const misAnuncios = '/mis-anuncios'; // P9 · Mis anuncios
  static const ajustes = '/ajustes'; // P10 · Ajustes

  static Route<void>? generar(RouteSettings ajustes) {
    final Widget? pantalla = switch (ajustes.name) {
      Rutas.acceso => const PantallaAcceso(),
      Rutas.crearCuenta => const PantallaCrearCuenta(),
      Rutas.iniciarSesion => const PantallaIniciarSesion(),
      Rutas.menu => const PantallaMenuPrincipal(),
      Rutas.buscar => const PantallaBuscarMaterial(),
      Rutas.detalle => PantallaDetalleMaterial(anuncio: ajustes.arguments! as Anuncio),
      Rutas.chats => const PantallaChats(),
      Rutas.conversacion => PantallaConversacion(conversacion: ajustes.arguments! as Conversacion),
      Rutas.publicar => PantallaPublicarMaterial(anuncioAEditar: ajustes.arguments as Anuncio?),
      Rutas.misReservas => const PantallaMisReservas(),
      Rutas.misAnuncios => const PantallaMisAnuncios(),
      Rutas.ajustes => const PantallaAjustes(),
      _ => null,
    };
    if (pantalla == null) return null;
    return MaterialPageRoute<void>(settings: ajustes, builder: (_) => pantalla);
  }
}

/// Va a una pantalla dejando debajo solo el menú principal. Así "atrás" desde
/// cualquier sección vuelve siempre al menú (↩ P2 del mapa de navegación).
void irA(BuildContext context, String ruta, {Object? argumentos}) {
  final navegador = Navigator.of(context);
  navegador.popUntil(ModalRoute.withName(Rutas.menu));
  if (ruta != Rutas.menu) navegador.pushNamed(ruta, arguments: argumentos);
}
