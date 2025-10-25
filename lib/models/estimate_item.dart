// lib/models/estimate_item.dart

import 'dsr_item.dart';
import 'measurement.dart';

class EstimateItem {
  final String uniqueItemId;
  DSRItem dsrReference;
  String serialNo;

  // Now uses a list of measurements instead of a single quantity field
  List<Measurement> measurements;

  EstimateItem({
    required this.uniqueItemId,
    required this.dsrReference,
    required this.serialNo,
    this.measurements = const [],
  });

  // ⭐ CALCULATED QUANTITY LOGIC (Total of all measurements) ⭐
  double get quantity {
    return measurements.fold(0.0, (sum, m) => sum + m.totalMeasurement);
  }

  double get currentRate => dsrReference.rateAnalysis?.calculatedItemRate ?? dsrReference.baseRate;

  double get itemTotalAmount {
    // Formula: Quantity * Current Rate
    return quantity * currentRate;
  }
}