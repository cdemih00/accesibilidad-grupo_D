import 'package:flutter/material.dart';

import 'colores.dart';

/// Espaciados del apartado 4.1, siempre múltiplos de 8 dp (RNF3).
abstract final class Espacio {
  /// Separación entre elementos interactivos.
  static const s = 8.0;

  /// Márgenes laterales y relleno interno de las tarjetas.
  static const m = 16.0;

  /// Separación entre bloques de contenido.
  static const l = 24.0;
  static const xl = 32.0;
}

/// Tamaño mínimo de cualquier control táctil: 48 × 48 dp (RNF3).
const tamanoMinimoToque = Size(48, 48);

/// Botón de borrar (4.1): rojo con texto blanco, solo para acciones que borran
/// algo ("Cancelar reserva", "Retirar anuncio", "Borrar foto"), que siempre
/// piden confirmación antes (R8, RF6, RF12).
ButtonStyle estiloBotonDestructivo(BuildContext context) => FilledButton.styleFrom(
      backgroundColor: ColoresApp.error,
      foregroundColor: ColoresApp.fondo,
    );

/// Tema de la aplicación: el sistema visual mínimo del apartado 4.1.
///
/// - Tipografía Lexend, que no confunde letras como I y l.
/// - Texto de lectura y de los campos a 16 sp; etiquetas, ayudas, mensajes y
///   barra de abajo a 14 sp (RNF2). Crece con la letra del móvil: no se
///   bloquea el escalado en ningún sitio.
/// - Títulos en negrita: 28 sp (nombre de la aplicación), 24 sp (título de
///   cada pantalla) y 20 sp (secciones y nombre del material en su ficha).
/// - Ningún control mide menos de 48 × 48 dp.
/// - Tres tipos de botón: principal (azul), secundario (blanco con borde y
///   texto azul) y de borrar (rojo, ver [estiloBotonDestructivo]).
abstract final class TemaApp {
  static final ThemeData _claro = _crear();

  static ThemeData claro() => _claro;

