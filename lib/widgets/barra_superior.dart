import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../tema/tema.dart';

/// Barra de arriba de las pantallas, con su título.
///
/// Flutter deja crecer el título de la barra solo hasta un 134 % y, si no cabe
/// en una línea, lo corta con "…". Con la letra al 200 % se cortaban los
/// títulos largos, como "Detalles del material", y eso es perder contenido
/// (RNF2). Por eso aquí se mide el título antes de dibujar la barra: si no cabe
/// en una línea, baja a la siguiente y la barra crece lo justo para que se lea
/// entero. Con la letra normal la barra queda como siempre.
AppBar barraSuperior(BuildContext context, String titulo, {List<Widget>? acciones}) {
  // El ancho que la barra deja al título: la pantalla menos la flecha de atrás
  // (si la hay) y los márgenes, igual que lo reparte la AppBar. Los botones de
  // la derecha no se descuentan, así que con [acciones] el título tiene que ser
  // corto, como "Inicio".
  final hayFlechaAtras = ModalRoute.of(context)?.impliesAppBarDismissal ?? false;
  final ancho = MediaQuery.sizeOf(context).width -
      MediaQuery.paddingOf(context).horizontal -
      (hayFlechaAtras ? kToolbarHeight : 0) -
      2 * NavigationToolbar.kMiddleSpacing;

  final medida = TextPainter(
    text: TextSpan(text: titulo, style: Theme.of(context).appBarTheme.titleTextStyle),
    // El mismo límite del 134 % que pone Flutter al título.
    textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 1.34),
    textDirection: Directionality.of(context),
    maxLines: 3,
  )..layout(maxWidth: math.max(0, ancho));
  final lineas = math.max(1, medida.computeLineMetrics().length);
  final altoTitulo = medida.height;
  medida.dispose();

  return AppBar(
    toolbarHeight: lineas == 1 ? null : math.max(kToolbarHeight, altoTitulo + 2 * Espacio.s),
    title: Text(titulo, maxLines: lineas, softWrap: lineas > 1),
    actions: acciones,
  );
}
