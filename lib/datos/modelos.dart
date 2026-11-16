import 'package:flutter/material.dart';

/// Tipo de cesión del material (RF3, RF4).
enum TipoCesion {
  prestamo('Préstamo gratuito'),
  alquiler('Alquiler'),
  regalo('Regalo');

  const TipoCesion(this.texto);
  final String texto;
}

/// Estado del material. Siempre se enseña escrito, no solo con color (R6, RNF10).
enum EstadoMaterial {
  disponible('Disponible'),
  reservado('Reservado');

  const EstadoMaterial(this.texto);
  final String texto;
}

enum Categoria {
  libros('Libros y apuntes'),
  fotografia('Fotografía y vídeo'),
  electronica('Electrónica'),
  calculadoras('Calculadoras'),
  otros('Otros');

  const Categoria(this.texto);
  final String texto;
}

/// Foto de un anuncio. No hay imágenes de verdad, se dibuja un icono; lo que
/// cuenta es la descripción, que es lo que lee TalkBack (R7, RF9, RNF9).
class Foto {
  const Foto({required this.descripcion, this.icono = Icons.photo_camera_outlined});

  final String descripcion;
  final IconData icono;
}

/// Anuncio de un material (los de otras personas y los míos).
class Anuncio {
  Anuncio({
    required this.id,
    required this.nombre,
    required this.paraQueSirve,
    required this.descripcion,
    required this.categoria,
    required this.tipo,
    required this.fechas,
    required this.entrega,
    required this.dueno,
    required this.fotos,
    this.precio = 0,
    this.estado = EstadoMaterial.disponible,
    this.esMio = false,
  });

  final String id;
  String nombre;

  /// Frase corta de para qué sirve, para no depender de la jerga técnica (R2).
  String paraQueSirve;
  String descripcion;
  Categoria categoria;
  TipoCesion tipo;

  /// Euros al día. Solo cuenta si es un alquiler.
  double precio;
  String fechas;
  String entrega;
  final String dueno;
  List<Foto> fotos;
  EstadoMaterial estado;
  final bool esMio;

  /// El precio se escribe igual en todas las pantallas (RNF5).
  String get precioTexto => tipo == TipoCesion.alquiler ? '${formatearPrecio(precio)} € al día' : 'Gratis';

  /// Tipo y, si es alquiler, precio: "Alquiler · 3 € al día".
  String get condicionesCortas => tipo == TipoCesion.alquiler ? '${tipo.texto} · $precioTexto' : tipo.texto;
}

/// "3" o "2,50", con coma decimal como se escribe en español.
String formatearPrecio(double precio) =>
    precio == precio.roundToDouble() ? precio.toInt().toString() : precio.toStringAsFixed(2).replaceAll('.', ',');

class Reserva {
  Reserva({required this.id, required this.anuncio, required this.devolucion});

  final String id;
  final Anuncio anuncio;

  /// Cuándo hay que devolverlo, escrito tal cual se enseña ("Antes del viernes
  /// 21 de noviembre"). Son datos de prueba, no fechas reales.
  final String devolucion;
}

class Mensaje {
  const Mensaje({required this.texto, required this.esMio}) : esAviso = false;

  /// Mensaje automático de la aplicación, por ejemplo "Reserva confirmada".
  const Mensaje.aviso(this.texto)
      : esMio = false,
        esAviso = true;

  final String texto;
  final bool esMio;
  final bool esAviso;
}

class Conversacion {
  Conversacion({required this.id, required this.con, required this.anuncio, List<Mensaje>? mensajes})
      : mensajes = mensajes ?? [];

  final String id;

  /// Nombre de la otra persona.
  final String con;
  final Anuncio anuncio;
  final List<Mensaje> mensajes;
}

/// Lo que se lleva escrito de un anuncio sin publicar (RF10).
class BorradorAnuncio {
  BorradorAnuncio({
    required this.paso,
    required this.fotos,
    required this.nombre,
    required this.paraQueSirve,
    required this.descripcion,
    required this.categoria,
    required this.tipo,
    required this.precio,
    required this.fechas,
    required this.entrega,
  });

  /// Para editar un anuncio ya publicado (RF12). Se empieza por la revisión.
  factory BorradorAnuncio.desde(Anuncio anuncio, {required int paso}) => BorradorAnuncio(
        paso: paso,
        fotos: List.of(anuncio.fotos),
        nombre: anuncio.nombre,
        paraQueSirve: anuncio.paraQueSirve,
        descripcion: anuncio.descripcion,
        categoria: anuncio.categoria,
        tipo: anuncio.tipo,
        precio: anuncio.tipo == TipoCesion.alquiler ? formatearPrecio(anuncio.precio) : '',
        fechas: anuncio.fechas,
        entrega: anuncio.entrega,
      );

  final int paso;
  final List<Foto> fotos;
  final String nombre;
  final String paraQueSirve;
  final String descripcion;
  final Categoria? categoria;
  final TipoCesion tipo;
  final String precio;
  final String fechas;
  final String entrega;
}
