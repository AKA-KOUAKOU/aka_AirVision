import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  final List<Map<String, String>> historyItems = const [
    {'type': 'Analysis', 'description': 'Face analysis on 2023-10-01', 'date': '2023-10-01'},
    {'type': 'Purchase', 'description': 'Bought Hair Model 1', 'date': '2023-10-02'},
    // Add more items
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('History')),
      body: historyItems.isEmpty
          ? const Center(child: Text('No history available'))
          : ListView.builder(
              itemCount: historyItems.length,
              itemBuilder: (context, index) {
                final item = historyItems[index];
                return ListTile(
                  title: Text(item['description']!),
                  subtitle: Text('${item['type']} - ${item['date']}'),
                );
              },
            ),
    );
  }
}
