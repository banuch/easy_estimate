// lib/screens/item_search_screen.dart

import 'package:flutter/material.dart';
import '../models/dsr_item.dart';
import '../services/data_service.dart';

class ItemSearchScreen extends StatefulWidget {
  const ItemSearchScreen({super.key});

  @override
  State<ItemSearchScreen> createState() => _ItemSearchScreenState();
}

class _ItemSearchScreenState extends State<ItemSearchScreen> {
  final DataService _dataService = DataService();
  List<DSRItem> _allDsrItems = [];
  List<DSRItem> _filteredItems = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _allDsrItems = _dataService.getAllDsrItems();
    _filteredItems = _allDsrItems;
    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _allDsrItems.where((item) {
        return item.itemCode.toLowerCase().contains(query) ||
            item.description.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _selectItem(DSRItem item) {
    Navigator.pop(context, item);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search DSR Items'),
        backgroundColor: Colors.teal,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by Code or Description...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          return ListTile(
            title: Text('${item.itemCode} - ${item.description}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Unit: ${item.unit} | Base Rate: ₹${item.baseRate.toStringAsFixed(2)}'),
            trailing: const Icon(Icons.add_circle, color: Colors.teal),
            onTap: () => _selectItem(item),
          );
        },
      ),
    );
  }
}