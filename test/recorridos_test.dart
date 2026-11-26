import 'package:emprestapp/app.dart';
import 'package:emprestapp/datos/datos_app.dart';
import 'package:emprestapp/widgets/barra_opciones.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utilidades.dart';

/// Los tres recorridos críticos de la semana 1 (apartado 1.4), de principio a
/// fin y con los mensajes de error del apartado 4.4.
void main() {
  testWidgets('Recorrido 1: crear cuenta con el correo de la universidad', (tester) async {
    usarPantallaDeMovil(tester, alto: 2000);
    await tester.pumpWidget(EmprestApp(datos: DatosApp()));
    await tester.pumpAndSettle();

    await tester.tap(boton('Crear cuenta'));
    await tester.pumpAndSettle();
    await tester.enterText(campo('Correo de la universidad'), 'maria@gmail.com');
    await tester.enterText(campo('Contraseña'), 'contrasena123');
    await tester.tap(boton('Enviar código'));
    await tester.pumpAndSettle();

    // RNF6: el error explica qué pasa; RNF7: no se borra lo escrito.
    expect(find.textContaining('Ese correo no es de la universidad'), findsOneWidget);
    expect(find.text('maria@gmail.com'), findsOneWidget);

    await tester.enterText(campo('Correo de la universidad'), 'maria@estudiantes.unileon.es');
    await tester.tap(boton('Enviar código'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 2 de 2: código de verificación'), findsOneWidget);

    await tester.enterText(campo('Código de verificación'), '111111');
    await tester.tap(boton('Verificar y entrar'));
    await tester.pumpAndSettle();
    expect(find.text('El código no es correcto. Revísalo o solicita uno nuevo.'), findsOneWidget);

    await tester.enterText(campo('Código de verificación'), DatosApp.codigoDePrueba);
    await tester.tap(boton('Verificar y entrar'));
    await tester.pumpAndSettle();
    expect(find.text('Hola, maria'), findsOneWidget);
    expect(find.byType(BarraOpciones), findsOneWidget);
  });

  testWidgets('La casilla "Mostrar la contraseña" enseña lo que se ha escrito', (tester) async {
    usarPantallaDeMovil(tester, alto: 2000);
    await tester.pumpWidget(EmprestApp(datos: DatosApp()));
    await tester.pumpAndSettle();
    await tester.tap(boton('Iniciar sesión'));
    await tester.pumpAndSettle();

    bool oculta() => tester.widget<TextField>(campo('Contraseña')).obscureText;
    expect(oculta(), isTrue);
    await tester.tap(find.text('Mostrar la contraseña'));
    await tester.pumpAndSettle();
    expect(oculta(), isFalse);
  });

  testWidgets('Recorrido 2: buscar, ver la ficha, reservar y hablar con el dueño', (tester) async {
    usarPantallaDeMovil(tester, alto: 2000);
    await entrar(tester);

    await tester.tap(boton('Buscar material'));
    await tester.pumpAndSettle();
    await tester.enterText(campo('¿Qué buscas?'), 'camara');
    await tester.tap(boton('Buscar'));
    await tester.pumpAndSettle();
    expect(find.text('1 material encontrado'), findsOneWidget);

    await tester.tap(find.text('Cámara réflex'));
    await tester.pumpAndSettle();
    expect(find.text('Detalles del material'), findsOneWidget);

    // "Cancelar y volver" no reserva nada.
    await tester.tap(boton('Reservar'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);
    await tester.tap(botonDelDialogo('Cancelar y volver'));
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsNothing);
    expect(find.text('Disponible'), findsOneWidget);

    await tester.tap(boton('Reservar'));
    await tester.pumpAndSettle();
    await tester.tap(botonDelDialogo('Confirmar reserva'));
    await tester.pumpAndSettle();
    expect(find.text('Chat con Laura Gómez'), findsOneWidget);
    expect(find.text('Reserva confirmada'), findsOneWidget);

    // RF7: respuesta rápida.
    await tester.tap(boton('¿Dónde quedamos?'));
    await tester.pumpAndSettle();
    expect(find.text('¿Dónde quedamos?'), findsNWidgets(2));

    // Al volver, la ficha ya dice "Reservado". (No se usa tester.pageBack()
    // porque busca el botón en inglés, "Back", y aquí se llama "Atrás".)
    expect(find.byTooltip('Atrás'), findsOneWidget);
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Reservado'), findsOneWidget);
  });

  testWidgets('Recorrido 3: publicar material en tres pasos y verlo en Mis anuncios', (tester) async {
    usarPantallaDeMovil(tester, alto: 2000);
    await entrar(tester);

    await tester.tap(opcionDeLaBarra('Publicar'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 1 de 3: Fotos'), findsOneWidget);

    // Sin foto no deja seguir y lo explica.
    await tester.tap(boton('Siguiente'));
    await tester.pumpAndSettle();
    expect(find.text('Falta añadir al menos una foto del material.'), findsOneWidget);

    // Con una foto sin describir, tampoco (mensaje del apartado 4.4).
    await tester.tap(boton('Hacer foto'));
    await tester.pumpAndSettle();
    await tester.tap(boton('Siguiente'));
    await tester.pumpAndSettle();
    expect(
      find.text('Añade una descripción de la foto para que otras personas puedan saber qué muestra.'),
      findsOneWidget,
    );

    await tester.enterText(campo('Qué se ve en la foto 1'), 'Calculadora gris con la tapa');
    await tester.tap(boton('Siguiente'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 2 de 3: Descripción'), findsOneWidget);

    await tester.enterText(campo('Nombre del material'), 'Calculadora gráfica');
    await tester.enterText(campo('Para qué sirve (una frase)'), 'Para Cálculo I');
    await tester.enterText(campo('Descripción'), 'Casio con pilas nuevas');
    await tester.tap(boton('Siguiente'));
    await tester.pumpAndSettle();
    expect(find.text('Elige una categoría para que lo encuentren en el buscador.'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Calculadoras'));
    await tester.tap(boton('Siguiente'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 3 de 3: Condiciones'), findsOneWidget);

    await tester.enterText(campo('Cuándo se puede prestar'), 'Por las mañanas');
    await tester.enterText(campo('Dónde se entrega'), 'Biblioteca');
    await tester.tap(boton('Revisar anuncio'));
    await tester.pumpAndSettle();
    expect(find.text('Revisar el anuncio antes de publicar'), findsOneWidget);

    await tester.tap(boton('Publicar material'));
    await tester.pump();
    // Estado de carga: se ve, TalkBack lo lee al aparecer y no se puede volver a pulsar.
    expect(
      tester.getSemantics(find.text('Publicando el anuncio…')),
      isSemantics(label: 'Publicando el anuncio…', isLiveRegion: true),
    );
    expect(tester.widget<ButtonStyleButton>(boton('Publicar material')).enabled, isFalse);
    await tester.pumpAndSettle();
    expect(find.text('Mis anuncios'), findsOneWidget);
    expect(find.text('Calculadora gráfica'), findsOneWidget);
  });

  testWidgets('RF10: si se sale a mitad de publicar, se puede seguir con el borrador', (tester) async {
    usarPantallaDeMovil(tester, alto: 2000);
    await entrar(tester);

    await tester.tap(opcionDeLaBarra('Publicar'));
    await tester.pumpAndSettle();
    await tester.tap(boton('Hacer foto'));
    await tester.pumpAndSettle();
    await tester.enterText(campo('Qué se ve en la foto 1'), 'Libro de tapa roja');

    await tester.tap(opcionDeLaBarra('Inicio'));
    await tester.pumpAndSettle();
    await tester.tap(opcionDeLaBarra('Publicar'));
    await tester.pumpAndSettle();
    expect(find.text('Tienes un anuncio a medias'), findsOneWidget);
    await tester.tap(botonDelDialogo('Seguir con el anuncio'));
    await tester.pumpAndSettle();
    expect(find.text('Libro de tapa roja'), findsOneWidget);
  });

  testWidgets('Borrar una foto pide confirmación y nombra la acción y la alternativa (4.4)', (tester) async {
    usarPantallaDeMovil(tester, alto: 2000);
    await entrar(tester);

    await tester.tap(opcionDeLaBarra('Publicar'));
    await tester.pumpAndSettle();
    await tester.tap(boton('Hacer foto'));
    await tester.pumpAndSettle();
    await tester.tap(boton('Borrar foto'));
    await tester.pumpAndSettle();
    expect(find.text('¿Borrar la foto 1?'), findsOneWidget);
    await tester.tap(botonDelDialogo('Volver sin borrar'));
    await tester.pumpAndSettle();
    expect(find.text('Foto 1'), findsOneWidget);

    await tester.tap(boton('Borrar foto'));
    await tester.pumpAndSettle();
    await tester.tap(botonDelDialogo('Borrar foto'));
    await tester.pumpAndSettle();
    expect(find.text('Foto 1'), findsNothing);
  });

  testWidgets('Revisión de la semana 3: desde Mis anuncios también se puede publicar', (tester) async {
    usarPantallaDeMovil(tester, alto: 2000);
    await entrar(tester);

    await tester.tap(boton('Ver mis anuncios'));
    await tester.pumpAndSettle();
    await tester.tap(boton('Publicar material'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 1 de 3: Fotos'), findsOneWidget);
  });

  testWidgets('Cancelar una reserva pide confirmación (RF6)', (tester) async {
    usarPantallaDeMovil(tester, alto: 2000);
    await entrar(tester);

    await tester.tap(boton('Ver mis reservas'));
    await tester.pumpAndSettle();
    await tester.tap(boton('Cancelar reserva'));
    await tester.pumpAndSettle();
    expect(find.text('¿Cancelar la reserva?'), findsOneWidget);
    await tester.tap(botonDelDialogo('Volver sin cancelar'));
    await tester.pumpAndSettle();
    expect(boton('Cancelar reserva'), findsOneWidget);

    await tester.tap(boton('Cancelar reserva'));
    await tester.pumpAndSettle();
    await tester.tap(botonDelDialogo('Cancelar reserva'));
    await tester.pumpAndSettle();
    expect(find.text('No tienes ninguna reserva.'), findsOneWidget);
  });
}

/// Entra con un correo de la universidad desde la pantalla de bienvenida.
Future<void> entrar(WidgetTester tester) async {
  await tester.pumpWidget(EmprestApp(datos: DatosApp()));
  await tester.pumpAndSettle();
  await tester.tap(boton('Iniciar sesión'));
  await tester.pumpAndSettle();
  await tester.enterText(campo('Correo de la universidad'), 'jose@estudiantes.unileon.es');
  await tester.enterText(campo('Contraseña'), 'una contraseña');
  await tester.tap(boton('Iniciar sesión'));
  await tester.pumpAndSettle();
}
