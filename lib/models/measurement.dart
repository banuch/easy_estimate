// lib/models/measurement.dart

class Measurement {
  double? length;
  double? width;
  double? height;
  int? count;
  String? remarks;

  Measurement({
    this.length,
    this.width,
    this.height,
    this.count,
    this.remarks,
  });

  // Calculates the total contribution of this single measurement
  double get totalMeasurement {
    double l = length ?? 1.0;
    double w = width ?? 1.0;
    double h = height ?? 1.0;
    int c = count ?? 1;

    // Calculation: L * W * H * Count
    return l * w * h * c;
  }
}