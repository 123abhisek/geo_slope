
import 'package:flutter/material.dart';

class LineModel {
  final String name;
  final double slope;
  final double intercept;
  final Color color;
  final bool isVisible;
  final bool isFunction;
  final String? functionExpression;

  LineModel({
    required this.name,
    required this.slope,
    required this.intercept,
    required this.color,
    this.isVisible = true,
    this.isFunction = false,
    this.functionExpression,
  });

  String get equation {
    if (isFunction && functionExpression != null) {
      return 'y = $functionExpression';
    }
    
    String slopeStr = slope == slope.toInt() 
        ? slope.toInt().toString() 
        : slope.toStringAsFixed(2);
    String interceptStr = intercept == intercept.toInt()
        ? intercept.toInt().toString()
        : intercept.toStringAsFixed(2);
    
    String sign = intercept >= 0 ? '+' : '';
    return 'y = ${slopeStr}x $sign $interceptStr';
  }

  LineModel copyWith({
    String? name,
    double? slope,
    double? intercept,
    Color? color,
    bool? isVisible,
    bool? isFunction,
    String? functionExpression,
  }) {
    return LineModel(
      name: name ?? this.name,
      slope: slope ?? this.slope,
      intercept: intercept ?? this.intercept,
      color: color ?? this.color,
      isVisible: isVisible ?? this.isVisible,
      isFunction: isFunction ?? this.isFunction,
      functionExpression: functionExpression ?? this.functionExpression,
    );
  }
}
