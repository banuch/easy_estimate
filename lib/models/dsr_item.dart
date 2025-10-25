// lib/models/dsr_item.dart

import 'dar_analysis.dart';

class DSRItem {
  final String itemCode;
  final String description;
  final String unit;
  final double baseRate;
  final String category;

  DARAnalysis? rateAnalysis;

  DSRItem({
    required this.itemCode,
    required this.description,
    required this.unit,
    required this.baseRate,
    required this.category,
    this.rateAnalysis,
  });
}