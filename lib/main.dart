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
}
