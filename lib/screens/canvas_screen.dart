import 'package:flutter/material.dart';
import 'package:rendar_lab/models/drawing_path_model.dart';
import 'package:rendar_lab/widgets/drawing_canvas.dart';

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});

  @override
  State<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  final List<DrawingPathModel> pointPath = [];
  final List<Offset> currentPath = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanStart: (details) {
          setState(() {
            currentPath.add(
              Offset(details.localPosition.dx, details.localPosition.dy),
            );
          });
        },
        onPanUpdate: (details) {
          setState(() {
            currentPath.add(
              Offset(details.localPosition.dx, details.localPosition.dy),
            );
          });
        },
        onPanEnd: (details) {
          setState(() {
            pointPath.add(
              DrawingPathModel(
                points: List.from(currentPath),
                color: Colors.black,
              ),
            );
            currentPath.clear();
          });
        },
        child: CustomPaint(
          size: Size(double.infinity, double.infinity),
          painter: DrawingCanvas(
            paths: pointPath,
            currentPaint: List.from(currentPath),
          ),
          child: SizedBox.expand(),
        ),
      ),
    );
  }
}
