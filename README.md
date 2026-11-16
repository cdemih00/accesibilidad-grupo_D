# EmprestApp

Proyecto Flutter de la práctica final de Accesibilidad (Grupo D). EmprestApp es una aplicación para prestar, alquilar o regalar material universitario entre estudiantes del campus.

Este proyecto es el punto 6 de la semana 4: el proyecto creado, con el tema (modo claro y modo oscuro) y la estructura de navegación.

La aplicación no tiene base de datos ni servidor. Los datos son de prueba y están en memoria, así que al cerrarla todo vuelve a como estaba. Lo que sí está hecho son las diez pantallas del inventario de la semana 3, la navegación del mapa (3.2) y los tres recorridos críticos funcionando de forma simulada, pensando sobre todo en la accesibilidad.

## Cómo probarla

```bash
flutter pub get
flutter run
```

- **Iniciar sesión:** vale cualquier correo que termine en `@unileon.es` o `@estudiantes.unileon.es`, con cualquier contraseña.
- **Crear cuenta:** el código de verificación es `123456`, el mismo que en el prototipo de la semana 3.
- **Modo claro u oscuro:** se elige en Ajustes. Por defecto sigue el que tenga puesto el móvil.
- **Pruebas automáticas:** `flutter test` lanza todas (contraste de las dos paletas, guías de accesibilidad en los dos modos, texto al 200 % y los tres recorridos).

## Estructura

```
lib/
  main.dart                 arranca la aplicación
  app.dart                  MaterialApp: temas claro y oscuro, textos en español y rutas
  tema/
    colores.dart            paletas clara y oscura con los contrastes medidos
    tema.dart               sistema visual: letra, botones de 48 dp, campos, estados...
  navegacion/
    rutas.dart              una ruta por pantalla del inventario + irA() para volver al menú
  datos/
    modelos.dart            Anuncio, Reserva, Conversacion, Mensaje, BorradorAnuncio
    datos_app.dart          estado en memoria (sesión, reservas, chats, anuncios, tema)
    datos_prueba.dart       datos inventados sacados de la memoria
  pantallas/                una pantalla por archivo, con el número del inventario
  widgets/                  piezas que se repiten (barra de opciones, estado, fotos...)
test/
  contraste_test.dart       contraste de las dos paletas (PASS/FAIL)
  accesibilidad_test.dart   guías de accesibilidad de Flutter en cada pantalla y en los dos modos
  texto_grande_test.dart    todas las pantallas con la letra al 200 %
  recorridos_test.dart      los tres recorridos críticos de principio a fin
```

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
- **Barra de opciones:** abajo hay una barra con Inicio, Buscar, Publicar y Chats, siempre en el mismo sitio y con el texto debajo de cada icono. "Inicio" vuelve al menú desde cualquier pantalla principal (las marcas ↩ P2 del mapa).
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
| RNF2 Letra mínima de 14 sp y texto al 200 % | `tema/tema.dart` (no se bloquea el escalado) + `test/texto_grande_test.dart` |
| RNF3 Botones de 48 × 48 y 8 dp de separación | `tema/tema.dart` + guías `androidTapTargetGuideline` e `iOSTapTargetGuideline` |
| RNF4 Etiquetas siempre visibles en los campos | `tema/tema.dart` (`FloatingLabelBehavior.always`) |
| RNF5 Mismos nombres en todas las pantallas | `widgets/etiqueta_estado.dart`, `Anuncio.precioTexto`, "Reservar" y "Publicar material" en todas partes |
| RNF6 Errores que explican qué falla, junto al campo y leídos por TalkBack | validadores de los formularios + `widgets/aviso.dart` |
| RNF7 No perder lo escrito | los formularios mantienen los datos al fallar; publicar guarda un borrador |
| RNF9 Nombre para TalkBack en controles y fotos | `widgets/foto_material.dart`, `semanticsLabel` en los botones + guía `labeledTapTargetGuideline` |
| RNF10 Nada solo con color | estado con texto e icono (`etiqueta_estado.dart`), avisos con icono, chips con marca, interruptores con marca, botones de texto subrayados |
| RNF11 Sin gestos obligatorios | sin deslizar para borrar ni carruseles; ordenar fotos con "Subir" y "Bajar" |
| Modo oscuro (4.3) | `tema/colores.dart` (`Paleta.oscura`), `app.dart` y la opción en `p10_ajustes.dart` |

Lo que está pensado para la accesibilidad en todas las pantallas:

