

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/line_provider.dart';
import '../models/line_model.dart';
import '../models/point_model.dart';

class GraphCanvas extends StatefulWidget {
  const GraphCanvas({super.key});

  @override
  State<GraphCanvas> createState() => _GraphCanvasState();
}

class _GraphCanvasState extends State<GraphCanvas> {
  double _scale = 40.0;
  Offset _offset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    return Consumer<LineProvider>(
      builder: (context, provider, _) {
        if (provider.lines.isEmpty) {
          return Container(
            color: Theme.of(context).colorScheme.surface,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.show_chart,
                    size: 64,
                    color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Add equations to see the graph',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Container(
          color: Theme.of(context).colorScheme.surface,
          child: ClipRect(
            child: GestureDetector(
              onScaleUpdate: (details) {
                setState(() {
                  _scale *= details.scale;
                  _scale = _scale.clamp(20.0, 100.0);
                  _offset += details.focalPointDelta;
                });
              },
              child: CustomPaint(
                painter: GraphPainter(
                  lines: provider.visibleLines,
                  scale: _scale,
                  offset: _offset,
                  showGrid: provider.showGrid,
                  showSpecialPoints: provider.showSpecialPoints,
                  specialPoints: provider.specialPoints,
                ),
                size: Size.infinite,
              ),
            ),
          ),
        );
      },
    );
  }
}

class GraphPainter extends CustomPainter {
  final List<LineModel> lines;
  final double scale;
  final Offset offset;
  final bool showGrid;
  final bool showSpecialPoints;
  final List<PointModel> specialPoints;

  GraphPainter({
    required this.lines,
    required this.scale,
    required this.offset,
    required this.showGrid,
    required this.showSpecialPoints,
    required this.specialPoints,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Clip to bounds
    canvas.clipRect(Rect.fromLTWH(0, 0, size.width, size.height));
    
    final center = Offset(size.width / 2, size.height / 2) + offset;

    // Draw grid (optional)
    if (showGrid) {
      _drawGrid(canvas, size, center);
    }

    // Draw axes
    _drawAxes(canvas, size, center);

    // Draw lines
    for (var line in lines) {
      _drawLine(canvas, size, center, line);
    }

    // Draw special points (optional)
    if (showSpecialPoints && specialPoints.isNotEmpty) {
      _drawSpecialPoints(canvas, size, center, specialPoints);
    }

    // Draw labels
    _drawLabels(canvas, size, center);
  }

  void _drawGrid(Canvas canvas, Size size, Offset center) {
    final gridPaint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 0.5;

    // Vertical grid lines
    for (double x = center.dx % scale; x < size.width; x += scale) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }

    // Horizontal grid lines
    for (double y = center.dy % scale; y < size.height; y += scale) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawAxes(Canvas canvas, Size size, Offset center) {
    final axisPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2;

    // Only draw axes if they're visible
    if (center.dy >= 0 && center.dy <= size.height) {
      canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), axisPaint);
    }

    if (center.dx >= 0 && center.dx <= size.width) {
      canvas.drawLine(Offset(center.dx, 0), Offset(center.dx, size.height), axisPaint);
    }

    // Arrow heads
    final arrowPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    // X-axis arrow (if visible)
    if (center.dy >= 0 && center.dy <= size.height) {
      final xArrowPath = Path()
        ..moveTo(size.width - 10, center.dy - 5)
        ..lineTo(size.width, center.dy)
        ..lineTo(size.width - 10, center.dy + 5)
        ..close();
      canvas.drawPath(xArrowPath, arrowPaint);
    }

