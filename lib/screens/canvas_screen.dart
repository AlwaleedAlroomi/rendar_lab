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
                color: _selectedColor,
                strokeWidth: strokeWidth,
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
            selectedColor: _selectedColor,
            currentStrokeWidth: strokeWidth,
          ),
          child: SizedBox.expand(),
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
                      width: 30,
                      height: 30,
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            // _controller.text = value;
                            strokeWidth = double.tryParse(value) ?? strokeWidth;
                          });
                        },
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
