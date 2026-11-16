import 'package:flutter/material.dart';

import 'modelos.dart';

// Datos inventados para probar la aplicación sin base de datos. Salen de la
// memoria: la cámara de Laura de los wireframes, los libros de Finanzas que
// busca María, la tableta gráfica que presta José, el libro de la consigna 2
// de la prueba de primer clic...

List<Anuncio> anunciosDePrueba() => [
      Anuncio(
        id: 'a1',
        nombre: 'Cámara réflex',
        paraQueSirve: 'Para hacer fotos y vídeo en las prácticas de Comunicación Audiovisual.',
        descripcion: 'Canon EOS 2000D con objetivo 18-55 mm, batería, cargador y tarjeta de 32 GB. Funciona perfectamente.',
        categoria: Categoria.fotografia,
        tipo: TipoCesion.prestamo,
        fechas: 'De jueves a viernes',
        entrega: 'Biblioteca del campus',
        dueno: 'Laura Gómez',
        fotos: const [
          Foto(descripcion: 'Cámara negra con el objetivo puesto, vista de frente.'),
          Foto(descripcion: 'Parte de atrás de la cámara, con la pantalla y los botones.', icono: Icons.camera_rear_outlined),
        ],
      ),
      Anuncio(
        id: 'a2',
        nombre: 'Contabilidad financiera (libro)',
        paraQueSirve: 'Manual de Contabilidad Financiera I, de primero del Grado en Finanzas.',
        descripcion: 'Edición de 2024, con algunos subrayados a lápiz. No le falta ninguna página.',
        categoria: Categoria.libros,
        tipo: TipoCesion.prestamo,
        fechas: 'Todo el cuatrimestre',
        entrega: 'Biblioteca de la Facultad de Económicas',
        dueno: 'Ana Martín',
        fotos: const [
          Foto(descripcion: 'Portada azul del libro con el título en letras blancas.', icono: Icons.menu_book_outlined),
        ],
      ),
      Anuncio(
        id: 'a3',
        nombre: 'Foco LED con trípode',
        paraQueSirve: 'Luz continua para grabar vídeo o hacer fotos en interior.',
        descripcion: 'Foco de 60 W con regulador de intensidad y trípode que llega a 2 metros.',
        categoria: Categoria.fotografia,
        tipo: TipoCesion.alquiler,
        precio: 3,
        fechas: 'Fines de semana',
        entrega: 'Facultad de Comunicación',
        dueno: 'Pablo Ruiz',
        fotos: const [
          Foto(descripcion: 'Foco cuadrado de luz blanca montado en un trípode negro.', icono: Icons.light_outlined),
        ],
      ),
      Anuncio(
        id: 'a4',
        nombre: 'Calculadora científica',
        paraQueSirve: 'Para los exámenes de Matemáticas, Física y Estadística (es un modelo permitido).',
        descripcion: 'Casio fx-570SP X II con su tapa. Pilas nuevas.',
        categoria: Categoria.calculadoras,
        tipo: TipoCesion.alquiler,
        precio: 1,
        fechas: 'Semanas de exámenes',
        entrega: 'Cafetería del aulario',
        dueno: 'Diego Fernández',
        fotos: const [
          Foto(descripcion: 'Calculadora gris con la pantalla grande y la tapa negra al lado.', icono: Icons.calculate_outlined),
        ],
      ),
      Anuncio(
        id: 'a5',
        nombre: 'Micrófono de corbata',
        paraQueSirve: 'Para grabar la voz con buen sonido en entrevistas y vídeos.',
        descripcion: 'Micrófono de solapa con 6 metros de cable y adaptador para el móvil.',
        categoria: Categoria.fotografia,
        tipo: TipoCesion.prestamo,
        fechas: 'Entre semana',
        entrega: 'Facultad de Comunicación',
        dueno: 'Lucía Prieto',
        estado: EstadoMaterial.reservado,
        fotos: const [
          Foto(descripcion: 'Micrófono pequeño negro con una pinza y el cable enrollado.', icono: Icons.mic_none_outlined),
        ],
      ),
      Anuncio(
        id: 'a6',
        nombre: 'Apuntes de Finanzas I',
        paraQueSirve: 'Resúmenes de todos los temas para preparar el examen final.',
        descripcion: 'Apuntes a ordenador del curso pasado, encuadernados con espiral.',
        categoria: Categoria.libros,
        tipo: TipoCesion.regalo,
        fechas: 'Cuando quieras',
        entrega: 'Facultad de Económicas',
        dueno: 'Sergio Alonso',
        fotos: const [
          Foto(descripcion: 'Cuaderno de apuntes encuadernado con espiral y tapa transparente.', icono: Icons.description_outlined),
        ],
      ),
      Anuncio(
        id: 'a7',
        nombre: 'Bata de laboratorio',
        paraQueSirve: 'Obligatoria en las prácticas de laboratorio de Química y Biología.',
        descripcion: 'Talla M, blanca y de algodón. Está lavada y en buen estado.',
        categoria: Categoria.otros,
        tipo: TipoCesion.regalo,
        fechas: 'Cuando quieras',
        entrega: 'Facultad de Biología',
        dueno: 'Irene Castro',
        estado: EstadoMaterial.reservado,
        fotos: const [
          Foto(descripcion: 'Bata blanca de manga larga colgada en una percha.', icono: Icons.checkroom_outlined),
        ],
      ),
      Anuncio(
        id: 'a8',
        nombre: 'Estadística para economistas (libro)',
        paraQueSirve: 'Manual de la asignatura de Estadística de segundo de Finanzas.',
        descripcion: 'Libro con ejercicios resueltos al final de cada tema.',
        categoria: Categoria.libros,
        tipo: TipoCesion.prestamo,
        fechas: 'Dos semanas',
        entrega: 'Biblioteca de la Facultad de Económicas',
        dueno: 'Ana Martín',
        estado: EstadoMaterial.reservado,
        fotos: const [
          Foto(descripcion: 'Libro de tapa verde con gráficos de barras en la portada.', icono: Icons.menu_book_outlined),
        ],
      ),
      // Anuncios publicados por la persona que usa la aplicación (P9).
      Anuncio(
        id: 'm1',
        nombre: 'Tableta gráfica',
        paraQueSirve: 'Para dibujar o retocar fotos en el ordenador con un lápiz.',
        descripcion: 'Wacom Intuos pequeña, con su lápiz y el cable USB.',
        categoria: Categoria.electronica,
        tipo: TipoCesion.prestamo,
        fechas: 'Por las tardes',
        entrega: 'Facultad de Comunicación',
        dueno: 'Tú',
        esMio: true,
        fotos: const [
          Foto(descripcion: 'Tableta negra rectangular con el lápiz encima.', icono: Icons.draw_outlined),
        ],
      ),
      Anuncio(
        id: 'm2',
        nombre: 'Trípode de fotografía',
        paraQueSirve: 'Para que la cámara o el móvil no se muevan al grabar.',
        descripcion: 'Trípode de aluminio de 1,5 metros con funda.',
        categoria: Categoria.fotografia,
        tipo: TipoCesion.alquiler,
        precio: 2,
        fechas: 'Fines de semana',
        entrega: 'Biblioteca del campus',
        dueno: 'Tú',
        esMio: true,
        estado: EstadoMaterial.reservado,
        fotos: const [
          Foto(descripcion: 'Trípode plegado dentro de una funda negra.', icono: Icons.videocam_outlined),
        ],
      ),
    ];

List<Reserva> reservasDePrueba(Anuncio Function(String id) anuncio) => [
      // El libro de la consigna 2: "¿hasta qué día tienes para devolverlo?".
      Reserva(id: 'r1', anuncio: anuncio('a8'), devolucion: 'Antes del viernes 21 de noviembre'),
    ];

List<Conversacion> conversacionesDePrueba(Anuncio Function(String id) anuncio) => [
      Conversacion(
        id: 'c1',
        con: 'Ana Martín',
        anuncio: anuncio('a8'),
        mensajes: [
          const Mensaje.aviso('Reserva confirmada: Estadística para economistas (libro).'),
          const Mensaje(texto: '¡Hola! Te lo dejo mañana en la biblioteca de Económicas.', esMio: false),
          const Mensaje(texto: 'Genial, gracias. Te lo devuelvo antes del viernes 21.', esMio: true),
        ],
      ),
      Conversacion(
        id: 'c2',
        con: 'Marta Díez',
        anuncio: anuncio('m2'),
        mensajes: [
          const Mensaje.aviso('Marta Díez ha reservado tu Trípode de fotografía.'),
          const Mensaje(texto: 'Hola, ¿te viene bien quedar el sábado por la mañana?', esMio: false),
        ],
      ),
    ];
