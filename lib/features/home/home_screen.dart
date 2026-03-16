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

  @override
  void dispose() {
    _pseudoController.dispose();
    super.dispose();
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
        title: Row(
          children: [
            Icon(Icons.content_cut,
                color: Colors.white, size: 22),
            const SizedBox(width: 8),
            const Text('AirVision',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color(0xFF204854),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: 'Se déconnecter',
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
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8),
                  child: TextField(
                    controller: _pseudoController,
                    decoration: const InputDecoration(
                      labelText: 'Pseudo (entrez "admin" pour accès admin)',
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.person),
                    ),
                    onChanged: _savePseudo,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  children: [
                    _buildFeatureCard(
                      'Analyse IA',
                      Icons.face_retouching_natural,
                      const Color(0xFF6A1B9A),
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const FacialAnalysisScreen())),
                    ),
                    _buildFeatureCard(
                      'Essayer en AR',
                      Icons.view_in_ar,
                      const Color(0xFF0277BD),
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const ArTryOnScreen())),
                    ),
                    _buildFeatureCard(
                      'HairVision Web',
                      Icons.web,
                      const Color(0xFF00695C),
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const WebARScreen())),
                    ),
                    _buildFeatureCard(
                      'Boutique',
                      Icons.shopping_bag,
                      const Color(0xFFE65100),
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const MarketplaceScreen())),
                    ),
                    _buildFeatureCard(
                      'Réservation',
                      Icons.calendar_today,
                      const Color(0xFF1565C0),
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const BookingScreen())),
                    ),
                    _buildFeatureCard(
                      'Fil Social',
                      Icons.people,
                      const Color(0xFF558B2F),
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SocialScreen())),
                    ),
                    _buildFeatureCard(
                      'Historique',
                      Icons.history,
                      const Color(0xFF4527A0),
                      () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const HistoryScreen())),
                    ),
                    if (_isAdmin)
                      _buildFeatureCard(
                        'Admin',
                        Icons.admin_panel_settings,
                        const Color(0xFF204854),
                        () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    const DashboardScreen())),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _syncData,
        backgroundColor: const Color(0xFF204854),
        tooltip: 'Synchroniser',
        child: const Icon(Icons.sync, color: Colors.white),
      ),
    );
  }

  Widget _buildFeatureCard(
      String title, IconData icon, Color color, VoidCallback onPressed) {
    return Card(
      elevation: 6,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.9), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 44, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _syncData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Synchronisation en cours...'),
        backgroundColor: Color(0xFF204854),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