    // Y-axis arrow (if visible)
    if (center.dx >= 0 && center.dx <= size.width) {
      final yArrowPath = Path()
        ..moveTo(center.dx - 5, 10)
        ..lineTo(center.dx, 0)
        ..lineTo(center.dx + 5, 10)
        ..close();
      canvas.drawPath(yArrowPath, arrowPaint);
    }
  }

  void _drawLine(Canvas canvas, Size size, Offset center, LineModel line) {
    final linePaint = Paint()
      ..color = line.color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path();
    bool firstPoint = true;

    // Draw line from left to right of screen
    for (double screenX = 0; screenX <= size.width; screenX += 5) {
      final graphX = (screenX - center.dx) / scale;
      final graphY = line.slope * graphX + line.intercept;
      final screenY = center.dy - (graphY * scale);

      if (screenY >= -100 && screenY <= size.height + 100) {
        if (firstPoint) {
          path.moveTo(screenX, screenY);
          firstPoint = false;
        } else {
          path.lineTo(screenX, screenY);
        }
      }
    }

    canvas.drawPath(path, linePaint);

    // Draw line label
    final labelPainter = TextPainter(
      text: TextSpan(
        text: line.name,
        style: TextStyle(
          color: line.color,
          fontWeight: FontWeight.bold,
          fontSize: 16,
          backgroundColor: Colors.white.withOpacity(0.7),
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    labelPainter.layout();

    // Position label at the right edge
    final graphX = (size.width - 30 - center.dx) / scale;
    final graphY = line.slope * graphX + line.intercept;
    final labelY = center.dy - (graphY * scale);

    if (labelY >= 20 && labelY <= size.height - 20) {
      labelPainter.paint(canvas, Offset(size.width - 35, labelY - 10));
    }
  }

  void _drawSpecialPoints(Canvas canvas, Size size, Offset center, List<PointModel> points) {
    for (var point in points) {
      final screenX = center.dx + (point.x * scale);
      final screenY = center.dy - (point.y * scale);
      
      // Only draw if point is visible
      if (screenX < -50 || screenX > size.width + 50 || 
          screenY < -50 || screenY > size.height + 50) {
        continue;
      }
      
      // Draw point
      final pointPaint = Paint()
        ..color = point.color
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(screenX, screenY), 6, pointPaint);
      
      // Draw border
      final borderPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;
      
      canvas.drawCircle(Offset(screenX, screenY), 6, borderPaint);
      
      // Draw label
      final labelPainter = TextPainter(
        text: TextSpan(
          text: '${point.label}\n(${point.x.toStringAsFixed(1)}, ${point.y.toStringAsFixed(1)})',
          style: TextStyle(
            color: point.color,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.white.withOpacity(0.9),
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout();
      
      // Position label to avoid clipping
      double labelX = screenX + 10;
      double labelY = screenY - 10;
      
      if (labelX + labelPainter.width > size.width) {
        labelX = screenX - labelPainter.width - 10;
      }
      if (labelY < 0) {
        labelY = screenY + 10;
      }
      
      labelPainter.paint(canvas, Offset(labelX, labelY));
    }
  }

  void _drawLabels(Canvas canvas, Size size, Offset center) {
    final textStyle = TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      backgroundColor: Colors.white.withOpacity(0.7),
    );

    // X label (if axis is visible)
    if (center.dy >= 20 && center.dy <= size.height - 20) {
      final xLabel = TextPainter(
        text: TextSpan(text: 'x', style: textStyle),
        textDirection: TextDirection.ltr,
      );
      xLabel.layout();
      xLabel.paint(canvas, Offset(size.width - 25, center.dy + 10));
    }

    // Y label (if axis is visible)
    if (center.dx >= 20 && center.dx <= size.width - 20) {
      final yLabel = TextPainter(
        text: TextSpan(text: 'y', style: textStyle),
        textDirection: TextDirection.ltr,
      );
      yLabel.layout();
      yLabel.paint(canvas, Offset(center.dx + 10, 15));
    }
  }

  @override
  bool shouldRepaint(GraphPainter oldDelegate) {
    return oldDelegate.lines != lines ||
        oldDelegate.scale != scale ||
        oldDelegate.offset != offset ||
        oldDelegate.showGrid != showGrid ||
        oldDelegate.showSpecialPoints != showSpecialPoints ||
        oldDelegate.specialPoints != specialPoints;
  }
}
