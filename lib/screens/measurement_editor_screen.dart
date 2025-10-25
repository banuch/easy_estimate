// lib/screens/measurement_editor_screen.dart

import 'package:flutter/material.dart';
import '../models/measurement.dart';

class MeasurementEditorScreen extends StatefulWidget {
  final List<Measurement> initialMeasurements;

  const MeasurementEditorScreen({
    super.key,
    required this.initialMeasurements,
  });

  @override
  State<MeasurementEditorScreen> createState() => _MeasurementEditorScreenState();
}

class _MeasurementEditorScreenState extends State<MeasurementEditorScreen> {
  late List<Measurement> _workingMeasurements;

  @override
  void initState() {
    super.initState();
    // Use a copy to avoid modifying the original list before save
    _workingMeasurements = List.from(widget.initialMeasurements);
    if (_workingMeasurements.isEmpty) {
      _workingMeasurements.add(Measurement(count: 1)); // Start with one blank row
    }
  }

  void _addMeasurement() {
    setState(() {
      _workingMeasurements.add(Measurement(count: 1));
    });
  }

  void _removeMeasurement(int index) {
    setState(() {
      _workingMeasurements.removeAt(index);
    });
  }

  void _saveMeasurements() {
    // Return the list of measurements back to the calling screen
    Navigator.pop(context, _workingMeasurements);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detailed Measurement Entry'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _saveMeasurements,
            tooltip: 'Save Measurements',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _workingMeasurements.length,
              itemBuilder: (context, index) {
                return _MeasurementCard(
                  measurement: _workingMeasurements[index],
                  index: index,
                  onRemove: _removeMeasurement,
                  onUpdate: () => setState(() {}),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blue.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total Quantity:',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${_workingMeasurements.fold(0.0, (sum, m) => sum + m.totalMeasurement).toStringAsFixed(3)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMeasurement,
        child: const Icon(Icons.add),
      ),
    );
  }
}

// Helper Widget for a single measurement card
class _MeasurementCard extends StatelessWidget {
  final Measurement measurement;
  final int index;
  final Function(int) onRemove;
  final Function() onUpdate;

  const _MeasurementCard({
    required this.measurement,
    required this.index,
    required this.onRemove,
    required this.onUpdate,
  });

  Widget _buildTextField(String label, double? initialValue, Function(double?) onChanged) {
    TextEditingController controller = TextEditingController(text: initialValue != null ? initialValue.toString() : '');
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(borderSide: BorderSide.none)),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (value) {
            onChanged(double.tryParse(value));
            onUpdate();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Line ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => onRemove(index),
                ),
              ],
            ),
            Row(
              children: [
                _buildTextField('L', measurement.length, (v) => measurement.length = v),
                _buildTextField('W', measurement.width, (v) => measurement.width = v),
                _buildTextField('H', measurement.height, (v) => measurement.height = v),

              ],
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextField(
                    controller: TextEditingController(text: measurement.count?.toString() ?? '1'),
                    decoration: const InputDecoration(labelText: 'Count'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      measurement.count = int.tryParse(value);
                      onUpdate();
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: TextEditingController(text: measurement.remarks),
                    decoration: const InputDecoration(labelText: 'Remarks/Location'),
                    onChanged: (value) => measurement.remarks = value,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text('Sub-Total (L*W*H*C): ${measurement.totalMeasurement.toStringAsFixed(3)}',
                style: const TextStyle(fontStyle: FontStyle.italic)),
          ],
        ),
      ),
    );
  }
}