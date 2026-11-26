import 'package:flutter/material.dart';

import '../datos/datos_app.dart';
import '../datos/modelos.dart';
import '../navegacion/rutas.dart';
import '../tema/colores.dart';
import '../tema/tema.dart';
import '../widgets/barra_superior.dart';
import '../widgets/campo_texto.dart';
import '../widgets/fila_dato.dart';

/// P5 · Chat con la otra persona (final del recorrido 2, RF7).
///
/// Tiene respuestas ya escritas para escribir menos con una mano (perfil de
/// María): botones blancos con borde y texto azul que envían el mensaje al
/// pulsarlos (4.1). TalkBack lee cada mensaje con quién lo ha escrito
/// ("Laura Gómez: ..."), no solo según el lado y el color de la burbuja.
class PantallaConversacion extends StatefulWidget {
  const PantallaConversacion({super.key, required this.conversacion});

  final Conversacion conversacion;

  @override
  State<PantallaConversacion> createState() => _PantallaConversacionState();
}

class _PantallaConversacionState extends State<PantallaConversacion> {
  static const _respuestasRapidas = ['¿Sigue disponible?', '¿Dónde quedamos?', 'Te lo devuelvo mañana', '¡Gracias!'];

  final _mensaje = TextEditingController();
  final _desplazamiento = ScrollController();
  String? _errorMensaje;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bajarDelTodo(animar: false));
  }

  @override
  void dispose() {
    _mensaje.dispose();
    _desplazamiento.dispose();
    super.dispose();
  }

  void _bajarDelTodo({bool animar = true}) {
    if (!_desplazamiento.hasClients) return;
    final fin = _desplazamiento.position.maxScrollExtent;
    if (animar) {
      _desplazamiento.animateTo(fin, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    } else {
      _desplazamiento.jumpTo(fin);
    }
  }

  void _enviar(String texto) {
    if (texto.trim().isEmpty) {
      setState(() => _errorMensaje = 'Escribe un mensaje antes de enviarlo o elige una respuesta rápida.');
      return;
    }
    DatosScope.of(context, escuchar: false).enviarMensaje(widget.conversacion, texto);
    _mensaje.clear();
    setState(() => _errorMensaje = null);
    WidgetsBinding.instance.addPostFrameCallback((_) => _bajarDelTodo());
  }

  @override
  Widget build(BuildContext context) {
    final datos = DatosScope.of(context);
    final conversacion = widget.conversacion;
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: barraSuperior(context, 'Chat con ${conversacion.con}'),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _desplazamiento,
              padding: const EdgeInsets.all(Espacio.m),
              children: [
                _Cabecera(anuncio: conversacion.anuncio, reserva: datos.reservaDe(conversacion.anuncio)),
                const SizedBox(height: Espacio.m),
                if (conversacion.mensajes.isEmpty)
                  Text(
                    'Todavía no hay mensajes. Puedes empezar con una respuesta rápida.',
                    style: textos.bodyMedium?.copyWith(color: ColoresApp.textoSecundario),
                  ),
                for (final mensaje in conversacion.mensajes) _Burbuja(mensaje: mensaje, otraPersona: conversacion.con),
                const SizedBox(height: Espacio.m),
                Semantics(header: true, container: true, child: Text('Respuestas rápidas', style: textos.titleSmall)),
                const SizedBox(height: Espacio.s),
                Wrap(
                  spacing: Espacio.s,
                  runSpacing: Espacio.s,
                  children: [
                    for (final respuesta in _respuestasRapidas)
                      OutlinedButton(onPressed: () => _enviar(respuesta), child: Text(respuesta)),
                  ],
                ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(Espacio.m, Espacio.s, Espacio.m, Espacio.m),
              decoration: const BoxDecoration(
                color: ColoresApp.fondo,
                border: Border(top: BorderSide(color: ColoresApp.separador)),
              ),
              child: CampoTexto(
                etiqueta: 'Mensaje',
                controlador: _mensaje,
                pista: 'Escribe tu mensaje',
                lineasMinimas: 1,
                lineasMaximas: 4,
                mayusculas: TextCapitalization.sentences,
                error: _errorMensaje,
                alCambiar: (_) {
                  if (_errorMensaje != null) setState(() => _errorMensaje = null);
                },
                alLado: FilledButton.icon(
                  onPressed: () => _enviar(_mensaje.text),
                  icon: const Icon(Icons.send),
                  label: const Text('Enviar'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// De qué material va el chat y, si hay reserva, acceso a Mis reservas (como
/// en el wireframe del chat).
class _Cabecera extends StatelessWidget {
  const _Cabecera({required this.anuncio, required this.reserva});

  final Anuncio anuncio;
  final Reserva? reserva;

  @override
  Widget build(BuildContext context) {
    final hayReserva = reserva != null;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Espacio.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  hayReserva ? Icons.check_circle_outline : Icons.info_outline,
                  color: hayReserva ? ColoresApp.exito : ColoresApp.textoSecundario,
                ),
                const SizedBox(width: Espacio.s),
                Expanded(
                  child: Text(
                    hayReserva ? 'Reserva confirmada' : 'Sobre este material',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: hayReserva ? ColoresApp.exito : ColoresApp.texto,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Espacio.s),
            FilaDato('Material', anuncio.nombre),
            FilaDato('Fechas', anuncio.fechas),
            if (hayReserva) ...[
              const SizedBox(height: Espacio.s),
              OutlinedButton.icon(
                onPressed: () => irA(context, Rutas.misReservas),
                icon: const Icon(Icons.event_outlined),
                label: const Text('Ir a Mis reservas'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _Burbuja extends StatelessWidget {
  const _Burbuja({required this.mensaje, required this.otraPersona});

  final Mensaje mensaje;
  final String otraPersona;

  @override
  Widget build(BuildContext context) {
    if (mensaje.esAviso) {
      return Semantics(
        label: 'Aviso: ${mensaje.texto}',
        excludeSemantics: true,
        child: Padding(
          padding: const EdgeInsets.only(bottom: Espacio.s),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.info_outline, size: 16, color: ColoresApp.textoSecundario),
              const SizedBox(width: Espacio.s),
              Flexible(
                child: Text(
                  mensaje.texto,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: ColoresApp.textoSecundario),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final mio = mensaje.esMio;
    return Semantics(
      label: '${mio ? 'Tú' : otraPersona}: ${mensaje.texto}',
      excludeSemantics: true,
      child: Align(
        alignment: mio ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.8),
          child: Container(
            margin: const EdgeInsets.only(bottom: Espacio.s),
            padding: const EdgeInsets.symmetric(horizontal: Espacio.m, vertical: Espacio.s),
            decoration: BoxDecoration(
              color: mio ? ColoresApp.azulClaro : ColoresApp.fondo,
              border: Border.all(color: mio ? ColoresApp.azulClaro : ColoresApp.borde),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              mensaje.texto,
              style: TextStyle(color: mio ? ColoresApp.azulOscuro : ColoresApp.texto),
            ),
          ),
        ),
      ),
    );
  }
}
