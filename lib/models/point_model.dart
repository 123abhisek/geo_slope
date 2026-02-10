import 'package:flutter/material.dart';

enum PointType {
  intersection,
  root,
  yIntercept,
  minimum,
  maximum,
}

class PointModel {
  final double x;
  final double y;
  final String label;
  final PointType type;

  PointModel({
    required this.x,
    required this.y,
    required this.label,
    required this.type,
  });

  Color get color {
    switch (type) {
      case PointType.intersection:
        return Colors.red;
      case PointType.root:
        return Colors.blue;
      case PointType.yIntercept:
        return Colors.green;
      case PointType.minimum:
        return Colors.orange;
      case PointType.maximum:
        return Colors.purple;
    }
  }

  IconData get icon {
    switch (type) {
      case PointType.intersection:
        return Icons.close;
      case PointType.root:
        return Icons.circle;
      case PointType.yIntercept:
        return Icons.circle_outlined;
      case PointType.minimum:
        return Icons.arrow_downward;
      case PointType.maximum:
        return Icons.arrow_upward;
    }
  }
}
