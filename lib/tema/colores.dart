import 'package:flutter/painting.dart';

/// Paleta de EmprestApp (apartado 4.1 de la memoria). El fondo es blanco en
/// todas las pantallas.
///
/// Los contrastes están medidos con la fórmula de WCAG 2.2 y los comprueba
/// `test/contraste_test.dart`: son los de la tabla del apartado 4.2. Mínimos
/// (RNF1): 4,5:1 para texto normal y 3:1 para texto grande y para bordes y
/// elementos que hacen falta para reconocer un control o su estado. Si se
/// cambia un color hay que volver a pasar ese test.
abstract final class ColoresApp {
  /// Fondo de pantallas, tarjetas y campos, y texto de los botones azules.
  static const fondo = Color(0xFFFFFFFF);

  /// Botones principales como "Reservar" y "Publicar material".
  static const azul = Color(0xFF1D4ED8);

  /// Botón principal mientras se pulsa y texto de los filtros marcados.
  static const azulOscuro = Color(0xFF1E3A8A);

  /// Fondo de los filtros marcados (4.1, estado seleccionado).
  static const azulClaro = Color(0xFFDBEAFE);

  /// Títulos, descripciones y datos importantes (precio, fechas...).
  static const texto = Color(0xFF111827);

  /// Indicaciones, texto de ayuda y estado "Reservado".
  static const textoSecundario = Color(0xFF475569);

  /// Contorno de campos y tarjetas, y controles deshabilitados.
  static const borde = Color(0xFF64748B);

  /// Errores y botones de acciones que borran algo.
  static const error = Color(0xFFB91C1C);

  /// Mensajes de confirmación y estado "Disponible".
  static const exito = Color(0xFF166534);

  /// Gris muy claro solo decorativo: líneas de separación y fondo de las fotos
  /// de ejemplo. No lleva información.
  static const separador = Color(0xFFE2E8F0);

  /// Combinaciones que se usan en la aplicación y el mínimo que deben cumplir.
  /// Las once primeras son la tabla del apartado 4.2.
  static const paresMedidos = <ParDeColores>[
    ParDeColores('Texto principal #111827 sobre blanco', texto, fondo, 4.5),
    ParDeColores('Texto secundario #475569 sobre blanco', textoSecundario, fondo, 4.5),
    ParDeColores('Texto blanco sobre botón azul #1D4ED8', fondo, azul, 4.5),
    ParDeColores('Texto blanco sobre botón pulsado #1E3A8A', fondo, azulOscuro, 4.5),
    ParDeColores('Texto de error #B91C1C sobre blanco', error, fondo, 4.5),
    ParDeColores('Texto de éxito y "Disponible" #166534 sobre blanco', exito, fondo, 4.5),
    ParDeColores('Texto azul y respuestas rápidas #1D4ED8 sobre blanco', azul, fondo, 4.5),
    ParDeColores('Borde de campo #64748B sobre blanco', borde, fondo, 3),
    ParDeColores('Borde de foco #1D4ED8 sobre blanco', azul, fondo, 3),
    ParDeColores('Texto blanco sobre botón rojo #B91C1C', fondo, error, 4.5),
    ParDeColores('Texto del filtro seleccionado #1E3A8A sobre #DBEAFE', azulOscuro, azulClaro, 4.5),
    // A mayores de la tabla:
    ParDeColores('Texto y borde de controles deshabilitados #64748B sobre blanco', borde, fondo, 4.5),
    ParDeColores('Estado "Reservado" #475569 sobre blanco', textoSecundario, fondo, 4.5),
    ParDeColores('Icono de las fotos de ejemplo #475569 sobre #E2E8F0', textoSecundario, separador, 3),
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
