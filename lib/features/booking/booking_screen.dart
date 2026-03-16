import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = '';
  int _selectedStylistIndex = 0;
  int _selectedServiceIndex = 0;

  final List<String> _timeSlots = [
    '09:00',
    '10:00',
    '11:00',
    '14:00',
    '15:00',
    '16:00'
  ];

  final List<Map<String, String>> _stylists = [
    {'name': 'Marie D.', 'specialty': 'Coloriste', 'avatar': 'M'},
    {'name': 'Jean P.', 'specialty': 'Barbier', 'avatar': 'J'},
    {'name': 'Aïda K.', 'specialty': 'Tresses & Locks', 'avatar': 'A'},
    {'name': 'Léa M.', 'specialty': 'Coupe & Style', 'avatar': 'L'},
  ];

  final List<Map<String, dynamic>> _services = [
    {'name': 'Coupe Femme', 'duration': '45 min', 'price': '35€'},
    {'name': 'Coupe Homme', 'duration': '30 min', 'price': '20€'},
    {'name': 'Coloration', 'duration': '90 min', 'price': '65€'},
    {'name': 'Tresses', 'duration': '120 min', 'price': '80€'},
    {'name': 'Lissage', 'duration': '60 min', 'price': '50€'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réserver un rendez-vous'),
        backgroundColor: const Color(0xFF204854),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('1. Choisir un coiffeur'),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _stylists.length,
                itemBuilder: (context, index) {
                  final s = _stylists[index];
                  final isSelected = index == _selectedStylistIndex;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedStylistIndex = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF204854)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFFDB05E)
                              : Colors.grey.shade300,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                const BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(0, 2))
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: isSelected
                                ? const Color(0xFFFDB05E)
                                : Colors.purple.shade100,
                            radius: 20,
                            child: Text(
                              s['avatar']!,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: isSelected
                                      ? const Color(0xFF204854)
                                      : Colors.purple.shade700),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            s['name']!,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87),
                          ),
                          Text(
                            s['specialty']!,
                            style: TextStyle(
                                fontSize: 10,
                                color: isSelected
                                    ? Colors.white70
                                    : Colors.black54),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            _sectionTitle('2. Choisir une prestation'),
            ...List.generate(_services.length, (index) {
              final svc = _services[index];
              final isSelected = index == _selectedServiceIndex;
              return GestureDetector(
                onTap: () =>
                    setState(() => _selectedServiceIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? const Color(0xFF204854) : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFFFDB05E)
                          : Colors.grey.shade300,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.content_cut,
                      color: isSelected
                          ? const Color(0xFFFDB05E)
                          : Colors.purple.shade400,
                    ),
                    title: Text(
                      svc['name'] as String,
                      style: TextStyle(
                          color:
                              isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      svc['duration'] as String,
                      style: TextStyle(
                          color: isSelected
                              ? Colors.white70
                              : Colors.black54),
                    ),
                    trailing: Text(
                      svc['price'] as String,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? const Color(0xFFFDB05E)
                            : Colors.purple.shade700,
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            _sectionTitle('3. Choisir une date'),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: CalendarDatePicker(
                initialDate: _selectedDate,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 30)),
                onDateChanged: (date) =>
                    setState(() => _selectedDate = date),
              ),
            ),
            const SizedBox(height: 20),
            _sectionTitle('4. Choisir un créneau horaire'),
            Wrap(
              spacing: 8.0,
              runSpacing: 8.0,
              children: _timeSlots.map((time) {
                final isSelected = _selectedTime == time;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedTime = isSelected ? '' : time),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF204854)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFFFDB05E)
                            : Colors.grey.shade300,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Text(
                      time,
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.black87),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            if (_selectedTime.isNotEmpty) _buildSummaryCard(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle, color: Colors.white),
                label: const Text('Confirmer le rendez-vous',
                    style:
                        TextStyle(fontSize: 16, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF204854),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _bookAppointment,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF204854),
        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    final stylist = _stylists[_selectedStylistIndex];
    final service = _services[_selectedServiceIndex];
    return Card(
      color: Colors.purple.shade50,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Récapitulatif',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF204854))),
            const Divider(),
            _summaryRow(Icons.person, 'Coiffeur', stylist['name']!),
            _summaryRow(Icons.content_cut, 'Prestation',
                '${service['name']} – ${service['price']}'),
            _summaryRow(Icons.calendar_today, 'Date',
                DateFormat('dd/MM/yyyy').format(_selectedDate)),
            _summaryRow(Icons.access_time, 'Heure', _selectedTime),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.purple.shade400),
          const SizedBox(width: 8),
          Text('$label : ',
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: Colors.black87)),
          Expanded(
              child: Text(value,
                  style: const TextStyle(color: Colors.black54))),
        ],
      ),
    );
  }

  void _bookAppointment() {
    if (_selectedTime.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner un horaire')),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Rendez-vous confirmé !'),
          ],
        ),
        content: Text(
          'Votre rendez-vous avec ${_stylists[_selectedStylistIndex]['name']} '
          'pour ${_services[_selectedServiceIndex]['name']} '
          'le ${DateFormat('dd/MM/yyyy').format(_selectedDate)} à $_selectedTime a été enregistré.',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF204854)),
            onPressed: () => Navigator.of(context).popUntil(
              (route) => route.isFirst || route.settings.name == '/home',
            ),
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

