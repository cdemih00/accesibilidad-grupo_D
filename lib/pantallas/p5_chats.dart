import 'package:flutter/material.dart';

import '../datos/datos_app.dart';
import '../navegacion/rutas.dart';
import '../widgets/barra_opciones.dart';
import '../widgets/barra_superior.dart';
import '../widgets/estado_vacio.dart';

/// P5 · Chats: lista de conversaciones. Se llega desde la barra de opciones,
/// desde Mis reservas y Mis anuncios, o directamente al confirmar una reserva.
class PantallaChats extends StatelessWidget {
  const PantallaChats({super.key});

  @override
  Widget build(BuildContext context) {
    final conversaciones = DatosScope.of(context).conversaciones;

    return Scaffold(
      appBar: barraSuperior(context, 'Chats'),
      bottomNavigationBar: const BarraOpciones(actual: SeccionBarra.chats),
      body: conversaciones.isEmpty
          ? ListView(
              children: const [
                EstadoVacio(
                  icono: Icons.chat_bubble_outline,
                  texto: 'Todavía no tienes conversaciones. Se abren al reservar un material o al preguntar a su dueño.',
                ),
              ],
            )
          : ListView.separated(
              itemCount: conversaciones.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final conversacion = conversaciones[i];
                final ultimo = conversacion.mensajes.isEmpty
                    ? 'Todavía no hay mensajes'
                    : conversacion.mensajes.last.texto;
                return ListTile(
                  leading: ExcludeSemantics(child: CircleAvatar(child: Text(conversacion.con[0]))),
                  title: Text(conversacion.con),
                  subtitle: Text('${conversacion.anuncio.nombre}\n$ultimo', maxLines: 3, overflow: TextOverflow.ellipsis),
                  isThreeLine: true,
                  onTap: () => Navigator.pushNamed(context, Rutas.conversacion, arguments: conversacion),
                );
              },
            ),
    );
  }
}
