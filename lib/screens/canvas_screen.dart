import 'package:flutter/material.dart';
import 'package:rendar_lab/controller/canvas_controller.dart';
import 'package:rendar_lab/models/drawing_path_model.dart';
import 'package:rendar_lab/widgets/drawing_canvas.dart';

class CanvasScreen extends StatefulWidget {
  const CanvasScreen({super.key});

  @override
  State<CanvasScreen> createState() => _CanvasScreenState();
}

class _CanvasScreenState extends State<CanvasScreen> {
  final CanvasController _controller = CanvasController();
  final TextEditingController _textController = TextEditingController();
  List<DrawingPathModel> notHit = [];

  @override
  void initState() {
    super.initState();
    _textController.text = _controller.strokeWidth.toString();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, child) {
        return Scaffold(
          body: InteractiveViewer(
            boundaryMargin: const .all(20.0),
            minScale: 0.1,
            maxScale: 2.0,
            child: GestureDetector(
              onPanStart: (details) {
                _controller.startStroke(details.localPosition);
              },
              onPanUpdate: (details) {
                _controller.updateStroke(details.localPosition);
              },
              onPanEnd: (details) {
                _controller.endStroke();
              },
              child: CustomPaint(
                size: Size(double.infinity, double.infinity),
                painter: DrawingCanvas(
                  paths: List.from(_controller.pointPath),
                  currentPaint: List.from(_controller.currentPath),
                  selectedColor: _controller.selectedColor,
                  currentStrokeWidth: _controller.strokeWidth,
                ),
              ),
            ),
          ),
          bottomSheet: SizedBox(
            width: double.infinity,
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _controller.colors.length + 1,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    _controller.setColor(_controller.colors[index]);
                  },
                  child: index == _controller.colors.length
                      ? SizedBox(
                          width: 400,
                          height: 50,
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _textController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    _controller.setStrokeWidth(
                                      double.tryParse(value) ??
                                          _controller.strokeWidth,
                                    );
                                  },
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    _controller.undo();
                                  },
                                  icon: Icon(Icons.undo),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    _controller.redo();
                                  },
                                  icon: Icon(Icons.redo),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    _controller.clearCanvas();
                                  },
                                  icon: Icon(Icons.clear),
                                ),
                              ),
                              Expanded(
                                child: IconButton(
                                  onPressed: () {
                                    _controller.toggleEraser();
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
                              color: _controller.colors[index],
                              shape: BoxShape.circle,
                              border:
                                  (_controller.selectedColor ==
                                          _controller.colors[index] &&
                                      _controller.isEraser == false)
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
      },
    );
  }
}
