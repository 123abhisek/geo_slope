
import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/line_model.dart';
import '../models/relation_model.dart';
import '../models/point_model.dart';
import '../utils/math_utils.dart';
import '../utils/app_theme.dart';

class LineProvider with ChangeNotifier {
  final List<LineModel> _lines = [];
  final List<PointModel> _specialPoints = [];
  int _lineCounter = 0;
  
  double _aValue = 1.0;
  double _bValue = 1.0;
  double _cValue = 0.0;
  double _dValue = 0.0;
  
  bool _showGrid = true;
  bool _showSpecialPoints = true;
  
  // Getters
  List<LineModel> get lines => _lines;
  List<LineModel> get visibleLines => _lines.where((l) => l.isVisible).toList();
  List<PointModel> get specialPoints => _specialPoints;
  
  double get aValue => _aValue;
  double get bValue => _bValue;
  double get cValue => _cValue;
  double get dValue => _dValue;
  bool get showGrid => _showGrid;
  bool get showSpecialPoints => _showSpecialPoints;

  // Parse and add equation
  void addEquation(String equation) {
    equation = equation.toLowerCase().trim();
    
    // Remove spaces
    equation = equation.replaceAll(' ', '');
    
    // Check if it starts with y=
    if (!equation.startsWith('y=')) {
      throw Exception('Equation must start with y=');
    }
    
    // Extract right side
    String rightSide = equation.substring(2);
    
    // Try to parse as linear equation y = mx + c
    final linearMatch = RegExp(r'^([+-]?\d*\.?\d*)?\*?x([+-]\d+\.?\d*)?$').firstMatch(rightSide);
    
    if (linearMatch != null) {
      // Parse slope
      String slopeStr = linearMatch.group(1) ?? '1';
      if (slopeStr == '' || slopeStr == '+') slopeStr = '1';
      if (slopeStr == '-') slopeStr = '-1';
      double slope = double.parse(slopeStr);
      
      // Parse intercept
      String interceptStr = linearMatch.group(2) ?? '0';
      double intercept = double.parse(interceptStr);
      
      addLine(slope, intercept);
    } else {
      // Non-linear equation (store as function)
      addFunctionLine(rightSide);
    }
  }

  // Add standard line
  void addLine(double slope, double intercept) {
    final colorIndex = _lineCounter % AppTheme.lineColors.length;
    _lines.add(LineModel(
      name: String.fromCharCode(65 + _lineCounter),
      slope: slope,
      intercept: intercept,
      color: AppTheme.lineColors[colorIndex],
    ));
    _lineCounter++;
    _findSpecialPoints();
    notifyListeners();
  }

  // Add function-based line (sin, cos, etc.)
  void addFunctionLine(String function) {
    final colorIndex = _lineCounter % AppTheme.lineColors.length;
    _lines.add(LineModel(
      name: String.fromCharCode(65 + _lineCounter),
      slope: 0,
      intercept: 0,
      color: AppTheme.lineColors[colorIndex],
      isFunction: true,
      functionExpression: function,
    ));
    _lineCounter++;
    notifyListeners();
  }

  // Evaluate function at x
  double evaluateFunction(String function, double x) {
    try {
      // Replace x with value
      String expression = function.replaceAll('x', '($x)');
      
      // Replace math functions
      expression = expression.replaceAll('sin(', 'math.sin(');
      expression = expression.replaceAll('cos(', 'math.cos(');
      expression = expression.replaceAll('tan(', 'math.tan(');
      expression = expression.replaceAll('sqrt(', 'math.sqrt(');
      expression = expression.replaceAll('log(', 'math.log(');
      expression = expression.replaceAll('ln(', 'math.log(');
      expression = expression.replaceAll('pi', '${math.pi}');
      expression = expression.replaceAll('e', '${math.e}');
      expression = expression.replaceAll('^', ',');
      
      // This is simplified - in production use a proper expression parser
      // For now, return 0 for complex functions
      return 0;
    } catch (e) {
      return 0;
    }
  }

  void removeLine(int index) {
    _lines.removeAt(index);
    _findSpecialPoints();
    notifyListeners();
  }

