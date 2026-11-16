import 'package:flutter/material.dart';

import '../datos/datos_app.dart';
import '../datos/modelos.dart';
import '../tema/tema.dart';
import '../widgets/barra_opciones.dart';
import '../widgets/campo_texto.dart';
import '../widgets/estado_vacio.dart';
import '../widgets/tarjeta_anuncio.dart';

/// P3 · Buscar material: catálogo con buscador y filtros (recorrido 2, RF3).
///
/// Cada resultado enseña el nombre, una frase de para qué sirve (R2), el tipo
/// y el estado escrito con su icono (R6). El número de resultados se anuncia
/// con TalkBack cada vez que cambia. Los filtros y lo escrito se conservan al
/// volver de una ficha (4.1).
class PantallaBuscarMaterial extends StatefulWidget {
  const PantallaBuscarMaterial({super.key});

  @override
  State<PantallaBuscarMaterial> createState() => _PantallaBuscarMaterialState();
}

class _PantallaBuscarMaterialState extends State<PantallaBuscarMaterial> {
  final _busqueda = TextEditingController();
  final _tipos = <TipoCesion>{};
  Categoria? _categoria;
  bool _soloDisponibles = false;

  int get _filtrosActivos => _tipos.length + (_categoria == null ? 0 : 1) + (_soloDisponibles ? 1 : 0);

  void _quitarFiltros() {
    setState(() {
      _tipos.clear();
      _categoria = null;
      _soloDisponibles = false;
      _busqueda.clear();
    });
  }

  /// Los resultados ya se actualizan al escribir; "Buscar" además cierra el
  /// teclado para que se vea la lista entera.
  void _buscar() {
    FocusScope.of(context).unfocus();
    setState(() {});
  }

  @override
  void dispose() {
    _busqueda.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textos = Theme.of(context).textTheme;
    final resultados = DatosScope.of(context).buscar(
      texto: _busqueda.text,
      tipos: _tipos,
      categoria: _categoria,
      soloDisponibles: _soloDisponibles,
    );
    final cuantos = resultados.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Buscar material')),
      bottomNavigationBar: const BarraOpciones(actual: SeccionBarra.buscar),
      body: ListView(
        padding: const EdgeInsets.all(Espacio.m),
        children: [
          CampoTexto(
            etiqueta: '¿Qué buscas?',
            controlador: _busqueda,
            pista: 'Calculadora, cámara, libro...',
            accionTeclado: TextInputAction.search,
            alCambiar: (_) => setState(() {}),
            alEnviar: (_) => _buscar(),
            alLado: FilledButton.icon(onPressed: _buscar, icon: const Icon(Icons.search), label: const Text('Buscar')),
          ),
          const SizedBox(height: Espacio.m),
          Card(
            child: ExpansionTile(
              title: const Text('Filtros'),
              // La etiqueta explica para qué sirve el control (4.4).
              subtitle: Text(
                'Por tipo, categoría y disponibilidad. '
                '${_filtrosActivos == 0 ? 'Ninguno activo' : 'Activos: $_filtrosActivos'}',
              ),
              childrenPadding: const EdgeInsets.fromLTRB(Espacio.m, 0, Espacio.m, Espacio.m),
              expandedCrossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _TituloFiltro('Tipo'),
                Wrap(
                  spacing: Espacio.s,
                  runSpacing: Espacio.s,
                  children: [
                    for (final tipo in TipoCesion.values)
                      FilterChip(
                        label: Text(tipo.texto),
                        selected: _tipos.contains(tipo),
                        onSelected: (marcado) => setState(() {
                          if (marcado) {
                            _tipos.add(tipo);
                          } else {
                            _tipos.remove(tipo);
                          }
                        }),
                      ),
                  ],
                ),
                const _TituloFiltro('Categoría'),
                Wrap(
                  spacing: Espacio.s,
                  runSpacing: Espacio.s,
                  children: [
                    for (final categoria in Categoria.values)
                      ChoiceChip(
                        label: Text(categoria.texto),
                        selected: _categoria == categoria,
                        onSelected: (marcado) => setState(() => _categoria = marcado ? categoria : null),
                      ),
                  ],
                ),
                const _TituloFiltro('Disponibilidad'),
                FilterChip(
                  label: const Text('Solo los disponibles'),
                  selected: _soloDisponibles,
                  onSelected: (marcado) => setState(() => _soloDisponibles = marcado),
                ),
                if (_filtrosActivos > 0) ...[
                  const SizedBox(height: Espacio.m),
                  OutlinedButton.icon(
                    onPressed: _quitarFiltros,
                    icon: const Icon(Icons.filter_alt_off),
                    label: const Text('Quitar filtros'),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: Espacio.l),
          Semantics(
            liveRegion: true,
            child: Text(
              switch (cuantos) {
                0 => 'No hay materiales con esa búsqueda',
                1 => '1 material encontrado',
                _ => '$cuantos materiales encontrados',
              },
              style: textos.titleSmall,
            ),
          ),
          const SizedBox(height: Espacio.s),
          if (cuantos == 0)
            EstadoVacio(
              icono: Icons.search_off,
              texto: 'Prueba con otra palabra o quita algún filtro.',
              textoBoton: 'Quitar filtros',
              iconoBoton: Icons.filter_alt_off,
              alPulsar: _quitarFiltros,
            )
          else
            for (final anuncio in resultados)
              Padding(
                padding: const EdgeInsets.only(bottom: Espacio.m),
                child: TarjetaAnuncio(anuncio: anuncio),
              ),
        ],
      ),
    );
  }
}

class _TituloFiltro extends StatelessWidget {
  const _TituloFiltro(this.texto);

  final String texto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Espacio.m, bottom: Espacio.s),
      child: Semantics(header: true, child: Text(texto, style: Theme.of(context).textTheme.titleSmall)),
    );
  }
}