  static ThemeData _crear() {
    const esquema = ColorScheme(
      brightness: Brightness.light,
      primary: ColoresApp.azul,
      onPrimary: ColoresApp.fondo,
      primaryContainer: ColoresApp.azulClaro,
      onPrimaryContainer: ColoresApp.azulOscuro,
      secondary: ColoresApp.azul,
      onSecondary: ColoresApp.fondo,
      secondaryContainer: ColoresApp.azulClaro,
      onSecondaryContainer: ColoresApp.azulOscuro,
      tertiary: ColoresApp.exito,
      onTertiary: ColoresApp.fondo,
      error: ColoresApp.error,
      onError: ColoresApp.fondo,
      surface: ColoresApp.fondo,
      onSurface: ColoresApp.texto,
      onSurfaceVariant: ColoresApp.textoSecundario,
      surfaceContainerLowest: ColoresApp.fondo,
      surfaceContainerLow: ColoresApp.fondo,
      surfaceContainer: ColoresApp.fondo,
      surfaceContainerHigh: ColoresApp.fondo,
      surfaceContainerHighest: ColoresApp.fondo,
      outline: ColoresApp.borde,
      outlineVariant: ColoresApp.separador,
      inverseSurface: ColoresApp.texto,
      onInverseSurface: ColoresApp.fondo,
      inversePrimary: ColoresApp.azulClaro,
      surfaceTint: Colors.transparent,
    );

    final textos = _textos(ThemeData(colorScheme: esquema, fontFamily: 'Lexend').textTheme);
    final redondeado = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    OutlineInputBorder bordeCampo(Color color, double grosor) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: grosor),
        );
    bool deshabilitado(Set<WidgetState> estados) => estados.contains(WidgetState.disabled);

    return ThemeData(
      colorScheme: esquema,
      fontFamily: 'Lexend',
      textTheme: textos,
      scaffoldBackgroundColor: ColoresApp.fondo,
      // Los controles pequeños (chips, casillas...) ocupan igualmente 48 × 48.
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarThemeData(
        backgroundColor: ColoresApp.fondo,
        foregroundColor: ColoresApp.texto,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textos.titleLarge,
        shape: const Border(bottom: BorderSide(color: ColoresApp.separador)),
      ),
      // Principal: azul con texto blanco (azul oscuro mientras se pulsa).
      // Deshabilitado: fondo blanco con texto y borde gris (4.1).
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(horizontal: Espacio.l, vertical: Espacio.s),
          textStyle: textos.labelLarge,
          shape: redondeado,
        ).copyWith(
          backgroundColor: WidgetStateProperty.resolveWith((estados) {
            if (deshabilitado(estados)) return ColoresApp.fondo;
            return estados.contains(WidgetState.pressed) ? ColoresApp.azulOscuro : ColoresApp.azul;
          }),
          foregroundColor: WidgetStateProperty.resolveWith(
            (estados) => deshabilitado(estados) ? ColoresApp.borde : ColoresApp.fondo,
          ),
          side: WidgetStateProperty.resolveWith(
            (estados) => deshabilitado(estados) ? const BorderSide(color: ColoresApp.borde) : BorderSide.none,
          ),
        ),
      ),
      // Secundario: blanco con borde y texto azul, para cancelar o volver.
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(horizontal: Espacio.l, vertical: Espacio.s),
          textStyle: textos.labelLarge,
          shape: redondeado,
          backgroundColor: ColoresApp.fondo,
        ).copyWith(
          foregroundColor: WidgetStateProperty.resolveWith(
            (estados) => deshabilitado(estados) ? ColoresApp.borde : ColoresApp.azul,
          ),
          side: WidgetStateProperty.resolveWith(
            (estados) => deshabilitado(estados)
                ? const BorderSide(color: ColoresApp.borde)
                : const BorderSide(color: ColoresApp.azul, width: 1.5),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(minimumSize: tamanoMinimoToque, textStyle: textos.labelLarge),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: tamanoMinimoToque),
      ),
      // Campos (4.1): fondo blanco, 48 dp de alto como mínimo, 12 dp de relleno
      // horizontal, borde de 1 dp gris; 2 dp azul al enfocarlos y 2 dp rojo si
      // hay un error. La etiqueta va fuera, encima (ver CampoTexto).
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: ColoresApp.fondo,
        constraints: const BoxConstraints(minHeight: 48),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: bordeCampo(ColoresApp.borde, 1),
        enabledBorder: bordeCampo(ColoresApp.borde, 1),
        focusedBorder: bordeCampo(ColoresApp.azul, 2),
        errorBorder: bordeCampo(ColoresApp.error, 2),
        focusedErrorBorder: bordeCampo(ColoresApp.error, 2),
        hintStyle: textos.bodyLarge?.copyWith(color: ColoresApp.textoSecundario),
        helperStyle: textos.bodySmall?.copyWith(color: ColoresApp.textoSecundario),
        errorStyle: textos.bodySmall?.copyWith(color: ColoresApp.error),
        helperMaxLines: 3,
        errorMaxLines: 4,
      ),
      // Tarjetas de material: fondo blanco y borde gris.
      cardTheme: CardThemeData(
        color: ColoresApp.fondo,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: ColoresApp.borde),
        ),
      ),
      // Filtro marcado: fondo azul claro, texto azul oscuro y marca ✓ (4.1).
      chipTheme: ChipThemeData(
        backgroundColor: ColoresApp.fondo,
        selectedColor: ColoresApp.azulClaro,
        checkmarkColor: ColoresApp.azulOscuro,
        showCheckmark: true,
        labelStyle: TextStyle(
          fontFamily: 'Lexend',
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: WidgetStateColor.resolveWith(
            (estados) => estados.contains(WidgetState.selected) ? ColoresApp.azulOscuro : ColoresApp.texto,
          ),
        ),
        side: WidgetStateBorderSide.resolveWith(
          (estados) => estados.contains(WidgetState.selected)
              ? const BorderSide(color: ColoresApp.azul, width: 1.5)
              : const BorderSide(color: ColoresApp.borde),
        ),
        padding: const EdgeInsets.symmetric(horizontal: Espacio.s, vertical: Espacio.s),
        shape: const StadiumBorder(),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: ColoresApp.fondo,
        titleTextStyle: textos.titleMedium,
        contentTextStyle: textos.bodyLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      // Confirmaciones (estado de éxito, 4.1): en negrita, verde y a 14 sp,
      // sobre blanco. El icono ✓ lo pone mostrarMensaje().
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ColoresApp.fondo,
        elevation: 6,
        contentTextStyle: textos.labelMedium?.copyWith(color: ColoresApp.exito, fontWeight: FontWeight.w700),
        actionTextColor: ColoresApp.azul,
        closeIconColor: ColoresApp.texto,
        showCloseIcon: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: ColoresApp.exito, width: 1.5),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: ColoresApp.textoSecundario,
        titleTextStyle: textos.titleSmall,
        subtitleTextStyle: textos.bodyMedium?.copyWith(color: ColoresApp.textoSecundario),
        minVerticalPadding: Espacio.s,
        contentPadding: const EdgeInsets.symmetric(horizontal: Espacio.m),
      ),
      switchTheme: SwitchThemeData(
        // Marca dentro del interruptor para que activado/desactivado no sea
        // solo una cuestión de color.
        thumbIcon: WidgetStateProperty.resolveWith(
          (estados) => Icon(estados.contains(WidgetState.selected) ? Icons.check : Icons.close),
        ),
      ),
      expansionTileTheme: const ExpansionTileThemeData(
        shape: Border(),
        collapsedShape: Border(),
        iconColor: ColoresApp.azul,
        collapsedIconColor: ColoresApp.texto,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: ColoresApp.azul,
        linearTrackColor: ColoresApp.separador,
        linearMinHeight: 8,
      ),
      dividerTheme: const DividerThemeData(color: ColoresApp.separador, thickness: 1, space: Espacio.l),
    );
  }

  /// Tamaños de letra del apartado 4.1. Van escritos aunque coincidan con los
  /// de Material, porque estos estilos se copian también en la barra de arriba
  /// y en los diálogos y ahí no se rellenan solos.
  static TextTheme _textos(TextTheme base) {
    return base
        .copyWith(
          // 28 sp: nombre de la aplicación en la pantalla de acceso.
          headlineLarge: base.headlineLarge?.copyWith(fontSize: 28, fontWeight: FontWeight.w700),
          headlineSmall: base.headlineSmall?.copyWith(fontSize: 24, fontWeight: FontWeight.w700),
          // 24 sp: título de cada pantalla.
          titleLarge: base.titleLarge?.copyWith(fontSize: 24, fontWeight: FontWeight.w700),
          // 20 sp: títulos de sección, del material en su ficha y de los diálogos.
          titleMedium: base.titleMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.w700),
          // 16 sp en negrita: nombres en las tarjetas y encabezados pequeños.
          titleSmall: base.titleSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w700),
          // 16 sp: texto de lectura y el que se escribe en los campos.
          bodyLarge: base.bodyLarge?.copyWith(fontSize: 16, height: 1.5),
          bodyMedium: base.bodyMedium?.copyWith(fontSize: 16, height: 1.5),
          // 14 sp: ayudas, mensajes de error y de éxito.
          bodySmall: base.bodySmall?.copyWith(fontSize: 14, height: 1.4),
          // 16 sp: texto de los botones.
          labelLarge: base.labelLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
          // 14 sp: etiquetas de los campos y opciones de la barra de abajo.
          labelMedium: base.labelMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
          labelSmall: base.labelSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
        )
        .apply(bodyColor: ColoresApp.texto, displayColor: ColoresApp.texto);
  }
}
