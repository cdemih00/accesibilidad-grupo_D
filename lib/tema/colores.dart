import 'package:flutter/material.dart';

/// Paleta de EmprestApp (apartados 4.1 y 4.3 de la memoria), en versión clara
/// y oscura.
///
/// Los contrastes están medidos con la fórmula de WCAG 2.2, no a ojo, y los
/// comprueba `test/contraste_test.dart`. Mínimos del proyecto: 4,5:1 para
/// texto y 3:1 para componentes y estados. Si se cambia un color hay que
/// volver a pasar ese test.
class Paleta {
  const Paleta._({
    required this.nombre,
    required this.brillo,
    required this.fondo,
    required this.tarjeta,
    required this.primario,
    required this.primarioPulsado,
    required this.sobrePrimario,
    required this.primarioSuave,
    required this.sobrePrimarioSuave,
    required this.texto,
    required this.textoSecundario,
    required this.borde,
    required this.separador,
    required this.error,
    required this.sobreError,
    required this.errorSuave,
    required this.sobreErrorSuave,
    required this.exito,
    required this.exitoSuave,
    required this.sobreExitoSuave,
    required this.reservado,
    required this.reservadoSuave,
    required this.sobreReservadoSuave,
    required this.inversa,
    required this.sobreInversa,
    required this.primarioInverso,
  });

  /// La paleta del tema que se está usando en ese momento (clara u oscura).
  static Paleta de(BuildContext context) => Theme.of(context).brightness == Brightness.dark ? oscura : clara;

  final String nombre;
  final Brightness brillo;

  /// Fondo de las pantallas. En el modo claro no es blanco puro (4.3).
  final Color fondo;

  /// Tarjetas, campos de texto, diálogos y barra de opciones.
  final Color tarjeta;

  /// Botones principales ("Reservar", "Publicar material") y selección.
  final Color primario;

  /// Botón principal mientras se pulsa.
  final Color primarioPulsado;

  /// Texto encima del color principal.
  final Color sobrePrimario;

  /// Opción marcada en los filtros y mensajes propios del chat.
  final Color primarioSuave;
  final Color sobrePrimarioSuave;
  final Color texto;
  final Color textoSecundario;

  /// Contorno de campos, chips y tarjetas.
  final Color borde;

  /// Líneas de separación y fondo de las fotos de ejemplo (decorativo).
  final Color separador;

  // Estados. Siempre van con texto e icono además del color (R6, RNF10).
  final Color error;
  final Color sobreError;
  final Color errorSuave;
  final Color sobreErrorSuave;
  final Color exito;
  final Color exitoSuave;
  final Color sobreExitoSuave;
  final Color reservado;
  final Color reservadoSuave;
  final Color sobreReservadoSuave;

  // Mensajes emergentes de abajo (snackbar).
  final Color inversa;
  final Color sobreInversa;
  final Color primarioInverso;

  /// Modo claro: los colores del apartado 4.1, con el fondo de las pantallas
  /// un poco roto en vez de blanco puro (4.3). Tarjetas y campos siguen en
  /// blanco, así destacan un poco sobre el fondo.
  static const clara = Paleta._(
    nombre: 'Modo claro',
    brillo: Brightness.light,
    fondo: Color(0xFFF8FAFC),
    tarjeta: Color(0xFFFFFFFF),
    primario: Color(0xFF1D4ED8),
    primarioPulsado: Color(0xFF1E3A8A),
    sobrePrimario: Color(0xFFFFFFFF),
    primarioSuave: Color(0xFFDBEAFE),
    sobrePrimarioSuave: Color(0xFF1E3A8A),
    texto: Color(0xFF111827),
    textoSecundario: Color(0xFF475569),
    borde: Color(0xFF64748B),
    separador: Color(0xFFE2E8F0),
    error: Color(0xFFB91C1C),
    sobreError: Color(0xFFFFFFFF),
    errorSuave: Color(0xFFFEE2E2),
    sobreErrorSuave: Color(0xFF7F1D1D),
    exito: Color(0xFF166534),
    exitoSuave: Color(0xFFDCFCE7),
    sobreExitoSuave: Color(0xFF14532D),
    reservado: Color(0xFFB45309),
    reservadoSuave: Color(0xFFFEF3C7),
    sobreReservadoSuave: Color(0xFF78350F),
    inversa: Color(0xFF1E293B),
    sobreInversa: Color(0xFFF1F5F9),
    primarioInverso: Color(0xFF93C5FD),
  );

