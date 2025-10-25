// lib/models/estimate.dart

import 'estimate_item.dart';

class Estimate {
  final String estimateId;
  String projectName;
  String client;
  DateTime dateCreated;
  List<EstimateItem> items;

  Estimate({
    required this.estimateId,
    required this.projectName,
    required this.client,
    required this.dateCreated,
    required this.items,
  });

  // ⭐ GRAND TOTAL CALCULATION LOGIC (Aggregation) ⭐
  double get totalEstimateValue {
    return items.fold(0.0, (sum, item) => sum + item.itemTotalAmount);
  }
}