  void toggleLineVisibility(int index) {
    _lines[index] = _lines[index].copyWith(
      isVisible: !_lines[index].isVisible,
    );
    notifyListeners();
  }

  void clearAllLines() {
    _lines.clear();
    _specialPoints.clear();
    _lineCounter = 0;
    notifyListeners();
  }

  void updateSliders({double? a, double? b, double? c, double? d}) {
    if (a != null) _aValue = a;
    if (b != null) _bValue = b;
    if (c != null) _cValue = c;
    if (d != null) _dValue = d;
    notifyListeners();
  }

  void resetSliders() {
    _aValue = 1.0;
    _bValue = 1.0;
    _cValue = 0.0;
    _dValue = 0.0;
    notifyListeners();
  }

  void toggleGrid() {
    _showGrid = !_showGrid;
    notifyListeners();
  }

  void toggleSpecialPoints() {
    _showSpecialPoints = !_showSpecialPoints;
    notifyListeners();
  }

  void _findSpecialPoints() {
    _specialPoints.clear();
    
    // Only find intersections for linear equations
    final linearLines = _lines.where((l) => !l.isFunction).toList();
    
    for (int i = 0; i < linearLines.length; i++) {
      for (int j = i + 1; j < linearLines.length; j++) {
        final line1 = linearLines[i];
        final line2 = linearLines[j];
        
        if (MathUtils.isParallel(line1.slope, line2.slope)) continue;
        
        final x = (line2.intercept - line1.intercept) / (line1.slope - line2.slope);
        final y = line1.slope * x + line1.intercept;
        
        _specialPoints.add(PointModel(
          x: x,
          y: y,
          label: '${line1.name}∩${line2.name}',
          type: PointType.intersection,
        ));
      }
      
      final line = linearLines[i];
      if (line.intercept != 0) {
        final xIntercept = -line.intercept / line.slope;
        _specialPoints.add(PointModel(
          x: xIntercept,
          y: 0,
          label: '${line.name} root',
          type: PointType.root,
        ));
      }
      
      _specialPoints.add(PointModel(
        x: 0,
        y: line.intercept,
        label: '${line.name} y-int',
        type: PointType.yIntercept,
      ));
    }
  }

  List<RelationModel> getRelations() {
    List<RelationModel> relations = [];
    final linearLines = _lines.where((l) => !l.isFunction).toList();
    
    for (int i = 0; i < linearLines.length; i++) {
      for (int j = i + 1; j < linearLines.length; j++) {
        final line1 = linearLines[i];
        final line2 = linearLines[j];
        final isParallel = MathUtils.isParallel(line1.slope, line2.slope);
        final isPerpendicular = MathUtils.isPerpendicular(line1.slope, line2.slope);
        
        relations.add(RelationModel(
          line1: line1.name,
          line2: line2.name,
          isParallel: isParallel,
          isPerpendicular: isPerpendicular,
          explanation: MathUtils.getRelationExplanation(
            line1.slope, line2.slope, line1.name, line2.name,
          ),
        ));
      }
    }
    return relations;
  }

  List<Map<String, double>> getTableValues(int lineIndex, {int points = 10}) {
    if (lineIndex >= _lines.length) return [];
    
    final line = _lines[lineIndex];
    List<Map<String, double>> values = [];
    
    if (line.isFunction) {
      for (int i = -points; i <= points; i++) {
        final x = i.toDouble();
        final y = evaluateFunction(line.functionExpression!, x);
        values.add({'x': x, 'y': y});
      }
    } else {
      for (int i = -points; i <= points; i++) {
        final x = i.toDouble();
        final y = line.slope * x + line.intercept;
        values.add({'x': x, 'y': y});
      }
    }
    
    return values;
  }

  void addPresetParallelLines() {
    clearAllLines();
    addLine(2, 1);
    addLine(2, 5);
    addLine(2, -3);
  }

  void addPresetPerpendicularLines() {
    clearAllLines();
    addLine(2, 1);
    addLine(-0.5, 3);
  }

  void addPresetIntersectingLines() {
    clearAllLines();
    addLine(1, 0);
    addLine(-1, 0);
    addLine(0.5, -2);
  }
}