  /// Modo oscuro (4.3): fondo azul muy oscuro en vez de negro puro y versiones
  /// más claras de los colores para que se sigan leyendo bien. Los botones
  /// azules llevan el texto oscuro.
  static const oscura = Paleta._(
    nombre: 'Modo oscuro',
    brillo: Brightness.dark,
    fondo: Color(0xFF0F172A),
    tarjeta: Color(0xFF1E293B),
    primario: Color(0xFF60A5FA),
    primarioPulsado: Color(0xFF93C5FD),
    sobrePrimario: Color(0xFF0F172A),
    primarioSuave: Color(0xFF1E3A8A),
    sobrePrimarioSuave: Color(0xFFDBEAFE),
    texto: Color(0xFFF1F5F9),
    textoSecundario: Color(0xFFCBD5E1),
    borde: Color(0xFF94A3B8),
    separador: Color(0xFF334155),
    error: Color(0xFFF87171),
    sobreError: Color(0xFF0F172A),
    errorSuave: Color(0xFF450A0A),
    sobreErrorSuave: Color(0xFFFECACA),
    exito: Color(0xFF4ADE80),
    exitoSuave: Color(0xFF052E16),
    sobreExitoSuave: Color(0xFFBBF7D0),
    reservado: Color(0xFFFBBF24),
    reservadoSuave: Color(0xFF451A03),
    sobreReservadoSuave: Color(0xFFFDE68A),
    inversa: Color(0xFFF1F5F9),
    sobreInversa: Color(0xFF0F172A),
    primarioInverso: Color(0xFF1D4ED8),
  );

  /// Combinaciones que se usan en la aplicación y el mínimo que deben cumplir.
  /// Es la tabla de contrastes de la memoria (4.2 y 4.3).
  List<ParDeColores> get paresMedidos => [
        ParDeColores('Texto principal sobre el fondo', texto, fondo, 4.5),
        ParDeColores('Texto principal sobre tarjetas y campos', texto, tarjeta, 4.5),
        ParDeColores('Texto secundario sobre el fondo', textoSecundario, fondo, 4.5),
        ParDeColores('Texto secundario sobre tarjetas y campos', textoSecundario, tarjeta, 4.5),
        ParDeColores('Texto del botón principal', sobrePrimario, primario, 4.5),
        ParDeColores('Texto del botón principal pulsado', sobrePrimario, primarioPulsado, 4.5),
        ParDeColores('Botones de texto sobre el fondo', primario, fondo, 4.5),
        ParDeColores('Botones de texto sobre tarjetas', primario, tarjeta, 4.5),
        ParDeColores('Opción marcada y mensajes propios', sobrePrimarioSuave, primarioSuave, 4.5),
        ParDeColores('Mensaje de error sobre el fondo', error, fondo, 4.5),
        ParDeColores('Mensaje de error sobre tarjetas y campos', error, tarjeta, 4.5),
        ParDeColores('Texto del botón de borrar o cancelar', sobreError, error, 4.5),
        ParDeColores('Aviso de error', sobreErrorSuave, errorSuave, 4.5),
        ParDeColores('Mensaje de éxito sobre el fondo', exito, fondo, 4.5),
        ParDeColores('Mensaje de éxito sobre tarjetas', exito, tarjeta, 4.5),
        ParDeColores('Aviso de éxito y estado Disponible', sobreExitoSuave, exitoSuave, 4.5),
        ParDeColores('Estado Reservado', sobreReservadoSuave, reservadoSuave, 4.5),
        ParDeColores('Snackbar: texto', sobreInversa, inversa, 4.5),
        ParDeColores('Snackbar: botón', primarioInverso, inversa, 4.5),
        ParDeColores('Borde de campos, chips y tarjetas sobre el fondo', borde, fondo, 3),
        ParDeColores('Borde de campos y chips sobre tarjetas', borde, tarjeta, 3),
        ParDeColores('Botón principal sobre el fondo', primario, fondo, 3),
        ParDeColores('Indicador de la barra de opciones', primario, tarjeta, 3),
        ParDeColores('Icono de Disponible', exito, exitoSuave, 3),
        ParDeColores('Icono de Reservado', reservado, reservadoSuave, 3),
        ParDeColores('Icono de error en los avisos', error, errorSuave, 3),
        ParDeColores('Icono de las fotos de ejemplo', textoSecundario, separador, 3),
      ];
}

/// Un color de delante (texto o icono) sobre un color de fondo, con el
/// contraste mínimo que tiene que cumplir.
class ParDeColores {
  const ParDeColores(this.nombre, this.delante, this.fondo, this.minimo);

  final String nombre;
  final Color delante;
  final Color fondo;
  final double minimo;

  double get ratio => ratioDeContraste(delante, fondo);
  bool get cumple => ratio >= minimo;
}

/// Ratio de contraste de WCAG 2.2: (L1 + 0,05) / (L2 + 0,05), siendo L1 la
/// luminancia relativa del color más claro y L2 la del más oscuro.
double ratioDeContraste(Color a, Color b) {
  final la = a.computeLuminance();
  final lb = b.computeLuminance();
  final claro = la > lb ? la : lb;
  final oscuro = la > lb ? lb : la;
  return (claro + 0.05) / (oscuro + 0.05);
}
