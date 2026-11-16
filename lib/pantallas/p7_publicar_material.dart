import 'package:flutter/material.dart';

import '../datos/datos_app.dart';
import '../datos/modelos.dart';
import '../navegacion/rutas.dart';
import '../tema/colores.dart';
import '../tema/tema.dart';
import '../widgets/aviso.dart';
import '../widgets/barra_opciones.dart';
import '../widgets/dialogo_confirmar.dart';
import '../widgets/fila_dato.dart';
import '../widgets/foto_material.dart';
import '../widgets/titulo_seccion.dart';

/// P7 · Publicar material (recorrido 3).
///
/// - El anuncio se rellena en tres pasos con "Anterior" y "Siguiente" y se ve
///   en qué paso vas (RF8).
/// - Cada foto necesita una frase que la describa y se ordena o se quita con
///   botones, sin arrastrar (RF9, R7, R8).
/// - Si se sale a mitad, se guarda un borrador y al volver se pregunta si se
///   quiere seguir (RF10).
/// - Antes de publicar se revisa todo, con "Editar" en cada parte (RF11).
///
/// Si recibe un anuncio, sirve para editarlo desde Mis anuncios (RF12).
class PantallaPublicarMaterial extends StatefulWidget {
  const PantallaPublicarMaterial({super.key, this.anuncioAEditar});

  final Anuncio? anuncioAEditar;

  @override
  State<PantallaPublicarMaterial> createState() => _PantallaPublicarMaterialState();
}

/// Foto que se está añadiendo, con su campo de descripción.
class _FotoNueva {
  _FotoNueva(this.icono, [String descripcion = '']) : descripcion = TextEditingController(text: descripcion);

  final IconData icono;
  final TextEditingController descripcion;
  final foco = FocusNode();

  void dispose() {
    descripcion.dispose();
    foco.dispose();
  }
}

class _PantallaPublicarMaterialState extends State<PantallaPublicarMaterial> {
  static const _pasos = ['Fotos', 'Descripción', 'Condiciones'];
  static const _revision = 3;

  late DatosApp _datos;
  int _paso = 0;

  /// Se ha entrado en un paso desde "Editar" en la revisión: al terminarlo se
  /// vuelve directamente a la revisión.
  bool _desdeRevision = false;
  bool _terminado = false;

  final _fotos = <_FotoNueva>[];
  final _nombre = TextEditingController();
  final _paraQueSirve = TextEditingController();
  final _descripcion = TextEditingController();
  final _precio = TextEditingController();
  final _fechas = TextEditingController();
  final _entrega = TextEditingController();
  Categoria? _categoria;
  TipoCesion _tipo = TipoCesion.prestamo;

  final _formDescripcion = GlobalKey<FormState>();
  final _formCondiciones = GlobalKey<FormState>();
  String? _errorFotos;
  bool _marcarFotosSinDescribir = false;
  String? _errorCategoria;

  bool get _editando => widget.anuncioAEditar != null;
  List<TextEditingController> get _campos => [_nombre, _paraQueSirve, _descripcion, _precio, _fechas, _entrega];

