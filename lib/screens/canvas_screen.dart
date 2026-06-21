import 'package:flutter/material.dart';
import 'package:rendar_lab/widgets/drawing_canvas.dart';

class CanvasScreen extends StatelessWidget {
  const CanvasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomPaint(
        size: Size(double.infinity, double.infinity),
        painter: DrawingCanvas(),
        child: SizedBox.expand(),
      ),
    );
  }
}
