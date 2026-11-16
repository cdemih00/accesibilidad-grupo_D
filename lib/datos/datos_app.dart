import 'package:flutter/widgets.dart';

import 'datos_prueba.dart';
import 'modelos.dart';

/// Estado de la aplicación, en memoria. No hay base de datos ni servidor: al
/// cerrar la aplicación todo vuelve a los datos de prueba. Para probar los tres
/// recorridos críticos y la accesibilidad no hace falta más.
class DatosApp extends ChangeNotifier {
  DatosApp() {
    anuncios.addAll(anunciosDePrueba());
    reservas.addAll(reservasDePrueba(_anuncioPorId));
    conversaciones.addAll(conversacionesDePrueba(_anuncioPorId));
  }

  final List<Anuncio> anuncios = [];
  final List<Reserva> reservas = [];
  final List<Conversacion> conversaciones = [];

  int _contador = 100;
  String nuevoId(String prefijo) => '$prefijo${_contador++}';
  Anuncio _anuncioPorId(String id) => anuncios.firstWhere((a) => a.id == id);

  // ---------------------------------------------------------------------------
  // Sesión (recorrido 1)
  // ---------------------------------------------------------------------------

  /// Código de verificación simulado, el mismo que en el prototipo de la semana 3.
  static const codigoDePrueba = '123456';

  String? correo;
  bool get haySesion => correo != null;
  String get nombre => correo?.split('@').first ?? '';

  /// Solo se puede entrar con el correo de la universidad (RF1).
  static bool esCorreoDeLaUniversidad(String texto) {
    final correo = texto.trim().toLowerCase();
    final partes = correo.split('@');
    if (partes.length != 2 || partes.first.isEmpty || correo.contains(' ')) return false;
    return partes.last == 'unileon.es' || partes.last == 'estudiantes.unileon.es';
  }

  void iniciarSesion(String correo) {
    this.correo = correo.trim().toLowerCase();
    notifyListeners();
  }

  void cerrarSesion() {
    correo = null;
    notifyListeners();
  }

  // Ajustes (P10). Solo se guardan mientras la aplicación está abierta.
  bool avisosDeMensajes = true;
  bool avisosDeDevolucion = true;

  void cambiarAvisos({bool? mensajes, bool? devolucion}) {
    avisosDeMensajes = mensajes ?? avisosDeMensajes;
    avisosDeDevolucion = devolucion ?? avisosDeDevolucion;
    notifyListeners();
  }

  // ---------------------------------------------------------------------------
  // Buscar y reservar (recorrido 2)
  // ---------------------------------------------------------------------------

  List<Anuncio> get catalogo => anuncios.where((a) => !a.esMio).toList();
  List<Anuncio> get recomendados =>
      catalogo.where((a) => a.estado == EstadoMaterial.disponible).take(3).toList();

  /// RF3: buscar por nombre y filtrar por tipo, categoría y disponibilidad.
  List<Anuncio> buscar({
    String texto = '',
    Set<TipoCesion> tipos = const {},
    Categoria? categoria,
    bool soloDisponibles = false,
  }) {
    final buscado = _normalizar(texto);
    return catalogo.where((a) {
      final coincide =
          buscado.isEmpty || _normalizar('${a.nombre} ${a.paraQueSirve} ${a.descripcion}').contains(buscado);
      return coincide &&
          (tipos.isEmpty || tipos.contains(a.tipo)) &&
          (categoria == null || a.categoria == categoria) &&
          (!soloDisponibles || a.estado == EstadoMaterial.disponible);
    }).toList();
  }

  Reserva? reservaDe(Anuncio anuncio) => reservas.where((r) => r.anuncio == anuncio).firstOrNull;

