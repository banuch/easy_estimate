// lib/screens/estimate_screen.dart

import 'package:flutter/material.dart';
import '../models/estimate.dart';
import '../models/dsr_item.dart';
import '../models/estimate_item.dart';
import '../models/measurement.dart';
import '../services/data_service.dart';
import 'item_search_screen.dart';
import 'rate_analysis_editor.dart';
import 'measurement_editor_screen.dart';

class EstimateScreen extends StatefulWidget {
  const EstimateScreen({super.key});

  @override
  State<EstimateScreen> createState() => _EstimateScreenState();
}

class _EstimateScreenState extends State<EstimateScreen> {
  // Use the mock estimate instance
  Estimate currentEstimate = DataService.currentEstimate;

  // Handles adding a new item after search
  void _addItem(BuildContext context) async {
    final selectedDsrItem = await Navigator.push<DSRItem?>(
      context,
      MaterialPageRoute(builder: (context) => const ItemSearchScreen()),
    );

    if (selectedDsrItem != null) {
      final dataService = DataService();
      // Generate the serial number
      final String newSerialNo = dataService.generateNextItemSerialNo(
        selectedDsrItem.itemCode,
        currentEstimate.items,
      );

      // Create the new Estimate Item with a default measurement
      final newEstimateItem = EstimateItem(
        uniqueItemId: DateTime.now().millisecondsSinceEpoch.toString(),
        dsrReference: selectedDsrItem,
        serialNo: newSerialNo,
        measurements: [Measurement(length: 1.0, width: 1.0, height: 1.0, count: 1)],
      );

      setState(() {
        currentEstimate.items.add(newEstimateItem);
      });
    }
  }

  // Handles navigation to the Rate Analysis Editor
  void _editRateAnalysis(EstimateItem item) async {
    if (item.dsrReference.rateAnalysis == null) return;

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RateAnalysisEditor(
          darAnalysis: item.dsrReference.rateAnalysis!,
          itemCode: item.dsrReference.itemCode,
        ),
      ),
    );

    // Check if changes were made and force rebuild to update totals
    if (result == true) {
      setState(() {});
    }
  }

  // Handles navigation to the Measurement Editor
  void _editMeasurements(EstimateItem item) async {
    final List<Measurement>? updatedMeasurements = await Navigator.push<List<Measurement>>(
      context,
      MaterialPageRoute(
        builder: (context) => MeasurementEditorScreen(
          initialMeasurements: item.measurements,
        ),
      ),
    );

    if (updatedMeasurements != null) {
      setState(() {
        item.measurements = updatedMeasurements;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Construction Estimate App'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          // Project Summary Card
          Card(
            margin: const EdgeInsets.all(8.0),
            color: Colors.blue.shade50,
            child: ListTile(
              title: Text(currentEstimate.projectName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text('Client: ${currentEstimate.client} | Total Value: ₹${currentEstimate.totalEstimateValue.toStringAsFixed(2)}'),
            ),
          ),

          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Estimate Items:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),

          // Estimate Items List
          Expanded(
            child: ListView.builder(
              itemCount: currentEstimate.items.length,
              itemBuilder: (context, index) {
                final item = currentEstimate.items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  elevation: 2,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue.shade100,
                      child: Text(item.serialNo, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    title: Text('${item.dsrReference.description} (${item.dsrReference.itemCode})'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Rate: ₹${item.currentRate.toStringAsFixed(2)} / ${item.dsrReference.unit}'),
                        Text('Qty: ${item.quantity.toStringAsFixed(3)} ${item.dsrReference.unit}', style: const TextStyle(fontWeight: FontWeight.w600)),
                      ],
                    ),
                    trailing: Text('₹${item.itemTotalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                    onTap: () => _editRateAnalysis(item), // Tap to edit rate analysis
                    onLongPress: () => _editMeasurements(item), // Long press to edit measurements
                  ),
                );
              },
            ),
          ),
        ],
      ),
      // ⭐ ADD NEW ITEM BUTTON ⭐
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addItem(context),
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}