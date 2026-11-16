import 'package:emprestapp/app.dart';
import 'package:emprestapp/datos/datos_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'utilidades.dart';

/// Los tres recorridos críticos de la semana 1 (apartado 1.4), de principio a
/// fin y con los errores que deben explicarse bien.
void main() {
  testWidgets('Recorrido 1: crear cuenta con el correo de la universidad', (tester) async {
    usarPantallaDeMovil(tester, alto: 2000);
    await tester.pumpWidget(EmprestApp(datos: DatosApp()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Crear cuenta'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextFormField, 'Correo de la universidad'), 'maria@gmail.com');
    await tester.enterText(find.widgetWithText(TextFormField, 'Contraseña'), 'contrasena123');
    await tester.tap(find.text('Enviar código'));
    await tester.pumpAndSettle();

    // RNF6: el error explica qué pasa; RNF7: no se borra lo escrito.
    expect(find.textContaining('Tienes que usar tu correo de la universidad'), findsOneWidget);
    expect(find.text('maria@gmail.com'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Correo de la universidad'), 'maria@estudiantes.unileon.es');
    await tester.tap(find.text('Enviar código'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 2 de 2: código de verificación'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Código de verificación'), '111111');
    await tester.tap(find.text('Verificar y entrar'));
    await tester.pumpAndSettle();
    expect(find.textContaining('El código no es correcto'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextField, 'Código de verificación'), DatosApp.codigoDePrueba);
    await tester.tap(find.text('Verificar y entrar'));
    await tester.pumpAndSettle();
    expect(find.text('Hola, maria'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('Recorrido 2: buscar, ver la ficha, reservar y hablar con el dueño', (tester) async {
    usarPantallaDeMovil(tester, alto: 2000);
    await entrar(tester);

    await tester.tap(find.text('Buscar material'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Buscar material'), 'camara');
    await tester.pumpAndSettle();
    expect(find.text('1 material encontrado'), findsOneWidget);

    await tester.tap(find.text('Cámara réflex'));
    await tester.pumpAndSettle();
    expect(find.text('Detalles del material'), findsOneWidget);

    // "Cancelar y volver" no reserva nada.
    await tester.tap(find.widgetWithText(FilledButton, 'Reservar'));
    await tester.pumpAndSettle();
    expect(find.text('¿Confirmas la reserva?'), findsOneWidget);
    await tester.tap(find.text('Cancelar y volver'));
    await tester.pumpAndSettle();
    expect(find.text('¿Confirmas la reserva?'), findsNothing);
    expect(find.text('Disponible'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Reservar'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirmar reserva'));
    await tester.pumpAndSettle();
    expect(find.text('Chat con Laura Gómez'), findsOneWidget);
    expect(find.text('Reserva confirmada'), findsOneWidget);

    // RF7: respuesta rápida.
    await tester.tap(find.widgetWithText(ActionChip, '¿Dónde quedamos?'));
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

    await tocarEnLaBarra(tester, 'Publicar');
    expect(find.text('Paso 1 de 3: Fotos'), findsOneWidget);

    // Sin foto no deja seguir y lo explica.
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();
    expect(find.text('Falta añadir al menos una foto del material.'), findsOneWidget);

    await tester.tap(find.text('Hacer foto'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Qué se ve en la foto 1'), 'Calculadora gris con la tapa');
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 2 de 3: Descripción'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Nombre del material'), 'Calculadora gráfica');
    await tester.enterText(find.widgetWithText(TextFormField, 'Para qué sirve (una frase)'), 'Para Cálculo I');
    await tester.enterText(find.widgetWithText(TextFormField, 'Descripción'), 'Casio con pilas nuevas');
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();
    expect(find.text('Elige una categoría para que lo encuentren en el buscador.'), findsOneWidget);

    await tester.tap(find.widgetWithText(ChoiceChip, 'Calculadoras'));
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 3 de 3: Condiciones'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Cuándo se puede prestar'), 'Por las mañanas');
    await tester.enterText(find.widgetWithText(TextFormField, 'Dónde se entrega'), 'Biblioteca');
    await tester.tap(find.text('Revisar anuncio'));
    await tester.pumpAndSettle();
    expect(find.text('Revisar el anuncio antes de publicar'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Publicar material'));
    await tester.pumpAndSettle();
    expect(find.text('Mis anuncios'), findsOneWidget);
    expect(find.text('Calculadora gráfica'), findsOneWidget);
  });

  testWidgets('RF10: si se sale a mitad de publicar, se puede seguir con el borrador', (tester) async {
    usarPantallaDeMovil(tester, alto: 2000);
    await entrar(tester);

    await tocarEnLaBarra(tester, 'Publicar');
    await tester.tap(find.text('Hacer foto'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Qué se ve en la foto 1'), 'Libro de tapa roja');

    await tocarEnLaBarra(tester, 'Inicio');
    await tocarEnLaBarra(tester, 'Publicar');
    expect(find.text('Tienes un anuncio a medias'), findsOneWidget);
    await tester.tap(find.text('Seguir con el anuncio'));
    await tester.pumpAndSettle();
    expect(find.text('Libro de tapa roja'), findsOneWidget);
  });

  testWidgets('Revisión de la semana 3: desde Mis anuncios también se puede publicar', (tester) async {
    usarPantallaDeMovil(tester, alto: 2000);
    await entrar(tester);

    await tester.tap(find.text('Ver mis anuncios'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(FilledButton, 'Publicar material'));
    await tester.pumpAndSettle();
    expect(find.text('Paso 1 de 3: Fotos'), findsOneWidget);
  });

  testWidgets('Desde Ajustes se puede elegir el modo oscuro (4.3)', (tester) async {
    usarPantallaDeMovil(tester, alto: 2000);
    await entrar(tester);
    Brightness brilloActual() => Theme.of(tester.element(find.byType(Scaffold).last)).brightness;
    expect(brilloActual(), Brightness.light);

    await tester.tap(find.text('Ajustes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Modo oscuro'));
    await tester.pumpAndSettle();
    expect(brilloActual(), Brightness.dark);

    await tester.tap(find.text('Modo claro'));
    await tester.pumpAndSettle();
    expect(brilloActual(), Brightness.light);
  });

  testWidgets('Cancelar una reserva pide confirmación (RF6)', (tester) async {
    usarPantallaDeMovil(tester, alto: 2000);
    await entrar(tester);

    await tester.tap(find.text('Ver mis reservas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cancelar reserva'));
    await tester.pumpAndSettle();
    expect(find.text('¿Cancelar la reserva?'), findsOneWidget);
    await tester.tap(find.text('No, mantenerla'));
    await tester.pumpAndSettle();
    expect(find.text('Cancelar reserva'), findsOneWidget);

    await tester.tap(find.text('Cancelar reserva'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sí, cancelar reserva'));
    await tester.pumpAndSettle();
    expect(find.text('No tienes ninguna reserva.'), findsOneWidget);
  });
}

/// Entra con un correo de la universidad desde la pantalla de bienvenida.
Future<void> entrar(WidgetTester tester) async {
  await tester.pumpWidget(EmprestApp(datos: DatosApp()));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Iniciar sesión'));
  await tester.pumpAndSettle();
  await tester.enterText(find.widgetWithText(TextFormField, 'Correo de la universidad'), 'jose@estudiantes.unileon.es');
  await tester.enterText(find.widgetWithText(TextFormField, 'Contraseña'), 'una contraseña');
  await tester.tap(find.widgetWithText(FilledButton, 'Iniciar sesión'));
  await tester.pumpAndSettle();
}

Future<void> tocarEnLaBarra(WidgetTester tester, String destino) async {
  await tester.tap(find.descendant(of: find.byType(NavigationBar), matching: find.text(destino)).first);
  await tester.pumpAndSettle();
}
