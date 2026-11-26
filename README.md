# EmprestApp

Proyecto Flutter de la práctica final de Accesibilidad (Grupo D). EmprestApp es una aplicación para prestar, alquilar o regalar material universitario entre estudiantes del campus.

Este proyecto es el punto 6 de la semana 4: el proyecto creado, con el tema (el sistema visual del apartado 4.1 de la memoria) y la estructura de navegación.

La aplicación no tiene base de datos ni servidor. Los datos son de prueba y están en memoria, así que al cerrarla todo vuelve a como estaba. Lo que sí está hecho son las diez pantallas del inventario de la semana 3, la navegación del mapa (3.2) y los tres recorridos críticos funcionando de forma simulada, pensando sobre todo en la accesibilidad.

## Cómo probarla

```bash
flutter pub get
flutter run
```

- **Iniciar sesión:** vale cualquier correo que termine en `@unileon.es` o `@estudiantes.unileon.es`, con cualquier contraseña.
- **Crear cuenta:** el código de verificación es `123456`, el mismo que en el prototipo de la semana 3.
- **Pruebas automáticas:** `flutter test` lanza todas (contraste de la paleta, guías de accesibilidad de Flutter, texto al 200 % y los tres recorridos).

## Estructura

```
lib/
  main.dart                 arranca la aplicación
  app.dart                  MaterialApp: tema, textos en español y rutas
  tema/
    colores.dart            paleta del 4.1 con los contrastes medidos (tabla del 4.2)
    tema.dart               sistema visual del 4.1: letra, títulos, botones, campos, estados...
  navegacion/
    rutas.dart              una ruta por pantalla del inventario + irA() para volver al menú
  datos/
    modelos.dart            Anuncio, Reserva, Conversacion, Mensaje, BorradorAnuncio
    datos_app.dart          estado en memoria (sesión, reservas, chats, anuncios)
    datos_prueba.dart       datos inventados sacados de la memoria
  pantallas/                una pantalla por archivo, con el número del inventario
  widgets/                  piezas que se repiten (barra de arriba, campo de texto, barra de opciones, estado, carga...)
assets/fuentes/             tipografía Lexend y su licencia (SIL Open Font License)
test/
  contraste_test.dart       contraste de la paleta (PASS/FAIL)
  accesibilidad_test.dart   guías de accesibilidad de Flutter en cada pantalla
  texto_grande_test.dart    todas las pantallas con la letra al 200 %
  barra_superior_test.dart  el título de arriba se lee entero con la letra al 200 %
  recorridos_test.dart      los tres recorridos críticos de principio a fin
```

## Sistema visual (apartado 4.1)

- **Colores:** fondo blanco en todas las pantallas, azul `#1D4ED8` para las acciones principales (`#1E3A8A` mientras se pulsa), texto `#111827`, texto secundario `#475569`, bordes `#64748B`, error `#B91C1C` y éxito `#166534`.
- **Tipografía:** Lexend, que no confunde letras como I y l. Texto de lectura y de los campos a 16 sp; etiquetas, ayudas, mensajes y barra de abajo a 14 sp. Crece con la letra del móvil hasta el 200 % y no se bloquea en ningún sitio.
- **Títulos en negrita:** 28 sp para el nombre de la aplicación, 24 sp para el título de cada pantalla y 20 sp para las secciones y el nombre del material en su ficha.
- **Espaciados:** múltiplos de 8 dp. 8 entre controles, 16 de márgenes y dentro de las tarjetas, y 24 entre bloques.
- **Botones:** de 48 × 48 dp como mínimo y con icono al lado. Hay tres tipos:
  - el principal, azul con texto blanco;
  - el secundario, blanco con borde y texto azul;
  - el de borrar, rojo con texto blanco, solo para cancelar una reserva, retirar un anuncio o borrar una foto, y siempre con confirmación.