- **Widgets estándar de Flutter siempre que se puede.** Ya traen la semántica hecha.
- **`Semantics` solo cuando hace falta:** tarjetas que se leen de una vez, fotos con su descripción, estado "Disponible/Reservado", títulos marcados como encabezado y avisos que TalkBack lee al aparecer.
- **Sin botones de solo icono hechos por nosotros.** Todos llevan texto ("Ajustes", "Mostrar", "Borrar", "Enviar"...). Las únicas excepciones son la flecha de atrás y la X de cerrar del snackbar, que son estándar y TalkBack lee "Atrás" y "Cerrar" porque la aplicación está en español.
- **Botones de texto subrayados.** Al revisar la interfaz en escala de grises, "Ver mis reservas" y los demás botones sin borde solo se distinguían del texto normal por el azul.
- **Acciones que no se pueden deshacer:** van en rojo, con más separación respecto al resto de botones, y siempre piden confirmación.
- **Modo claro y modo oscuro.** Los dos tienen todos los contrastes medidos y pasan las mismas pruebas.
- **Datos inventados:** salen de la memoria (la cámara de Laura, los libros de Finanzas de María, la tableta de José...).

## Tablas de contraste

Salen de `flutter test test/contraste_test.dart`, que las imprime. Mínimos: 4,5:1 para texto y 3:1 para componentes y estados. El modo claro usa los colores del apartado 4.1 con el fondo de las pantallas roto a `#F8FAFC`, y el modo oscuro los del 4.3.

### Modo claro

| Combinación | Colores | Ratio | Mínimo | Resultado |
|---|---|---|---|---|
| Texto principal sobre el fondo | #111827 / #F8FAFC | 16,96:1 | 4,5:1 | PASS |
| Texto principal sobre tarjetas y campos | #111827 / #FFFFFF | 17,74:1 | 4,5:1 | PASS |
| Texto secundario sobre el fondo | #475569 / #F8FAFC | 7,24:1 | 4,5:1 | PASS |
| Texto secundario sobre tarjetas y campos | #475569 / #FFFFFF | 7,58:1 | 4,5:1 | PASS |
| Texto del botón principal | #FFFFFF / #1D4ED8 | 6,70:1 | 4,5:1 | PASS |
| Texto del botón principal pulsado | #FFFFFF / #1E3A8A | 10,36:1 | 4,5:1 | PASS |
| Botones de texto sobre el fondo | #1D4ED8 / #F8FAFC | 6,41:1 | 4,5:1 | PASS |
| Botones de texto sobre tarjetas | #1D4ED8 / #FFFFFF | 6,70:1 | 4,5:1 | PASS |
| Opción marcada y mensajes propios | #1E3A8A / #DBEAFE | 8,49:1 | 4,5:1 | PASS |
| Mensaje de error sobre el fondo | #B91C1C / #F8FAFC | 6,18:1 | 4,5:1 | PASS |
| Mensaje de error sobre tarjetas y campos | #B91C1C / #FFFFFF | 6,47:1 | 4,5:1 | PASS |
| Texto del botón de borrar o cancelar | #FFFFFF / #B91C1C | 6,47:1 | 4,5:1 | PASS |
| Aviso de error | #7F1D1D / #FEE2E2 | 8,20:1 | 4,5:1 | PASS |
| Mensaje de éxito sobre el fondo | #166534 / #F8FAFC | 6,81:1 | 4,5:1 | PASS |
| Mensaje de éxito sobre tarjetas | #166534 / #FFFFFF | 7,13:1 | 4,5:1 | PASS |
| Aviso de éxito y estado Disponible | #14532D / #DCFCE7 | 8,30:1 | 4,5:1 | PASS |
| Estado Reservado | #78350F / #FEF3C7 | 8,15:1 | 4,5:1 | PASS |
| Snackbar: texto | #F1F5F9 / #1E293B | 13,35:1 | 4,5:1 | PASS |
| Snackbar: botón | #93C5FD / #1E293B | 8,11:1 | 4,5:1 | PASS |
| Borde de campos, chips y tarjetas sobre el fondo | #64748B / #F8FAFC | 4,55:1 | 3:1 | PASS |
| Borde de campos y chips sobre tarjetas | #64748B / #FFFFFF | 4,76:1 | 3:1 | PASS |
| Botón principal sobre el fondo | #1D4ED8 / #F8FAFC | 6,41:1 | 3:1 | PASS |
| Indicador de la barra de opciones | #1D4ED8 / #FFFFFF | 6,70:1 | 3:1 | PASS |
| Icono de Disponible | #166534 / #DCFCE7 | 6,49:1 | 3:1 | PASS |
| Icono de Reservado | #B45309 / #FEF3C7 | 4,51:1 | 3:1 | PASS |
| Icono de error en los avisos | #B91C1C / #FEE2E2 | 5,30:1 | 3:1 | PASS |
| Icono de las fotos de ejemplo | #475569 / #E2E8F0 | 6,15:1 | 3:1 | PASS |

