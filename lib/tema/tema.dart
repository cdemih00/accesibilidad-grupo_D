import 'package:flutter/material.dart';

import 'colores.dart';

/// Espaciados comunes, múltiplos de 4. Entre dos controles nunca se deja
/// menos de [s] (8 dp, RNF3).
abstract final class Espacio {
  static const xs = 4.0;
  static const s = 8.0;
  static const m = 16.0;
  static const l = 24.0;
  static const xl = 32.0;
}

/// Tamaño mínimo de cualquier control táctil: 48 × 48 dp (criterio de la
/// asignatura y recomendación de Flutter, RNF3).
const tamanoMinimoToque = Size(48, 48);

/// Botones de acciones que no se pueden deshacer (cancelar una reserva,
/// retirar un anuncio, quitar una foto, cerrar sesión). Van en rojo y con
/// icono y texto, y siempre piden confirmación antes (R8, RF6, RF12).
ButtonStyle estiloBotonDestructivo(BuildContext context) {
  final error = Theme.of(context).colorScheme.error;
  return OutlinedButton.styleFrom(foregroundColor: error, side: BorderSide(color: error, width: 1.5));
}

/// Tema de la aplicación (sistema visual de los apartados 4.1 y 4.3), en modo
/// claro y en modo oscuro.
///
/// Lo importante para la accesibilidad:
/// - Ningún control mide menos de 48 × 48 dp.
/// - El texto de lectura no baja de 14 sp (RNF2) y crece con el tamaño de
///   letra del móvil: no se bloquea el escalado en ningún sitio.
/// - Las etiquetas de los campos se ven siempre, no solo el placeholder (RNF4).
/// - Errores, selección y estados llevan texto o icono además de color (RNF10).
abstract final class TemaApp {
  static final ThemeData _claro = _crear(Paleta.clara);
  static final ThemeData _oscuro = _crear(Paleta.oscura);

  static ThemeData claro() => _claro;
  static ThemeData oscuro() => _oscuro;