- **Botón deshabilitado:** blanco con texto y borde gris, y con una explicación al lado.
- **Campos:** etiqueta fuera, encima, que se ve siempre; borde de 1 dp gris, de 2 dp azul al enfocarlos y de 2 dp rojo con un error. El error va debajo, en rojo y con icono.
- **Estados:**
  - "Disponible" en verde con ✓ y "Reservado" en gris con un reloj;
  - filtros marcados con fondo azul claro, texto azul oscuro y ✓;
  - en la barra de abajo, la opción actual va en azul, en negrita y con una raya encima;
  - las confirmaciones salen en verde y en negrita;
  - mientras se publica sale un círculo que gira con "Publicando el anuncio…" y los botones se desactivan.
- **Diálogos de confirmación:** confirmar arriba (azul, o rojo si borra algo) y cancelar debajo como botón secundario. Los botones nombran la acción y la alternativa ("Retirar anuncio" / "Volver sin retirar").

## Pantallas y navegación

| Pantalla (3.1) | Archivo | Ruta |
|---|---|---|
| P1 · Inicio de sesión y registro | `p1_acceso.dart`, `p1_crear_cuenta.dart`, `p1_iniciar_sesion.dart` | `/acceso`, `/acceso/crear-cuenta`, `/acceso/iniciar-sesion` |
| P2 · Menú principal | `p2_menu_principal.dart` | `/menu` |
| P3 · Buscar material | `p3_buscar_material.dart` | `/buscar` |
| P4 · Detalles del material | `p4_detalle_material.dart` | `/detalle` |
| P5 · Chats | `p5_chats.dart`, `p5_conversacion.dart` | `/chats`, `/chats/conversacion` |
| P6 · Confirmación de reserva | `p6_confirmar_reserva.dart` | ninguna: es un diálogo encima de la P4 |
| P7 · Publicar material | `p7_publicar_material.dart` | `/publicar` |
| P8 · Mis reservas | `p8_mis_reservas.dart` | `/mis-reservas` |
| P9 · Mis anuncios | `p9_mis_anuncios.dart` | `/mis-anuncios` |
| P10 · Ajustes | `p10_ajustes.dart` | `/ajustes` |

Cómo está montado el mapa de navegación:

- **Entrada:** al abrir la aplicación se mira si hay sesión. Si no la hay se va a la P1 y, si la hay, al menú (P2).
- **Barra de opciones:** abajo hay una barra con Inicio, Buscar, Publicar y Chats, siempre en el mismo sitio. "Inicio" vuelve al menú desde cualquier pantalla principal (las marcas ↩ P2 del mapa).
- **Recorrido 2:** P3 → P4 → "Reservar" abre la P6 → "Confirmar reserva" abre el chat (P5). "Cancelar y volver" deja la ficha como estaba.
- **Recorrido 3:** P7, que se rellena en tres pasos y se revisa antes de publicar → al publicar se va a Mis anuncios (P9).
- **Salida:** "Cerrar sesión" en Ajustes pide confirmación y vuelve a la P1.
- **Cambio de la revisión 3.7:** Mis anuncios también tiene el botón "Publicar material". Se llama igual que la pantalla 7, para no tener dos nombres para lo mismo (RNF5).

## Dónde está cada requisito

