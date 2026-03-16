import 'package:flutter/material.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String _filter = 'Tous';
  final List<String> _filters = ['Tous', 'Analyse', 'Achat', 'Réservation'];

  final List<Map<String, dynamic>> _allItems = [
    {
      'type': 'Analyse',
      'description': 'Analyse faciale – Forme Ovale détectée',
      'date': '2024-04-10',
      'icon': Icons.face,
      'color': Colors.purple,
      'detail': 'Confiance : 92%',
    },
    {
      'type': 'Achat',
      'description': 'Shampoing Hydratant Premium',
      'date': '2024-04-08',
      'icon': Icons.shopping_bag,
      'color': Colors.green,
      'detail': '29,99 €',
    },
    {
      'type': 'Réservation',
      'description': 'Rendez-vous chez Marie D. – Coupe Femme',
      'date': '2024-04-05',
      'icon': Icons.calendar_today,
      'color': Colors.blue,
      'detail': '14:00 – 35 €',
    },
    {
      'type': 'Analyse',
      'description': 'Essayage AR – Style "Boucles"',
      'date': '2024-03-28',
      'icon': Icons.view_in_ar,
      'color': Colors.deepOrange,
      'detail': 'Durée : 4 min',
    },
    {
      'type': 'Achat',
      'description': 'Masque Nourrissant Cheveux',
      'date': '2024-03-20',
      'icon': Icons.shopping_bag,
      'color': Colors.green,
      'detail': '39,99 €',
    },
    {
      'type': 'Réservation',
      'description': 'Rendez-vous chez Jean P. – Barbe',
      'date': '2024-03-15',
      'icon': Icons.calendar_today,
      'color': Colors.blue,
      'detail': '10:00 – 20 €',
    },
    {
      'type': 'Analyse',
      'description': 'Analyse faciale – Teint Chaleureux',
      'date': '2024-03-01',
      'icon': Icons.face,
      'color': Colors.purple,
      'detail': 'Confiance : 87%',
    },
  ];

  List<Map<String, dynamic>> get _filteredItems => _filter == 'Tous'
      ? _allItems
      : _allItems.where((i) => i['type'] == _filter).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F5),
      appBar: AppBar(
        title: const Text('Mon Historique'),
        backgroundColor: const Color(0xFF204854),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Effacer l\'historique',
            onPressed: _confirmClear,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _filters.map((f) {
                  final isSelected = _filter == f;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(f),
                      selected: isSelected,
                      onSelected: (_) => setState(() => _filter = f),
                      selectedColor: const Color(0xFF204854),
                      checkmarkColor: Colors.white,
                      labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Expanded(
            child: _filteredItems.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.history, size: 64, color: Colors.black26),
                        SizedBox(height: 12),
                        Text('Aucune activité',
                            style: TextStyle(
                                color: Colors.black45, fontSize: 16)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = _filteredItems[index];
                      final isLast = index == _filteredItems.length - 1;
                      return IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Timeline column
                            Column(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: (item['color'] as Color)
                                        .withAlpha(30),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: item['color'] as Color,
                                        width: 2),
                                  ),
                                  child: Icon(item['icon'] as IconData,
                                      size: 18,
                                      color: item['color'] as Color),
                                ),
                                if (!isLast)
                                  Expanded(
                                    child: Container(
                                      width: 2,
                                      color: Colors.grey.shade300,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 4),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            // Card
                            Expanded(
                              child: Card(
                                elevation: 2,
                                margin:
                                    const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Chip(
                                            label: Text(
                                              item['type'] as String,
                                              style: const TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.white),
                                            ),
                                            backgroundColor:
                                                item['color'] as Color,
                                            padding: EdgeInsets.zero,
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                          Text(
                                            item['date'] as String,
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.black45),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        item['description'] as String,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight:
                                                FontWeight.w600),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        item['detail'] as String,
                                        style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black54),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  void _confirmClear() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Effacer l\'historique'),
        content:
            const Text('Voulez-vous supprimer tout l\'historique ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _allItems.clear());
              Navigator.pop(context);
            },
            child: const Text('Supprimer',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

