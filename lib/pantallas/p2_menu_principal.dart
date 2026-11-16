import 'package:flutter/material.dart';

import '../datos/datos_app.dart';
import '../datos/modelos.dart';
import '../navegacion/rutas.dart';
import '../tema/tema.dart';
import '../widgets/barra_opciones.dart';
import '../widgets/etiqueta_estado.dart';
import '../widgets/fila_dato.dart';
import '../widgets/tarjeta_anuncio.dart';
import '../widgets/titulo_seccion.dart';

/// P2 · Menú principal. Es el centro del mapa de navegación: resumen de mis
/// reservas y mis anuncios, recomendaciones y acceso a todas las pantallas.
class PantallaMenuPrincipal extends StatelessWidget {
  const PantallaMenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    final datos = DatosScope.of(context);
    final textos = Theme.of(context).textTheme;
    final reservas = datos.reservas;
    final misAnuncios = datos.misAnuncios;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: [
          // Ajustes (P10) con icono y texto, no solo con el engranaje (R3).
          OutlinedButton.icon(
            onPressed: () => Navigator.pushNamed(context, Rutas.ajustes),
            icon: const Icon(Icons.settings_outlined),
            label: const Text('Ajustes'),
          ),
          const SizedBox(width: Espacio.m),
        ],
      ),
      bottomNavigationBar: const BarraOpciones(actual: SeccionBarra.inicio),
      body: ListView(
        padding: const EdgeInsets.all(Espacio.m),
        children: [
          Text('Hola, ${datos.nombre}', style: textos.titleMedium),
          const SizedBox(height: Espacio.m),
          // Barra de búsqueda arriba (walkthrough 3.6). Es un botón que abre la P3.
          OutlinedButton.icon(
            onPressed: () => irA(context, Rutas.buscar),
            style: OutlinedButton.styleFrom(
              alignment: AlignmentDirectional.centerStart,
              minimumSize: const Size.fromHeight(56),
              padding: const EdgeInsets.symmetric(horizontal: Espacio.m, vertical: Espacio.s),
            ),
            icon: const Icon(Icons.search),
            label: const Text('Buscar material'),
          ),
          const SizedBox(height: Espacio.l),
          TituloSeccion(
            titulo: 'Mis reservas',
            textoBoton: 'Ver mis reservas',
            alPulsar: () => Navigator.pushNamed(context, Rutas.misReservas),
          ),
          if (reservas.isEmpty)
            const Text('No tienes ninguna reserva.')
          else
            for (final reserva in reservas.take(2)) _ResumenReserva(reserva: reserva),
          const SizedBox(height: Espacio.l),
          TituloSeccion(
            titulo: 'Mis anuncios',
            textoBoton: 'Ver mis anuncios',
            alPulsar: () => Navigator.pushNamed(context, Rutas.misAnuncios),
          ),
          if (misAnuncios.isEmpty)
            const Text('Todavía no has publicado nada.')
          else
            for (final anuncio in misAnuncios.take(2)) _ResumenMiAnuncio(anuncio: anuncio),
          const SizedBox(height: Espacio.l),
          const TituloSeccion(titulo: 'Te puede interesar'),
          for (final anuncio in datos.recomendados)
            Padding(
              padding: const EdgeInsets.only(bottom: Espacio.m),
              child: TarjetaAnuncio(anuncio: anuncio),
            ),
        ],
      ),
    );
  }
}

/// Resumen de una reserva con la fecha de devolución a la vista (consigna 2 de
/// la prueba de primer clic). Al pulsarlo se abre Mis reservas (P8).
class _ResumenReserva extends StatelessWidget {
  const _ResumenReserva({required this.reserva});

  final Reserva reserva;

  @override
  Widget build(BuildContext context) {
    return _TarjetaResumen(
      icono: Icons.event_outlined,
      pista: 'ver mis reservas',
      alPulsar: () => Navigator.pushNamed(context, Rutas.misReservas),
      hijos: [
        Text(reserva.anuncio.nombre, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: Espacio.s),
        FilaDato('Devolución', reserva.devolucion),
      ],
    );
  }
}

/// Resumen de un anuncio mío con su estado. Al pulsarlo se abre Mis anuncios (P9).
class _ResumenMiAnuncio extends StatelessWidget {
  const _ResumenMiAnuncio({required this.anuncio});

  final Anuncio anuncio;

  @override
  Widget build(BuildContext context) {
    return _TarjetaResumen(
      icono: Icons.sell_outlined,
      pista: 'ver mis anuncios',
      alPulsar: () => Navigator.pushNamed(context, Rutas.misAnuncios),
      hijos: [
        Text(anuncio.nombre, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: Espacio.s),
        EtiquetaEstado(estado: anuncio.estado),
      ],
    );
  }
}

class _TarjetaResumen extends StatelessWidget {
  const _TarjetaResumen({required this.icono, required this.pista, required this.alPulsar, required this.hijos});

  final IconData icono;
  final String pista;
  final VoidCallback alPulsar;
  final List<Widget> hijos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Espacio.s),
      child: Card(
        child: MergeSemantics(
          child: Semantics(
            button: true,
            onTapHint: pista,
            child: InkWell(
              onTap: alPulsar,
              child: Padding(
                padding: const EdgeInsets.all(Espacio.m),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExcludeSemantics(child: Icon(icono)),
                    const SizedBox(width: Espacio.m),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: hijos),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