| Requisito | Dónde |
|---|---|
| RF1 Crear cuenta con el correo de la universidad, con código, pedir otro y cambiar el correo | `p1_crear_cuenta.dart` |
| RF2 Iniciar sesión con autorrelleno de la contraseña | `p1_iniciar_sesion.dart` |
| RF3 Buscar y filtrar por tipo, categoría y disponibilidad | `p3_buscar_material.dart` |
| RF4 Ficha con fotos descritas, condiciones y estado escrito | `p4_detalle_material.dart` |
| RF5 Reservar con resumen y confirmación | `p6_confirmar_reserva.dart` |
| RF6 Cancelar una reserva con botón y confirmación | `p8_mis_reservas.dart` |
| RF7 Chat con respuestas rápidas | `p5_conversacion.dart` |
| RF8–RF11 Publicar por pasos, fotos descritas, borrador y revisión | `p7_publicar_material.dart` |
| RF12 Editar o retirar un anuncio | `p9_mis_anuncios.dart`, que para editar reutiliza `p7_publicar_material.dart` |
| RNF1 Contraste | `tema/colores.dart` + `test/contraste_test.dart` + guía `textContrastGuideline` |
| RNF2 Letra mínima de 14 sp y texto al 200 % | `tema/tema.dart` (no se bloquea el escalado), `widgets/barra_superior.dart` (el título de arriba no se corta) + `test/texto_grande_test.dart` y `test/barra_superior_test.dart` |
| RNF3 Botones de 48 × 48 y 8 dp de separación | `tema/tema.dart` + guías `androidTapTargetGuideline` e `iOSTapTargetGuideline` |
| RNF4 Etiquetas siempre visibles en los campos | `widgets/campo_texto.dart` (etiqueta fuera, encima) |
| RNF5 Mismos nombres en todas las pantallas | "Reservar", "Publicar material", "Inicio", "Disponible" y "Reservado" en todas partes |
| RNF6 Errores que explican qué falla, junto al campo y leídos por TalkBack | `widgets/campo_texto.dart` (`MensajeError`) + `widgets/aviso.dart` |
| RNF7 No perder lo escrito | los formularios mantienen los datos al fallar; publicar guarda un borrador |
| RNF9 Nombre para TalkBack en controles y fotos | `widgets/foto_material.dart`, `semanticsLabel` en los botones + guía `labeledTapTargetGuideline` |
| RNF10 Nada solo con color | estado con texto e icono (`etiqueta_estado.dart`), errores con icono, filtros con ✓, raya en la barra, interruptores con marca |
| RNF11 Sin gestos obligatorios | sin deslizar para borrar ni carruseles; ordenar fotos con "Subir" y "Bajar" |

Lo que está pensado para la accesibilidad en todas las pantallas:

- **Widgets estándar de Flutter siempre que se puede.** Ya traen la semántica hecha.
- **`Semantics` solo cuando hace falta:**
  - la etiqueta y el campo de texto se leen juntos;
  - las tarjetas se leen de una vez;
  - las fotos, con su descripción;
  - el estado "Disponible/Reservado";
  - los títulos van marcados como encabezado;
  - los errores, los avisos y la espera al publicar los lee TalkBack al aparecer.
- **Sin ruido para TalkBack:** los iconos que acompañan a un texto no se leen, y el "Ver detalle ›" de las tarjetas tampoco, porque repetiría lo que ya dice el botón ("toca dos veces para abrir la ficha").
- **Sin botones de solo icono.** Todos llevan texto. La única excepción es la flecha de atrás, que es la estándar y TalkBack lee "Atrás" porque la aplicación está en español. Para ver la contraseña hay una casilla "Mostrar la contraseña" en vez de un ojo dentro del campo.
- **Mensajes de error del apartado 4.4:**
  - "Ese correo no es de la universidad. Usa tu correo @estudiantes.unileon.es o @unileon.es."
  - "El código no es correcto. Revísalo o solicita uno nuevo."
  - "Añade una descripción de la foto para que otras personas puedan saber qué muestra."
- **Datos inventados:** salen de la memoria (la cámara de Laura, los libros de Finanzas de María, la tableta de José...).

## Tabla de contrastes (apartado 4.2)

Sale de `flutter test test/contraste_test.dart`, que la imprime. Mínimos (RNF1): 4,5:1 para texto y 3:1 para bordes y elementos que hacen falta para reconocer un control o su estado.

