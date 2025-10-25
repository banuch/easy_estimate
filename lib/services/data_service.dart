// lib/services/data_service.dart

import '../models/dsr_item.dart';
import '../models/dar_analysis.dart';
import '../models/estimate.dart';
import '../models/estimate_item.dart';
import '../models/measurement.dart';

class DataService {
  // A static list to hold all master DSR items
  static final List<DSRItem> dsrMasterList = _generateMockData();

  // A static list to hold the current active estimate (for demonstration)
  static final Estimate currentEstimate = _generateMockEstimate();


  List<DSRItem> getAllDsrItems() {
    return dsrMasterList;
  }

  // --- SERIAL NUMBERING LOGIC ---
  String generateNextItemSerialNo(
      String newDsrCode, List<EstimateItem> existingItems) {

    double maxMainNo = 0.0;

    // 1. Find the largest existing main item number
    if (existingItems.isNotEmpty) {
      for (var item in existingItems) {
        try {
          final parts = item.serialNo.split('.');
          final mainNo = double.tryParse(parts[0]) ?? 0.0;
          if (mainNo > maxMainNo) {
            maxMainNo = mainNo;
          }
        } catch (e) { /* ignore */ }
      }
    }

    // 2. Determine the Item to Compare Against for Sub-item Check
    final lastItem = existingItems.isNotEmpty
        ? existingItems.last
        : null;

    // 3. Logic: Check if the new DSR item belongs as a sub-item
    bool isSubItem = false;
    if (lastItem != null && maxMainNo > 0) {
      // Use the first part of the DSR item code for sub-item grouping
      final lastDsrCodeMain = lastItem.dsrReference.itemCode.split('.').first;
      final newDsrCodeMain = newDsrCode.split('.').first;

      // If the main DSR code part is the same, it's a sub-item
      if (lastDsrCodeMain == newDsrCodeMain) {
        isSubItem = true;
      }
    }

    if (isSubItem) {
      // Find the max sub-item number for the current major number
      final currentMajorNo = maxMainNo.toInt();
      int maxSubNo = 0;

      final subItems = existingItems.where((item) => item.serialNo.startsWith('${currentMajorNo}.')).toList();
      for (var item in subItems) {
        try {
          final parts = item.serialNo.split('.');
          if (parts.length > 1) {
            final subNo = int.tryParse(parts[1]) ?? 0;
            if (subNo > maxSubNo) {
              maxSubNo = subNo;
            }
          }
        } catch (e) { /* ignore */ }
      }

      return '${currentMajorNo}.${maxSubNo + 1}'; // e.g., 1.1, 1.2

    } else {
      // New main item code
      final newMainNo = maxMainNo.toInt() + 1;
      return '${newMainNo}.0'; // e.g., 2.0, 3.0
    }
  }


  // --- MOCK DATA GENERATION ---
  static List<DSRItem> _generateMockData() {
    final dar1 = DARAnalysis(
      materialCost: 2500.0,
      laborCost: 1200.0,
      equipmentCost: 350.0,
      overheadsAndProfitPercentage: 15.0,
    );

    final dar2 = DARAnalysis(
      materialCost: 45.0,
      laborCost: 8.0,
      equipmentCost: 2.0,
      overheadsAndProfitPercentage: 12.0,
    );

    final item1 = DSRItem(
      itemCode: '4.1.1',
      description: 'RCC M25 concrete in foundation.',
      unit: 'm³',
      baseRate: 4650.00,
      category: 'Concrete',
      rateAnalysis: dar1,
    );

    final item2 = DSRItem(
      itemCode: '2.1.2',
      description: 'Brickwork in cement mortar 1:6.',
      unit: 'm²',
      baseRate: 75.00,
      category: 'Masonry',
      rateAnalysis: dar2,
    );

    final item3 = DSRItem(
      itemCode: '4.1.2', // Same main code as item 1, for sub-item test
      description: 'RCC M30 concrete in slab.',
      unit: 'm³',
      baseRate: 5100.00,
      category: 'Concrete',
      rateAnalysis: DARAnalysis(materialCost: 3000, laborCost: 1500, equipmentCost: 400),
    );

    return [item1, item2, item3];
  }

  static Estimate _generateMockEstimate() {
    // Initial item for testing serial number logic
    final initialDsr = _generateMockData().first;

    final initialEstimateItem = EstimateItem(
        uniqueItemId: '001',
        dsrReference: initialDsr,
        serialNo: '1.0',
        measurements: [
          Measurement(length: 5.0, width: 3.0, height: 0.5, count: 1, remarks: 'Block A'),
        ]
    );

    return Estimate(
      estimateId: 'EST-001',
      projectName: 'New Office Building',
      client: 'City Development Corp',
      dateCreated: DateTime.now(),
      items: [initialEstimateItem],
    );
  }
}