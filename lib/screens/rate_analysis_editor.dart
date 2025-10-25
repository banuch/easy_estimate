// lib/screens/rate_analysis_editor.dart

import 'package:flutter/material.dart';
import '../models/dar_analysis.dart';

class RateAnalysisEditor extends StatefulWidget {
  final DARAnalysis darAnalysis;
  final String itemCode;

  const RateAnalysisEditor({
    super.key,
    required this.darAnalysis,
    required this.itemCode,
  });

  @override
  State<RateAnalysisEditor> createState() => _RateAnalysisEditorState();
}

class _RateAnalysisEditorState extends State<RateAnalysisEditor> {
  late TextEditingController _materialController;
  late TextEditingController _laborController;
  late TextEditingController _equipmentController;
  late TextEditingController _oapController;

  @override
  void initState() {
    super.initState();
    _materialController = TextEditingController(text: widget.darAnalysis.materialCost.toStringAsFixed(2));
    _laborController = TextEditingController(text: widget.darAnalysis.laborCost.toStringAsFixed(2));
    _equipmentController = TextEditingController(text: widget.darAnalysis.equipmentCost.toStringAsFixed(2));
    _oapController = TextEditingController(text: widget.darAnalysis.overheadsAndProfitPercentage.toStringAsFixed(1));

    void listener() => setState(() {
      // Update DAR object properties on every input change
      widget.darAnalysis.materialCost = double.tryParse(_materialController.text) ?? 0.0;
      widget.darAnalysis.laborCost = double.tryParse(_laborController.text) ?? 0.0;
      widget.darAnalysis.equipmentCost = double.tryParse(_equipmentController.text) ?? 0.0;
      widget.darAnalysis.overheadsAndProfitPercentage = double.tryParse(_oapController.text) ?? 0.0;
      // The calculatedItemRate getter automatically updates!
    });

    _materialController.addListener(listener);
    _laborController.addListener(listener);
    _equipmentController.addListener(listener);
    _oapController.addListener(listener);
  }

  @override
  void dispose() {
    _materialController.dispose();
    _laborController.dispose();
    _equipmentController.dispose();
    _oapController.dispose();
    super.dispose();
  }

  Widget _buildCostInput(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          prefixText: '₹ ',
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Analysis: ${widget.itemCode}'),
        backgroundColor: Colors.blueGrey,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Card(
              elevation: 4,
              color: Colors.lightGreen.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Calculated Item Rate: ₹${widget.darAnalysis.calculatedItemRate.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text('Editable Cost Components:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            _buildCostInput('Material Cost', _materialController),
            _buildCostInput('Labor Cost', _laborController),
            _buildCostInput('Equipment Cost', _equipmentController),
            _buildCostInput('Overheads & Profit (%)', _oapController),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.save),
              label: const Text('Save & Apply Changes'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}