| Combinación | Colores | Ratio | Mínimo | Resultado |
|---|---|---|---|---|
| Texto principal #111827 sobre blanco | #111827 / #FFFFFF | 17,74:1 | 4,5:1 | PASS |
| Texto secundario #475569 sobre blanco | #475569 / #FFFFFF | 7,58:1 | 4,5:1 | PASS |
| Texto blanco sobre botón azul #1D4ED8 | #FFFFFF / #1D4ED8 | 6,70:1 | 4,5:1 | PASS |
| Texto blanco sobre botón pulsado #1E3A8A | #FFFFFF / #1E3A8A | 10,36:1 | 4,5:1 | PASS |
| Texto de error #B91C1C sobre blanco | #B91C1C / #FFFFFF | 6,47:1 | 4,5:1 | PASS |
| Texto de éxito y "Disponible" #166534 sobre blanco | #166534 / #FFFFFF | 7,13:1 | 4,5:1 | PASS |
| Texto azul y respuestas rápidas #1D4ED8 sobre blanco | #1D4ED8 / #FFFFFF | 6,70:1 | 4,5:1 | PASS |
| Borde de campo #64748B sobre blanco | #64748B / #FFFFFF | 4,76:1 | 3:1 | PASS |
| Borde de foco #1D4ED8 sobre blanco | #1D4ED8 / #FFFFFF | 6,70:1 | 3:1 | PASS |
| Texto blanco sobre botón rojo #B91C1C | #FFFFFF / #B91C1C | 6,47:1 | 4,5:1 | PASS |
| Texto del filtro seleccionado #1E3A8A sobre #DBEAFE | #1E3A8A / #DBEAFE | 8,49:1 | 4,5:1 | PASS |
| Texto y borde de controles deshabilitados #64748B sobre blanco | #64748B / #FFFFFF | 4,76:1 | 4,5:1 | PASS |
| Estado "Reservado" #475569 sobre blanco | #475569 / #FFFFFF | 7,58:1 | 4,5:1 | PASS |
| Icono de las fotos de ejemplo #475569 sobre #E2E8F0 | #475569 / #E2E8F0 | 6,15:1 | 3:1 | PASS |

Si cambiáis algún color, solo hay que tocar `lib/tema/colores.dart` y volver a pasar el test.

## Notas

- **El título de arriba solo crece hasta 1,34 veces** con la letra al 200 %. Es como viene ese componente en Flutter, pero ya no se corta: si no cabe en una línea, baja a la siguiente y la barra crece (`widgets/barra_superior.dart`). La barra inferior conserva el tamaño de las etiquetas: muestra cuatro opciones por fila con texto normal y dos con letra grande, con 8 dp entre zonas táctiles. Todo lo demás crece entero.
- **Simulado:** la cámara, el envío del código, la espera al publicar (2 segundos, para que se vea el estado de carga) y que la sesión y los ajustes se queden guardados. Si hiciera falta que lo escrito sobreviva a que Android cierre la aplicación (RNF7), se puede usar la restauración de estado de Flutter, sin base de datos.
- **Pendiente para la semana 5:** la prueba manual con TalkBack en un móvil real y la validación en iOS.

## Verificación del 16/11/2026

- Flutter 3.50.0 y Dart 3.14.0: `flutter test` supera 58 pruebas (51 originales, 4 de regresión de la barra, 1 de mediciones y 2 de revisión cruzada).
- APK debug compilada para Android; Android Gradle Plugin 9.1.1 permite compilar con ese SDK.
- Alta, reserva con chat y publicación comprobadas con datos ficticios en Medium Phone API 36.1 (1080×2400, 420 dpi).
- Barra comprobada visualmente con texto al 200 %: etiquetas completas y dos columnas. Se ha restaurado el tamaño normal del emulador.
- Las medidas cubren una muestra de controles; no constituyen una auditoría exhaustiva ni una prueba manual con TalkBack.
### Cambios tras la revisión cruzada

- Las tarjetas muestran «Ver detalle ›». Las reservadas aclaran que se puede consultar la ficha, aunque no volver a reservar.
- La confirmación usa «Resumen de la reserva» como título y mantiene «Confirmar reserva» como acción. Se conserva el diálogo sobre la ficha y la barra de navegación.
- Comprobados en emulador y cubiertos por pruebas de acceso a la ficha, reserva deshabilitada y cancelación del diálogo.