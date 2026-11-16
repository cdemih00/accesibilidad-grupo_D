import 'package:flutter/material.dart';

import '../datos/datos_app.dart';
import '../datos/modelos.dart';
import '../navegacion/rutas.dart';
import '../tema/colores.dart';
import '../tema/tema.dart';
import '../widgets/fila_dato.dart';

/// P5 · Chat con la otra persona (final del recorrido 2, RF7).
///
/// Tiene respuestas ya escritas para escribir menos con una mano (perfil de
/// María). TalkBack lee cada mensaje con quién lo ha escrito ("Laura Gómez:
/// ..."), no solo según el lado y el color de la burbuja.
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
    if (texto.trim().isEmpty) return;
    DatosScope.of(context, escuchar: false).enviarMensaje(widget.conversacion, texto);
    _mensaje.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bajarDelTodo());
  }

  @override
  Widget build(BuildContext context) {
    final datos = DatosScope.of(context);
    final conversacion = widget.conversacion;
    final textos = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text('Chat con ${conversacion.con}')),
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
                    style: textos.bodyMedium?.copyWith(color: Paleta.de(context).textoSecundario),
                  ),
                for (final mensaje in conversacion.mensajes) _Burbuja(mensaje: mensaje, otraPersona: conversacion.con),
                const SizedBox(height: Espacio.m),
                Semantics(header: true, child: Text('Respuestas rápidas', style: textos.titleSmall)),
                const SizedBox(height: Espacio.s),
                Wrap(
                  spacing: Espacio.s,
                  runSpacing: Espacio.s,
                  children: [
                    for (final respuesta in _respuestasRapidas)
                      ActionChip(label: Text(respuesta), onPressed: () => _enviar(respuesta)),
                  ],
                ),
              ],
            ),
          ),
          _CampoMensaje(controlador: _mensaje, alEnviar: () => _enviar(_mensaje.text)),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  hayReserva ? Icons.check_circle : Icons.info_outline,
                  color: hayReserva ? Paleta.de(context).exito : Paleta.de(context).textoSecundario,
                ),
                const SizedBox(width: Espacio.s),
                Expanded(
                  child: Text(
                    hayReserva ? 'Reserva confirmada' : 'Sobre este material',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Espacio.xs),
            FilaDato('Material', anuncio.nombre),
            FilaDato('Fechas', anuncio.fechas),
            if (hayReserva) ...[
              const SizedBox(height: Espacio.xs),
              TextButton(
                onPressed: () => irA(context, Rutas.misReservas),
                child: const Text('Ir a Mis reservas'),
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
              Icon(Icons.info_outline, size: 18, color: Paleta.de(context).textoSecundario),
              const SizedBox(width: Espacio.xs),
              Flexible(
                child: Text(
                  mensaje.texto,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Paleta.de(context).textoSecundario),
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
            padding: const EdgeInsets.symmetric(horizontal: Espacio.m, vertical: 10),
            decoration: BoxDecoration(
              color: mio ? Paleta.de(context).primarioSuave : Paleta.de(context).tarjeta,
              border: Border.all(color: mio ? Paleta.de(context).primarioSuave : Paleta.de(context).separador),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              mensaje.texto,
              style: TextStyle(color: mio ? Paleta.de(context).sobrePrimarioSuave : Paleta.de(context).texto),
            ),
          ),
        ),
      ),
    );
  }
}

class _CampoMensaje extends StatelessWidget {
  const _CampoMensaje({required this.controlador, required this.alEnviar});

  final TextEditingController controlador;
  final VoidCallback alEnviar;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Paleta.de(context).fondo,
          border: Border(top: BorderSide(color: Paleta.de(context).separador)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: controlador,
                minLines: 1,
                maxLines: 4,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Mensaje', hintText: 'Escribe tu mensaje'),
              ),
            ),
            const SizedBox(width: Espacio.s),
            // "Enviar" con texto (R3). Desactivado mientras no hay nada escrito.
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: controlador,
              builder: (context, valor, _) => FilledButton(
                onPressed: valor.text.trim().isEmpty ? null : alEnviar,
                child: const Text('Enviar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