  @override
  void initState() {
    super.initState();
    final anuncio = widget.anuncioAEditar;
    if (anuncio != null) {
      _cargar(BorradorAnuncio.desde(anuncio, paso: _revision));
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) => _ofrecerBorrador());
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _datos = DatosScope.of(context, escuchar: false);
  }

  @override
  void dispose() {
    // RF10: si se sale a mitad (atrás, barra de opciones...) se guarda lo escrito.
    if (!_editando && !_terminado && _hayAlgoEscrito) _datos.borrador = _comoBorrador();
    for (final foto in _fotos) {
      foto.dispose();
    }
    for (final campo in _campos) {
      campo.dispose();
    }
    super.dispose();
  }

  // ---------------------------------------------------------------------------
  // Borrador (RF10)
  // ---------------------------------------------------------------------------

  bool get _hayAlgoEscrito =>
      _fotos.isNotEmpty || _categoria != null || _campos.any((campo) => campo.text.trim().isNotEmpty);

  BorradorAnuncio _comoBorrador() => BorradorAnuncio(
        paso: _paso,
        fotos: [for (final foto in _fotos) Foto(descripcion: foto.descripcion.text, icono: foto.icono)],
        nombre: _nombre.text,
        paraQueSirve: _paraQueSirve.text,
        descripcion: _descripcion.text,
        categoria: _categoria,
        tipo: _tipo,
        precio: _precio.text,
        fechas: _fechas.text,
        entrega: _entrega.text,
      );

  void _cargar(BorradorAnuncio borrador) {
    _paso = borrador.paso;
    _fotos.addAll([for (final foto in borrador.fotos) _FotoNueva(foto.icono, foto.descripcion)]);
    _nombre.text = borrador.nombre;
    _paraQueSirve.text = borrador.paraQueSirve;
    _descripcion.text = borrador.descripcion;
    _categoria = borrador.categoria;
    _tipo = borrador.tipo;
    _precio.text = borrador.precio;
    _fechas.text = borrador.fechas;
    _entrega.text = borrador.entrega;
  }

  Future<void> _ofrecerBorrador() async {
    final borrador = _datos.borrador;
    if (borrador == null || !mounted) return;
    final seguir = await confirmarAccion(
      context,
      titulo: 'Tienes un anuncio a medias',
      mensaje: 'La última vez saliste sin terminar de publicarlo. ¿Quieres seguir donde lo dejaste?',
      textoConfirmar: 'Seguir con el anuncio',
      textoCancelar: 'Empezar de nuevo',
      destructiva: false,
      cerrarTocandoFuera: false,
    );
    if (!mounted) return;
    _datos.borrador = null;
    if (seguir) setState(() => _cargar(borrador));
  }

  // ---------------------------------------------------------------------------
  // Pasos
  // ---------------------------------------------------------------------------

  /// Comprueba el paso actual y enseña qué falta. Devuelve si está bien.
  bool _validarPaso() {
    switch (_paso) {
      case 0:
        final sinDescribir = _fotos.indexWhere((foto) => foto.descripcion.text.trim().isEmpty);
        setState(() {
          _marcarFotosSinDescribir = true;
          _errorFotos = _fotos.isEmpty
              ? 'Falta añadir al menos una foto del material.'
              : sinDescribir >= 0
                  ? 'Falta describir la foto ${sinDescribir + 1}. Escribe una frase que diga qué se ve en ella.'
                  : null;
        });
        return _errorFotos == null;
      case 1:
        final camposBien = _formDescripcion.currentState?.validate() ?? false;
        setState(() {
          _errorCategoria = _categoria == null ? 'Elige una categoría para que lo encuentren en el buscador.' : null;
        });
        return camposBien && _categoria != null;
      case 2:
        return _formCondiciones.currentState?.validate() ?? false;
      default:
        return true;
    }
  }

  void _siguiente() {
    if (!_validarPaso()) return;
    setState(() {
      _paso = _desdeRevision ? _revision : _paso + 1;
      if (_paso == _revision) _desdeRevision = false;
    });
  }

  /// "Anterior" y el botón de atrás del móvil retroceden un paso (o vuelven a
  /// la revisión si se había entrado desde "Editar").
  void _atras() {
    setState(() {
      if (_desdeRevision) {
        _paso = _revision;
        _desdeRevision = false;
      } else if (_paso > 0) {
        _paso--;
      }
    });
  }

  bool get _atrasSaleDeLaPantalla => _editando ? (_paso == _revision && !_desdeRevision) : _paso == 0;

  void _editarPaso(int paso) {
    setState(() {
      _paso = paso;
      _desdeRevision = true;
    });
  }

  int? _primerPasoIncompleto() {
    if (_fotos.isEmpty || _fotos.any((foto) => foto.descripcion.text.trim().isEmpty)) return 0;
    if ([_nombre, _paraQueSirve, _descripcion].any((campo) => campo.text.trim().isEmpty) || _categoria == null) {
      return 1;
    }
    if ([_fechas, _entrega].any((campo) => campo.text.trim().isEmpty) ||
        (_tipo == TipoCesion.alquiler && _leerPrecio() == null)) {
      return 2;
    }
    return null;
  }

  double? _leerPrecio() {
    final precio = double.tryParse(_precio.text.trim().replaceAll(',', '.'));
    return (precio == null || precio <= 0) ? null : precio;
  }

  void _publicar() {
    final incompleto = _primerPasoIncompleto();
    if (incompleto != null) {
      // Se lleva a la persona al paso que falta y se le enseña el error.
      setState(() {
        _paso = incompleto;
        _desdeRevision = true;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _validarPaso();
      });
      return;
    }

    final fotos = [for (final foto in _fotos) Foto(descripcion: foto.descripcion.text.trim(), icono: foto.icono)];
    final precio = _tipo == TipoCesion.alquiler ? _leerPrecio()! : 0.0;
    _terminado = true;

    final editado = widget.anuncioAEditar;
    if (editado != null) {
      editado
        ..fotos = fotos
        ..nombre = _nombre.text.trim()
        ..paraQueSirve = _paraQueSirve.text.trim()
        ..descripcion = _descripcion.text.trim()
        ..categoria = _categoria!
        ..tipo = _tipo
        ..precio = precio
        ..fechas = _fechas.text.trim()
        ..entrega = _entrega.text.trim();
      _datos.anuncioEditado();
      mostrarMensaje(context, 'Cambios guardados.');
      Navigator.pop(context);
      return;
    }

    _datos.publicar(Anuncio(
      id: _datos.nuevoId('m'),
      nombre: _nombre.text.trim(),
      paraQueSirve: _paraQueSirve.text.trim(),
      descripcion: _descripcion.text.trim(),
      categoria: _categoria!,
      tipo: _tipo,
      precio: precio,
      fechas: _fechas.text.trim(),
      entrega: _entrega.text.trim(),
      dueno: 'Tú',
      esMio: true,
      fotos: fotos,
    ));
    mostrarMensaje(context, 'Anuncio publicado. Lo tienes en Mis anuncios.');
    // Mapa de navegación: al publicar se va a Mis anuncios (P9).
    irA(context, Rutas.misAnuncios);
  }

  // ---------------------------------------------------------------------------
  // Fotos (RF9). En esta versión no se abre la cámara: se añade una de ejemplo.
  // ---------------------------------------------------------------------------

  void _anadirFoto(IconData icono) {
    final foto = _FotoNueva(icono);
    setState(() {
      _fotos.add(foto);
      _errorFotos = null;
    });
    // El foco va a la descripción de la foto nueva, que es lo siguiente que hay que hacer.
    WidgetsBinding.instance.addPostFrameCallback((_) => foto.foco.requestFocus());
  }

  void _moverFoto(int indice, int hacia) {
    setState(() {
      final foto = _fotos.removeAt(indice);
      _fotos.insert(indice + hacia, foto);
    });
  }

  Future<void> _quitarFoto(int indice) async {
    final quitar = await confirmarAccion(
      context,
      titulo: '¿Quitar la foto ${indice + 1}?',
      mensaje: 'Se quitará la foto y su descripción del anuncio.',
      textoConfirmar: 'Quitar foto',
      textoCancelar: 'No, dejarla',
    );
    if (!quitar || !mounted) return;
    final foto = _fotos[indice];
    setState(() => _fotos.removeAt(indice));
    WidgetsBinding.instance.addPostFrameCallback((_) => foto.dispose());
  }

  // ---------------------------------------------------------------------------
  // Interfaz
  // ---------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _atrasSaleDeLaPantalla,
      onPopInvokedWithResult: (salio, _) {
        if (!salio) _atras();
      },
      child: Scaffold(
        appBar: AppBar(title: Text(_editando ? 'Editar anuncio' : 'Publicar material')),
        bottomNavigationBar: _editando ? null : const BarraOpciones(actual: SeccionBarra.publicar),
        body: Column(
          children: [
            _Progreso(paso: _paso, pasos: _pasos, editando: _editando),
            Expanded(
              child: ListView(
                // Una lista nueva por paso para empezar arriba del todo.
                key: ValueKey(_paso),
                padding: const EdgeInsets.all(Espacio.m),
                children: switch (_paso) {
                  0 => _pasoFotos(),
                  1 => _pasoDescripcion(),
                  2 => _pasoCondiciones(),
                  _ => _pasoRevision(),
                },
              ),
            ),
            _botones(),
          ],
        ),
      ),
    );
  }

  Widget _botones() {
    final revisando = _paso == _revision;
    final textoPrincipal = revisando
        ? (_editando ? 'Guardar cambios' : 'Publicar material')
        : _desdeRevision
            ? 'Volver a revisar'
            : _paso == _pasos.length - 1
                ? 'Revisar anuncio'
                : 'Siguiente';
    final conAnterior = _paso > 0 && !_desdeRevision && !(_editando && revisando);

    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(Espacio.m),
        decoration: BoxDecoration(
          color: Paleta.de(context).fondo,
          border: Border(top: BorderSide(color: Paleta.de(context).separador)),
        ),
        child: Row(
          children: [
            if (conAnterior) ...[
              Expanded(child: OutlinedButton(onPressed: _atras, child: const Text('Anterior'))),
              const SizedBox(width: Espacio.m),
            ],
            Expanded(
              flex: 2,
              child: FilledButton(onPressed: revisando ? _publicar : _siguiente, child: Text(textoPrincipal)),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _pasoFotos() {
    final textos = Theme.of(context).textTheme;
    return [
      Text(
        'Añade al menos una foto y escribe qué se ve en ella. Esa frase es la que oye con el lector de '
        'pantalla una persona que no puede ver la foto.',
        style: textos.bodyMedium,
      ),
      const SizedBox(height: Espacio.m),
      if (_errorFotos != null) ...[Aviso.error(_errorFotos!), const SizedBox(height: Espacio.m)],
      for (final (indice, foto) in _fotos.indexed) ...[
        KeyedSubtree(key: ObjectKey(foto), child: _tarjetaFoto(indice, foto)),
        const SizedBox(height: Espacio.m),
      ],
      Wrap(
        spacing: Espacio.s,
        runSpacing: Espacio.s,
        children: [
          OutlinedButton.icon(
            onPressed: () => _anadirFoto(Icons.photo_camera_outlined),
            icon: const Icon(Icons.photo_camera_outlined),
            label: const Text('Hacer foto'),
          ),
          OutlinedButton.icon(
            onPressed: () => _anadirFoto(Icons.photo_library_outlined),
            icon: const Icon(Icons.photo_library_outlined),
            label: const Text('Elegir de la galería'),
          ),
        ],
      ),
      const SizedBox(height: Espacio.s),
      Text(
        'Versión de prueba: no se abre la cámara, se añade una foto de ejemplo.',
        style: textos.bodySmall?.copyWith(color: Paleta.de(context).textoSecundario),
      ),
    ];
  }

  Widget _tarjetaFoto(int indice, _FotoNueva foto) {
    final numero = indice + 1;
    final sinDescribir = _marcarFotosSinDescribir && foto.descripcion.text.trim().isEmpty;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Espacio.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(header: true, child: Text('Foto $numero', style: Theme.of(context).textTheme.titleSmall)),
            const SizedBox(height: Espacio.s),
            MarcoFoto(icono: foto.icono, alto: 120),
            const SizedBox(height: Espacio.m),
            TextField(
              controller: foto.descripcion,
              focusNode: foto.foco,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              onChanged: (_) {
                if (_errorFotos != null || sinDescribir) setState(() => _errorFotos = null);
              },
              decoration: InputDecoration(
                labelText: 'Qué se ve en la foto $numero',
                hintText: 'Por ejemplo: calculadora gris con la tapa puesta',
                errorText: sinDescribir ? 'Escribe una frase que describa esta foto.' : null,
              ),
            ),
            const SizedBox(height: Espacio.m),
            // Ordenar y quitar con botones, nunca arrastrando (R8).
            Wrap(
              spacing: Espacio.s,
              runSpacing: Espacio.s,
              children: [
                OutlinedButton.icon(
                  onPressed: indice == 0 ? null : () => _moverFoto(indice, -1),
                  icon: const Icon(Icons.arrow_upward),
                  label: Text('Subir', semanticsLabel: 'Subir la foto $numero'),
                ),
                OutlinedButton.icon(
                  onPressed: indice == _fotos.length - 1 ? null : () => _moverFoto(indice, 1),
                  icon: const Icon(Icons.arrow_downward),
                  label: Text('Bajar', semanticsLabel: 'Bajar la foto $numero'),
                ),
                OutlinedButton.icon(
                  style: estiloBotonDestructivo(context),
                  onPressed: () => _quitarFoto(indice),
                  icon: const Icon(Icons.delete_outline),
                  label: Text('Quitar', semanticsLabel: 'Quitar la foto $numero'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  FormFieldValidator<String> _obligatorio(String mensaje) =>
      (valor) => (valor == null || valor.trim().isEmpty) ? mensaje : null;

  List<Widget> _pasoDescripcion() {
    return [
      Form(
        key: _formDescripcion,
        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _nombre,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Nombre del material',
                hintText: 'Por ejemplo: calculadora científica Casio',
              ),
              validator: _obligatorio('Escribe el nombre del material.'),
            ),
            const SizedBox(height: Espacio.l),
            TextFormField(
              controller: _paraQueSirve,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Para qué sirve (una frase)',
                hintText: 'Por ejemplo: para los exámenes de Matemáticas',
                helperText: 'Ayuda a quien no conoce el nombre técnico del material.',
              ),
              validator: _obligatorio('Escribe en una frase para qué sirve.'),
            ),
            const SizedBox(height: Espacio.l),
            TextFormField(
              controller: _descripcion,
              minLines: 3,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                hintText: 'Estado, accesorios que incluye, modelo...',
                alignLabelWithHint: true,
              ),
              validator: _obligatorio('Escribe una descripción del material.'),
            ),
            const SizedBox(height: Espacio.l),
            Semantics(header: true, child: Text('Categoría', style: Theme.of(context).textTheme.titleSmall)),
            const SizedBox(height: Espacio.s),
            Wrap(
              spacing: Espacio.s,
              runSpacing: Espacio.s,
              children: [
                for (final categoria in Categoria.values)
                  ChoiceChip(
                    label: Text(categoria.texto),
                    selected: _categoria == categoria,
                    onSelected: (_) => setState(() {
                      _categoria = categoria;
                      _errorCategoria = null;
                    }),
                  ),
              ],
            ),
            if (_errorCategoria != null) ...[const SizedBox(height: Espacio.m), Aviso.error(_errorCategoria!)],
          ],
        ),
      ),
    ];
  }

  List<Widget> _pasoCondiciones() {
    return [
      Form(
        key: _formCondiciones,
        autovalidateMode: AutovalidateMode.onUserInteractionIfError,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Semantics(header: true, child: Text('Tipo de cesión', style: Theme.of(context).textTheme.titleSmall)),
            const SizedBox(height: Espacio.s),
            Wrap(
              spacing: Espacio.s,
              runSpacing: Espacio.s,
              children: [
                for (final tipo in TipoCesion.values)
                  ChoiceChip(
                    label: Text(tipo.texto),
                    selected: _tipo == tipo,
                    onSelected: (_) => setState(() => _tipo = tipo),
                  ),
              ],
            ),
            if (_tipo == TipoCesion.alquiler) ...[
              const SizedBox(height: Espacio.l),
              TextFormField(
                controller: _precio,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Precio por día',
                  hintText: 'Por ejemplo: 3',
                  suffixText: '€ al día',
                ),
                validator: (_) => _leerPrecio() == null ? 'Escribe el precio con números, por ejemplo 3 o 2,50.' : null,
              ),
            ],
            const SizedBox(height: Espacio.l),
            TextFormField(
              controller: _fechas,
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Cuándo se puede prestar',
                hintText: 'Por ejemplo: de lunes a viernes por la tarde',
              ),
              validator: _obligatorio('Escribe cuándo se puede prestar o recoger.'),
            ),
            const SizedBox(height: Espacio.l),
            TextFormField(
              controller: _entrega,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                labelText: 'Dónde se entrega',
                hintText: 'Por ejemplo: biblioteca del campus',
              ),
              validator: _obligatorio('Escribe dónde se entrega el material.'),
            ),
          ],
        ),
      ),
    ];
  }

  List<Widget> _pasoRevision() {
    final precio = _leerPrecio();
    return [
      Text(
        _editando
            ? 'Revisa los cambios. Si algo no está bien, pulsa "Editar" en esa parte.'
            : 'Así se va a ver tu anuncio. Si algo no está bien, pulsa "Editar" en esa parte.',
      ),
      const SizedBox(height: Espacio.l),
      _ApartadoRevision(
        titulo: 'Fotos',
        alEditar: () => _editarPaso(0),
        hijos: [
          for (final (indice, foto) in _fotos.indexed) FilaDato('Foto ${indice + 1}', foto.descripcion.text),
        ],
      ),
      _ApartadoRevision(
        titulo: 'Descripción',
        alEditar: () => _editarPaso(1),
        hijos: [
          FilaDato('Nombre', _nombre.text),
          FilaDato('Para qué sirve', _paraQueSirve.text),
          FilaDato('Categoría', _categoria?.texto ?? 'Sin elegir'),
          FilaDato('Descripción', _descripcion.text),
        ],
      ),
      _ApartadoRevision(
        titulo: 'Condiciones',
        alEditar: () => _editarPaso(2),
        hijos: [
          FilaDato('Tipo', _tipo.texto),
          if (_tipo == TipoCesion.alquiler)
            FilaDato('Precio', precio == null ? 'Sin precio' : '${formatearPrecio(precio)} € al día'),
          FilaDato('Fechas', _fechas.text),
          FilaDato('Entrega', _entrega.text),
        ],
      ),
    ];
  }
}

