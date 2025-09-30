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

  void adivinarLetra(String letra) {
    if (letrasUsadas.contains(letra)) return;

    setState(() {
      letrasUsadas.add(letra);
      if (!palabra.contains(letra)) {
        errores++;
      }
    });

    // Verificar después de actualizar el estado si el juego terminó
    if ((gano() || perdio()) && !dialogoMostrado) {
      _mostrarDialogo();
    }
  }

  // Mostrar la palabra mientras se vaya adivinando
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

  // Función para verificar si el usuario ganó el juego
  bool gano() {
    for (int i = 0; i < palabra.length; i++) {
      if (!letrasUsadas.contains(palabra[i])) {
        return false;
      }
    }
    return true;
  }

  // Función para verificar si el usuario perdió
  bool perdio() {
    return errores >= maxErrores;
  }

  // Dibujar el ahorcado dado el número de errores
  Widget dibujarAhorcado() {
    return SizedBox(
      height: 240,
      width: 170,
      child: CustomPaint(
        painter: AhorcadoPainter(errores),
      ),
    );
  }

  // Mostrar diálogo de resumen si terminó la partida
  void _mostrarDialogo() {
    // Marcar que el diálogo se está mostrando
    setState(() {
      dialogoMostrado = true;
    });
    
    // Incrementar partidas jugadas
    partidasJugadas++;

    showDialog(
      context: context,
      barrierDismissible: false, // Evitar que se cierre tocando fuera
      builder: (context) => AlertDialog(
        title: Text(gano() ? '¡Ganaste!' : '¡Perdiste!'),
        content: Text('La palabra era: $palabra'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              empezarJuego();
            },
            child: Text('Jugar de nuevo'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('El Ahorcado')
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Contador de partidas jugadas
            Padding(
              padding: EdgeInsets.all(1.0),
              child: Center(
                child: Text(
                  'Partidas jugadas: $partidasJugadas',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // Dibujo del ahorcado
            dibujarAhorcado(),
            // Palabra oculta
            Text(
              mostrarPalabra(),
              style: TextStyle(fontSize: 30),
            ),
            // Contador de errores
            Text(
              'Errores: $errores/$maxErrores',
              style: TextStyle(
                fontSize: 18,
                color: errores >= maxErrores ? Colors.red : Colors.black,
              ),
            ),
            
            SizedBox(height: 20),
            
            // Teclado simple
            Wrap(
              children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((letra) {
                return Padding(
                  padding: EdgeInsets.all(2),
                  child: ElevatedButton(
                    onPressed: letrasUsadas.contains(letra) || gano() || perdio() 
                        ? null 
                        : () => adivinarLetra(letra),
                    child: Text(letra),
                  ),
                );
              }).toList(),
            ),
            
            SizedBox(height: 20),
            
            // Botón de reinicio
            ElevatedButton(
              onPressed: () {
                setState(() {
                  empezarJuego();
                });
              },
              child: Text('Nuevo Juego'),
            ),
          ],
        ),
      ),
    );
  }
}


class AhorcadoPainter extends CustomPainter {
  final int errores;
  
  AhorcadoPainter(this.errores);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.brown
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    // Dibujo del ahorcado
    // Base
    canvas.drawLine(Offset(20, size.height - 20), Offset(100, size.height - 20), paint);
    // Poste vertical
    canvas.drawLine(Offset(60, size.height - 20), Offset(60, 40), paint);
    // Poste superior
    canvas.drawLine(Offset(60, 40), Offset(120, 40), paint);
    // Cuerda
    canvas.drawLine(Offset(120, 40), Offset(120, 60), paint);
    // Muñeco
    // Atributos generales del muñeco
    final paintMuneco = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    // Empezar a dibujar el muñeco si se cometieron errores
    if (errores >= 1) {
      // Cabeza
      canvas.drawCircle(Offset(120, 75), 15, paintMuneco);
    }
    if (errores >= 2) {
      // Cuerpo
      canvas.drawLine(Offset(120, 90), Offset(120, 150), paintMuneco);
    }
    if (errores >= 3) {
      // Brazo izquierdo
      canvas.drawLine(Offset(120, 110), Offset(100, 130), paintMuneco);
    }
    if (errores >= 4) {
      // Brazo derecho
      canvas.drawLine(Offset(120, 110), Offset(140, 130), paintMuneco);
    }
    if (errores >= 5) {
      // Pierna izquierda
      canvas.drawLine(Offset(120, 150), Offset(100, 180), paintMuneco);
    }
    if (errores >= 6) {
      // Pierna derecha
      canvas.drawLine(Offset(120, 150), Offset(140, 180), paintMuneco);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
