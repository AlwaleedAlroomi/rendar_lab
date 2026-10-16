import 'package:flutter/material.dart';
import 'package:rendar_lab/models/drawing_path_model.dart';

class CanvasController extends ChangeNotifier {
  List<DrawingPathModel> pointPath = [];
  late DrawingPathModel? _lastPoint;
  final List<Offset> currentPath = [];
  final List<Color> colors = [
    Colors.black,
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.orange,
    Colors.deepPurple,
  ];

  Color selectedColor = Colors.black;
  double strokeWidth = 3.0;
  bool isEraser = false;
  final double eraserRadius = 20.0;

  void startStroke(Offset position) {
    if (!isEraser) {
      currentPath.add(position);
      notifyListeners();
    }
  }

  void updateStroke(Offset position) {
    if (!isEraser) {
      currentPath.add(position);
      notifyListeners();
    } else {
      pointPath = pointPath.where((stroke) {
        return stroke.points.every((point) {
          return (point - position).distance > eraserRadius;
        });
      }).toList();
      notifyListeners();
    }
  }

  void endStroke() {
    if (!isEraser) {
      pointPath.add(
        DrawingPathModel(
          points: List.from(currentPath),
          color: selectedColor,
          strokeWidth: strokeWidth,
        ),
      );
      currentPath.clear();
      notifyListeners();
    }
  }

  void undo() {
    if (pointPath.isNotEmpty) {
      _lastPoint = pointPath.last;
      pointPath.removeLast();
      notifyListeners();
    }
  }

  void redo() {
    if (_lastPoint != null) {
      pointPath.add(_lastPoint!);
      notifyListeners();
    }
  }

  void clearCanvas() {
    pointPath.clear();
    notifyListeners();
  }

  void toggleEraser() {
    isEraser = !isEraser;
    notifyListeners();
  }

  void setColor(Color color) {
    selectedColor = color;
    if (isEraser) {
      isEraser = !isEraser;
    }
    notifyListeners();
  }

  void setStrokeWidth(double width) {
    strokeWidth = width;
    notifyListeners();
  }
}
