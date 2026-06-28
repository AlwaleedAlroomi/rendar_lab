import 'package:flutter/material.dart';
import 'package:rendar_lab/models/drawing_path_model.dart';
import 'package:rendar_lab/widgets/drawing_canvas.dart';

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});

  @override
  State<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<DrawingPathModel> pointPath = [];
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
  late Color _selectedColor;
  double strokeWidth = 3.0;
  final bool _isEraser = false;
  final double eraserRadius = 20.0;

  @override
  void initState() {
    super.initState();
    _selectedColor = colors.first;
    _controller.text = strokeWidth.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanStart: (details) {
          if (!_isEraser) {
            setState(() {
              currentPath.add(
                Offset(details.localPosition.dx, details.localPosition.dy),
              );
            });
          }
        },
        onPanUpdate: (details) {
          if (!_isEraser) {
            setState(() {
              currentPath.add(
                Offset(details.localPosition.dx, details.localPosition.dy),
              );
            });
          } else {
            // TODO: implement eraser funciton
            final fingerPosition = Offset(
              details.localPosition.dx,
              details.localPosition.dy,
            );
            pointPath.map((e) {
              if (fingerPosition.distance < eraserRadius) {}
            });
          }
        },
        onPanEnd: (details) {
          if (!_isEraser) {
            setState(() {
              pointPath.add(
                DrawingPathModel(
                  points: List.from(currentPath),
                  color: _selectedColor,
                  strokeWidth: strokeWidth,
                ),
              );
              currentPath.clear();
            });
          }
        },
        child: CustomPaint(
          size: Size(double.infinity, double.infinity),
          painter: DrawingCanvas(
            paths: List.from(pointPath),
            currentPaint: List.from(currentPath),
            selectedColor: _selectedColor,
            currentStrokeWidth: strokeWidth,
          ),
        ),
      ),
      bottomSheet: SizedBox(
        width: double.infinity,
        height: 50,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: colors.length + 1,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = colors[index];
                });
              },
              child: index == colors.length
                  ? SizedBox(
                      width: 250,
                      height: 50,
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                setState(() {
                                  strokeWidth =
                                      double.tryParse(value) ?? strokeWidth;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (pointPath.isNotEmpty) {
                                    _lastPoint = pointPath.last;
                                    pointPath.removeLast();
                                  }
                                });
                              },
                              icon: Icon(Icons.undo),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (_lastPoint != null) {
                                    pointPath.add(_lastPoint!);
                                  }
                                });
                              },
                              icon: Icon(Icons.redo),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (pointPath.isNotEmpty) {
                                    pointPath.clear();
                                  }
                                });
                              },
                              icon: Icon(Icons.clear),
                            ),
                          ),
                          Expanded(
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  if (_isEraser) {
                                    pointPath.clear();
                                  }
                                });
                              },
                              icon: Icon(Icons.edit_off),
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: colors[index],
                          shape: BoxShape.circle,
                          border: _selectedColor == colors[index]
                              ? BoxBorder.all(color: Colors.amber, width: 3)
                              : null,
                        ),
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
