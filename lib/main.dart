import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AhorcadoPage(),
    );
  }
}

class AhorcadoPage extends StatefulWidget {
  @override
  AhorcadoPageState createState() => AhorcadoPageState();
}

// Estado de la página del Ahorcado
class AhorcadoPageState extends State<AhorcadoPage> {
  List<String> palabras = ['INTERNET', 'INFORMACION', 'JUEGO', 'CODIGO', 'MOVIL', 'PROGRAMA', 'COMPUTADORA'];
  String palabra = '';
  List<String> letrasUsadas = [];
  int errores = 0;
  int maxErrores = 6;
  int ultimaPalabraIndex = -1;
  int partidasJugadas = 0;
  bool dialogoMostrado = false;

  @override
  void initState() {
    super.initState();
    empezarJuego();
  }

  void empezarJuego() {
    setState(() {
      int nuevaPalabraIndex;
      do {
        nuevaPalabraIndex = DateTime.now().millisecondsSinceEpoch % palabras.length;
      } while (nuevaPalabraIndex == ultimaPalabraIndex && palabras.length > 1);
      palabra = palabras[nuevaPalabraIndex];
      ultimaPalabraIndex = nuevaPalabraIndex;
      letrasUsadas = [];
      errores = 0;
      dialogoMostrado = false; // Resetear al empezar nuevo juego
    });
  }

  void adivinarLetra(String letra) {
    // Retornar si se adivinó una letra
    if (letrasUsadas.contains(letra)) return;
    // De lo contrario, actualizar errores o terminar
    setState(() {
      // Incrementar los errores si se cometió uno
      letrasUsadas.add(letra);
      if (!palabra.contains(letra)) {
        errores++;
      }
      // Mostrar mensaje de fin si el juego terminó
      if ((gano() || perdio()) && !dialogoMostrado) {
        partidasJugadas++;
        dialogoMostrado = true;
      }
    });
  }

  // Mostrar la palabra mientras se va adivinando
  String mostrarPalabra() {
    String resultado = '';
    for (int i = 0; i < palabra.length; i++) {
      String letra = palabra[i];
      if (letrasUsadas.contains(letra)) {
        resultado += '$letra ';
      } else {
        resultado += '_ ';
      }
    }
    return resultado;
  }

  // Función para evaluar si el usuario ganó
  bool gano() {
    for (int i = 0; i < palabra.length; i++) {
      if (!letrasUsadas.contains(palabra[i])) {
        return false; // No ha ganado si una letra no es correcta
      }
    }
    return true;
  }

  // Función para evaluar si el usuario perdió
  bool perdio() {
    return errores >= maxErrores; // Pierde si los errores superan el máximo
  }

  // Contenedor del dibujo principal
  Widget dibujarAhorcado() {
    return Container(
      height: 200,
      width: 150,
      child: CustomPaint(
        painter: AhorcadoPainter(errores),
      ),
    );
  }
}