  static ThemeData _crear(Paleta p) {
    final esquema = ColorScheme(
      brightness: p.brillo,
      primary: p.primario,
      onPrimary: p.sobrePrimario,
      primaryContainer: p.primarioSuave,
      onPrimaryContainer: p.sobrePrimarioSuave,
      secondary: p.primario,
      onSecondary: p.sobrePrimario,
      secondaryContainer: p.primarioSuave,
      onSecondaryContainer: p.sobrePrimarioSuave,
      tertiary: p.exito,
      onTertiary: p.sobrePrimario,
      tertiaryContainer: p.exitoSuave,
      onTertiaryContainer: p.sobreExitoSuave,
      error: p.error,
      onError: p.sobreError,
      errorContainer: p.errorSuave,
      onErrorContainer: p.sobreErrorSuave,
      surface: p.fondo,
      onSurface: p.texto,
      onSurfaceVariant: p.textoSecundario,
      surfaceContainerLowest: p.tarjeta,
      surfaceContainerLow: p.tarjeta,
      surfaceContainer: p.tarjeta,
      surfaceContainerHigh: p.tarjeta,
      surfaceContainerHighest: p.tarjeta,
      outline: p.borde,
      outlineVariant: p.separador,
      inverseSurface: p.inversa,
      onInverseSurface: p.sobreInversa,
      inversePrimary: p.primarioInverso,
      surfaceTint: Colors.transparent,
    );

    final textos = _textos(ThemeData(colorScheme: esquema).textTheme, p);
    final redondeado = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    OutlineInputBorder bordeCampo(Color color, double grosor) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: grosor),
        );

    return ThemeData(
      colorScheme: esquema,
      textTheme: textos,
      scaffoldBackgroundColor: p.fondo,
      // Los controles pequeños (chips, casillas...) ocupan igualmente 48 × 48.
      materialTapTargetSize: MaterialTapTargetSize.padded,
      visualDensity: VisualDensity.standard,
      appBarTheme: AppBarThemeData(
        backgroundColor: p.fondo,
        foregroundColor: p.texto,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textos.titleLarge,
        shape: Border(bottom: BorderSide(color: p.separador)),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(horizontal: Espacio.l, vertical: 12),
          textStyle: textos.labelLarge,
          shape: redondeado,
        ).copyWith(
          // El "azul oscuro" del 4.1: el botón cambia de tono mientras se pulsa.
          backgroundColor: WidgetStateProperty.resolveWith((estados) {
            if (estados.contains(WidgetState.disabled)) return null;
            return estados.contains(WidgetState.pressed) ? p.primarioPulsado : p.primario;
          }),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(64, 48),
          padding: const EdgeInsets.symmetric(horizontal: Espacio.l, vertical: 12),
          textStyle: textos.labelLarge,
          shape: redondeado,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: tamanoMinimoToque,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          // Subrayados: en la revisión en escala de grises (4.3) los botones
          // de texto como "Ver mis reservas" solo se distinguían del resto del
          // texto por el azul.
          textStyle: textos.labelLarge?.copyWith(decoration: TextDecoration.underline),
          shape: redondeado,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(minimumSize: tamanoMinimoToque),
      ),
      inputDecorationTheme: InputDecorationThemeData(
        // La etiqueta se queda siempre visible encima del campo (RNF4).
        floatingLabelBehavior: FloatingLabelBehavior.always,
        filled: true,
        fillColor: p.tarjeta,
        border: bordeCampo(p.borde, 1),
        enabledBorder: bordeCampo(p.borde, 1),
        focusedBorder: bordeCampo(p.primario, 2.5),
        errorBorder: bordeCampo(p.error, 2),
        focusedErrorBorder: bordeCampo(p.error, 2.5),
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        floatingLabelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        hintStyle: textos.bodyLarge?.copyWith(color: p.textoSecundario),
        helperStyle: textos.bodySmall?.copyWith(color: p.textoSecundario),
        errorStyle: textos.bodySmall?.copyWith(color: p.error, fontWeight: FontWeight.w600),
        helperMaxLines: 3,
        errorMaxLines: 4,
        contentPadding: const EdgeInsets.symmetric(horizontal: Espacio.m, vertical: Espacio.m),
      ),
      cardTheme: CardThemeData(
        color: p.tarjeta,
        elevation: 0,
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: p.borde),
        ),
      ),
      chipTheme: ChipThemeData(
        labelStyle: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: WidgetStateColor.resolveWith(
            (estados) => estados.contains(WidgetState.selected) ? p.sobrePrimarioSuave : p.texto,
          ),
        ),
        side: BorderSide(color: p.borde),
        selectedColor: p.primarioSuave,
        checkmarkColor: p.sobrePrimarioSuave,
        // Marcado = fondo azul + marca de verificación, no solo el color.
        showCheckmark: true,
        padding: const EdgeInsets.all(Espacio.s),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: p.tarjeta,
        titleTextStyle: textos.titleLarge,
        contentTextStyle: textos.bodyLarge,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.tarjeta,
        indicatorColor: p.primario,
        // El texto se ve siempre debajo de cada icono (R3).
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        iconTheme: WidgetStateProperty.resolveWith(
          (estados) => IconThemeData(
            size: 24,
            color: estados.contains(WidgetState.selected) ? p.sobrePrimario : p.textoSecundario,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (estados) => TextStyle(
            fontSize: 14,
            color: p.texto,
            fontWeight: estados.contains(WidgetState.selected) ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.inversa,
        contentTextStyle: textos.bodyLarge?.copyWith(color: p.sobreInversa),
        actionTextColor: p.primarioInverso,
        closeIconColor: p.sobreInversa,
        showCloseIcon: true,
        shape: redondeado,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: p.textoSecundario,
        titleTextStyle: textos.titleSmall,
        subtitleTextStyle: textos.bodyMedium?.copyWith(color: p.textoSecundario),
        minVerticalPadding: 12,
        contentPadding: const EdgeInsets.symmetric(horizontal: Espacio.m),
      ),
      switchTheme: SwitchThemeData(
        // Marca dentro del interruptor para que activado/desactivado no sea
        // solo una cuestión de color.
        thumbIcon: WidgetStateProperty.resolveWith(
          (estados) => Icon(estados.contains(WidgetState.selected) ? Icons.check : Icons.close),
        ),
      ),
      expansionTileTheme: ExpansionTileThemeData(
        shape: const Border(),
        collapsedShape: const Border(),
        iconColor: p.primario,
        collapsedIconColor: p.texto,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: p.primario,
        linearTrackColor: p.separador,
        linearMinHeight: 6,
      ),
      dividerTheme: DividerThemeData(color: p.separador, thickness: 1, space: Espacio.l),
    );
  }

  /// Tamaños de letra. Nada de lo que hay que leer baja de 14 sp (RNF2) y el
  /// texto corrido tiene interlineado de 1,5. Los tamaños van escritos aunque
  /// coincidan con los de Material, porque estos estilos se copian también en
  /// la barra de arriba y en los diálogos y ahí no se rellenan solos.
  static TextTheme _textos(TextTheme base, Paleta p) {
    return base
        .copyWith(
          headlineLarge: base.headlineLarge?.copyWith(fontSize: 32, fontWeight: FontWeight.w700),
          headlineSmall: base.headlineSmall?.copyWith(fontSize: 24, fontWeight: FontWeight.w700),
          titleLarge: base.titleLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
          titleMedium: base.titleMedium?.copyWith(fontSize: 18, fontWeight: FontWeight.w600),
          titleSmall: base.titleSmall?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
          bodyLarge: base.bodyLarge?.copyWith(fontSize: 17, height: 1.5),
          bodyMedium: base.bodyMedium?.copyWith(fontSize: 16, height: 1.5),
          bodySmall: base.bodySmall?.copyWith(fontSize: 14, height: 1.45),
          labelLarge: base.labelLarge?.copyWith(fontSize: 16, fontWeight: FontWeight.w600),
          labelMedium: base.labelMedium?.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
          labelSmall: base.labelSmall?.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
        )
        .apply(bodyColor: p.texto, displayColor: p.texto);
  }
}