/// "Paso 2 de 3: Descripción" con una barra de progreso. El texto se anuncia
/// al cambiar de paso para que con TalkBack se sepa dónde se está.
class _Progreso extends StatelessWidget {
  const _Progreso({required this.paso, required this.pasos, required this.editando});

  final int paso;
  final List<String> pasos;
  final bool editando;

  @override
  Widget build(BuildContext context) {
    final revisando = paso >= pasos.length;
    final texto = revisando
        ? (editando ? 'Revisar los cambios' : 'Revisar el anuncio antes de publicar')
        : 'Paso ${paso + 1} de ${pasos.length}: ${pasos[paso]}';

    return Container(
      color: Paleta.de(context).tarjeta,
      padding: const EdgeInsets.fromLTRB(Espacio.m, Espacio.m, Espacio.m, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(liveRegion: true, child: Text(texto, style: Theme.of(context).textTheme.titleMedium)),
          const SizedBox(height: Espacio.s),
          // El texto ya dice el paso; la barra es solo visual.
          ExcludeSemantics(
            child: LinearProgressIndicator(value: revisando ? 1 : (paso + 1) / pasos.length),
          ),
        ],
      ),
    );
  }
}

class _ApartadoRevision extends StatelessWidget {
  const _ApartadoRevision({required this.titulo, required this.alEditar, required this.hijos});

  final String titulo;
  final VoidCallback alEditar;
  final List<Widget> hijos;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Espacio.m),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(Espacio.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TituloSeccion(
                titulo: titulo,
                textoBoton: 'Editar',
                etiquetaBoton: 'Editar ${titulo.toLowerCase()}',
                alPulsar: alEditar,
              ),
              ...hijos,
            ],
          ),
        ),
      ),
    );
  }
}