### Modo oscuro

| Combinación | Colores | Ratio | Mínimo | Resultado |
|---|---|---|---|---|
| Texto principal sobre el fondo | #F1F5F9 / #0F172A | 16,30:1 | 4,5:1 | PASS |
| Texto principal sobre tarjetas y campos | #F1F5F9 / #1E293B | 13,35:1 | 4,5:1 | PASS |
| Texto secundario sobre el fondo | #CBD5E1 / #0F172A | 12,02:1 | 4,5:1 | PASS |
| Texto secundario sobre tarjetas y campos | #CBD5E1 / #1E293B | 9,85:1 | 4,5:1 | PASS |
| Texto del botón principal | #0F172A / #60A5FA | 7,02:1 | 4,5:1 | PASS |
| Texto del botón principal pulsado | #0F172A / #93C5FD | 9,90:1 | 4,5:1 | PASS |
| Botones de texto sobre el fondo | #60A5FA / #0F172A | 7,02:1 | 4,5:1 | PASS |
| Botones de texto sobre tarjetas | #60A5FA / #1E293B | 5,75:1 | 4,5:1 | PASS |
| Opción marcada y mensajes propios | #DBEAFE / #1E3A8A | 8,49:1 | 4,5:1 | PASS |
| Mensaje de error sobre el fondo | #F87171 / #0F172A | 6,45:1 | 4,5:1 | PASS |
| Mensaje de error sobre tarjetas y campos | #F87171 / #1E293B | 5,29:1 | 4,5:1 | PASS |
| Texto del botón de borrar o cancelar | #0F172A / #F87171 | 6,45:1 | 4,5:1 | PASS |
| Aviso de error | #FECACA / #450A0A | 11,16:1 | 4,5:1 | PASS |
| Mensaje de éxito sobre el fondo | #4ADE80 / #0F172A | 10,25:1 | 4,5:1 | PASS |
| Mensaje de éxito sobre tarjetas | #4ADE80 / #1E293B | 8,40:1 | 4,5:1 | PASS |
| Aviso de éxito y estado Disponible | #BBF7D0 / #052E16 | 12,30:1 | 4,5:1 | PASS |
| Estado Reservado | #FDE68A / #451A03 | 12,03:1 | 4,5:1 | PASS |
| Snackbar: texto | #0F172A / #F1F5F9 | 16,30:1 | 4,5:1 | PASS |
| Snackbar: botón | #1D4ED8 / #F1F5F9 | 6,12:1 | 4,5:1 | PASS |
| Borde de campos, chips y tarjetas sobre el fondo | #94A3B8 / #0F172A | 6,96:1 | 3:1 | PASS |
| Borde de campos y chips sobre tarjetas | #94A3B8 / #1E293B | 5,71:1 | 3:1 | PASS |
| Botón principal sobre el fondo | #60A5FA / #0F172A | 7,02:1 | 3:1 | PASS |
| Indicador de la barra de opciones | #60A5FA / #1E293B | 5,75:1 | 3:1 | PASS |
| Icono de Disponible | #4ADE80 / #052E16 | 8,55:1 | 3:1 | PASS |
| Icono de Reservado | #FBBF24 / #451A03 | 8,97:1 | 3:1 | PASS |
| Icono de error en los avisos | #F87171 / #450A0A | 5,84:1 | 3:1 | PASS |
| Icono de las fotos de ejemplo | #CBD5E1 / #334155 | 6,97:1 | 3:1 | PASS |

Si cambiáis algún color, solo hay que tocar `lib/tema/colores.dart` y volver a pasar el test.

## Notas

- **Las etiquetas de la barra de opciones y el título de arriba solo crecen hasta 1,3 veces** con la letra al 200 %. No lo hemos puesto nosotros: es como vienen esos componentes en Flutter. TalkBack lee igualmente el nombre completo y en la barra se ve en grande con una pulsación larga. Todo lo demás crece entero.
- **Simulado:** la cámara, el envío del código y que la sesión y los ajustes se queden guardados. Si hiciera falta que lo escrito sobreviva a que Android cierre la aplicación (RNF7), se puede usar la restauración de estado de Flutter, sin base de datos.
- **Pendiente para la semana 5:** la prueba con TalkBack en un móvil real y las capturas con la letra grande en el emulador.