  /// RF5: se llama después de confirmar en la P6. El material pasa a
  /// "Reservado" y se abre el chat con el dueño.
  Reserva reservar(Anuncio anuncio) {
    anuncio.estado = EstadoMaterial.reservado;
    final reserva = Reserva(id: nuevoId('r'), anuncio: anuncio, devolucion: 'Se acuerda por el chat');
    reservas.insert(0, reserva);
    final conversacion = conversacionDe(anuncio);
    conversacion.mensajes
      ..add(Mensaje.aviso('Reserva confirmada: ${anuncio.nombre} (${anuncio.fechas.toLowerCase()}).'))
      ..add(const Mensaje(texto: '¡Hola! Podemos quedar en la biblioteca.', esMio: false));
    _subirArriba(conversacion);
    notifyListeners();
    return reserva;
  }

  /// RF6: cancelar desde Mis reservas (después de confirmarlo).
  void cancelarReserva(Reserva reserva) {
    reservas.remove(reserva);
    reserva.anuncio.estado = EstadoMaterial.disponible;
    conversaciones
        .where((c) => c.anuncio == reserva.anuncio)
        .firstOrNull
        ?.mensajes
        .add(const Mensaje.aviso('Reserva cancelada.'));
    notifyListeners();
  }

  /// Chat sobre un anuncio. Si todavía no existe, se crea vacío.
  Conversacion conversacionDe(Anuncio anuncio) {
    final existente = conversaciones.where((c) => c.anuncio == anuncio).firstOrNull;
    if (existente != null) return existente;
    final nueva = Conversacion(id: nuevoId('c'), con: anuncio.dueno, anuncio: anuncio);
    conversaciones.insert(0, nueva);
    return nueva;
  }

  void enviarMensaje(Conversacion conversacion, String texto) {
    final limpio = texto.trim();
    if (limpio.isEmpty) return;
    conversacion.mensajes.add(Mensaje(texto: limpio, esMio: true));
    _subirArriba(conversacion);
    notifyListeners();
  }

  void _subirArriba(Conversacion conversacion) {
    conversaciones
      ..remove(conversacion)
      ..insert(0, conversacion);
  }

  // ---------------------------------------------------------------------------
  // Publicar (recorrido 3)
  // ---------------------------------------------------------------------------

  List<Anuncio> get misAnuncios => anuncios.where((a) => a.esMio).toList();

  /// RF10: lo que se llevaba escrito si se salió a mitad de publicar.
  BorradorAnuncio? borrador;

  void publicar(Anuncio anuncio) {
    anuncios.insert(0, anuncio);
    borrador = null;
    notifyListeners();
  }

  /// RF12: después de editar un anuncio ya publicado.
  void anuncioEditado() => notifyListeners();

  /// RF12: retirar un anuncio (después de confirmarlo).
  void retirar(Anuncio anuncio) {
    anuncios.remove(anuncio);
    notifyListeners();
  }
}

/// Búsqueda sin tener en cuenta mayúsculas ni tildes ("camara" encuentra "Cámara").
String _normalizar(String texto) {
  const conTilde = 'áéíóúüñ';
  const sinTilde = 'aeiouun';
  var resultado = texto.toLowerCase().trim();
  for (var i = 0; i < conTilde.length; i++) {
    resultado = resultado.replaceAll(conTilde[i], sinTilde[i]);
  }
  return resultado;
}

/// Hace llegar los [DatosApp] a todas las pantallas. Cuando los datos cambian
/// (una reserva, un anuncio nuevo...) se vuelven a dibujar las pantallas que
/// los usan.
class DatosScope extends InheritedNotifier<DatosApp> {
  const DatosScope({super.key, required DatosApp datos, required super.child}) : super(notifier: datos);

  /// En `build` se usa tal cual. En botones y otras funciones, con
  /// `escuchar: false`.
  static DatosApp of(BuildContext context, {bool escuchar = true}) {
    final scope = escuchar
        ? context.dependOnInheritedWidgetOfExactType<DatosScope>()
        : context.getInheritedWidgetOfExactType<DatosScope>();
    assert(scope != null, 'Falta un DatosScope por encima de este widget.');
    return scope!.notifier!;
  }
}
