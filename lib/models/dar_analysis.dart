// lib/models/dar_analysis.dart

class DARAnalysis {
  double materialCost;
  double laborCost;
  double equipmentCost;
  double overheadsAndProfitPercentage; // e.g., 15.0

  DARAnalysis({
    this.materialCost = 0.0,
    this.laborCost = 0.0,
    this.equipmentCost = 0.0,
    this.overheadsAndProfitPercentage = 15.0,
  });

  // ⭐ CORE CALCULATION LOGIC ⭐
  double get calculatedItemRate {
    final double profitFactor = 1.0 + (overheadsAndProfitPercentage / 100.0);
    final double subtotal = materialCost + laborCost + equipmentCost;
    return subtotal * profitFactor;
  }
}