import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/auth_provider.dart';
import '../ai/facial_analysis_screen.dart';
import '../ar/ar_tryon_screen.dart';
import '../social/social_screen.dart';
import '../marketplace/marketplace_screen.dart';
import '../booking/booking_screen.dart';
import '../history/history_screen.dart';
import '../admin/dashboard_screen.dart';
import '../webar/webar_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _pseudoController = TextEditingController();
  bool _isAdmin = false;

  @override
  void initState() {
    super.initState();
    _loadPseudo();
  }

  Future<void> _loadPseudo() async {
    final prefs = await SharedPreferences.getInstance();
    _pseudoController.text = prefs.getString('pseudo') ?? '';
    setState(() {
      _isAdmin = _pseudoController.text == 'admin';
    });
  }

  Future<void> _savePseudo(String pseudo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pseudo', pseudo);
    setState(() {
      _isAdmin = pseudo == 'admin';
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('AirVision'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authProvider.signOut(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50, Colors.blue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: _pseudoController,
                    decoration: const InputDecoration(
                      labelText: 'Pseudo',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _savePseudo,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  children: [
                    _buildAnimatedButton('Analyse IA', Icons.face, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FacialAnalysisScreen()))),
                    _buildAnimatedButton('Boutique', Icons.shopping_cart, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MarketplaceScreen()))),
                    _buildAnimatedButton('Historique', Icons.history, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryScreen()))),
                    _buildAnimatedButton('Essayer en AR', Icons.view_in_ar, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ArTryOnScreen()))),
                    _buildAnimatedButton('HairVision Web', Icons.web, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const WebARScreen()))),
                    if (_isAdmin) _buildAnimatedButton('Admin', Icons.admin_panel_settings, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DashboardScreen()))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _syncData(),
        backgroundColor: Colors.purple.shade700,
        child: const Icon(Icons.sync),
      ),
    );
  }

  Widget _buildAnimatedButton(String title, IconData icon, VoidCallback onPressed) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Card(
        elevation: 8,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(15),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [Colors.white, Colors.purple.shade50],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 48, color: Colors.purple.shade700),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _syncData() {
    // Implement sync logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Syncing data...'),
        backgroundColor: Colors.purple.shade700,
      ),
    );
  }
}
