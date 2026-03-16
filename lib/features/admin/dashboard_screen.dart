import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Mock data – replace with backend calls
  final List<Map<String, String>> _users = [
    {'email': 'alice@example.com', 'role': 'User', 'joined': '2024-01-10'},
    {'email': 'bob@example.com', 'role': 'User', 'joined': '2024-02-05'},
    {'email': 'carol@example.com', 'role': 'Stylist', 'joined': '2024-03-01'},
    {'email': 'admin@airvision.com', 'role': 'Admin', 'joined': '2023-12-01'},
  ];

  final List<Map<String, String>> _posts = [
    {
      'id': 'post_001',
      'user': 'alice',
      'content': 'J\'adore ma nouvelle coiffure !',
      'date': '2024-04-01'
    },
    {
      'id': 'post_002',
      'user': 'bob',
      'content': 'Essai réussi avec AirVision AR 🎉',
      'date': '2024-04-02'
    },
    {
      'id': 'post_003',
      'user': 'carol',
      'content': 'Recommande à tous mes clients.',
      'date': '2024-04-03'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F5),
      appBar: AppBar(
        title: const Text('Tableau de bord Admin'),
        backgroundColor: const Color(0xFF204854),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFFDB05E),
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard), text: 'Aperçu'),
            Tab(icon: Icon(Icons.people), text: 'Utilisateurs'),
            Tab(icon: Icon(Icons.article), text: 'Publications'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildUsersTab(),
          _buildPostsTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Statistiques générales',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF204854),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildStatCard(
                  'Utilisateurs', '${_users.length}', Icons.people, Colors.blue),
              _buildStatCard(
                  'Publications', '${_posts.length}', Icons.article, Colors.green),
              _buildStatCard('Réservations', '12', Icons.calendar_today,
                  Colors.orange),
              _buildStatCard(
                  'Analyses IA', '47', Icons.face, Colors.purple),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Actions rapides',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF204854),
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
              Icons.person_add, 'Ajouter un utilisateur', Colors.blue),
          const SizedBox(height: 8),
          _buildActionButton(
              Icons.delete_sweep, 'Modérer les publications', Colors.red),
          const SizedBox(height: 8),
          _buildActionButton(
              Icons.bar_chart, 'Voir les rapports', Colors.green),
          const SizedBox(height: 8),
          _buildActionButton(
              Icons.settings, 'Paramètres de l\'application', Colors.grey),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: color),
            ),
            const SizedBox(height: 4),
            Text(label,
                style: const TextStyle(fontSize: 13, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(label,
            style: const TextStyle(color: Colors.white, fontSize: 15)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          alignment: Alignment.centerLeft,
        ),
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$label – bientôt disponible')),
        ),
      ),
    );
  }

  Widget _buildUsersTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _users.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final user = _users[index];
        final isAdmin = user['role'] == 'Admin';
        return ListTile(
          leading: CircleAvatar(
            backgroundColor:
                isAdmin ? const Color(0xFF204854) : Colors.purple.shade100,
            child: Text(
              user['email']![0].toUpperCase(),
              style: TextStyle(
                  color: isAdmin ? Colors.white : Colors.purple.shade700,
                  fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(user['email']!,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text('Inscrit le ${user['joined']}'),
          trailing: Chip(
            label: Text(user['role']!,
                style: const TextStyle(color: Colors.white, fontSize: 12)),
            backgroundColor: isAdmin
                ? const Color(0xFF204854)
                : Colors.purple.shade400,
            padding: EdgeInsets.zero,
          ),
          onLongPress: () => _confirmDeleteUser(user['email']!),
        );
      },
    );
  }

  void _confirmDeleteUser(String email) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Supprimer l\'utilisateur'),
        content: Text('Voulez-vous supprimer $email ?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annuler')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              setState(() => _users.removeWhere((u) => u['email'] == email));
              Navigator.pop(context);
            },
            child: const Text('Supprimer',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildPostsTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final post = _posts[index];
        return Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple.shade100,
              child: Text(post['user']![0].toUpperCase(),
                  style: TextStyle(color: Colors.purple.shade700)),
            ),
            title: Text(post['content']!),
            subtitle: Text('@${post['user']}  •  ${post['date']}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => setState(
                  () => _posts.removeWhere((p) => p['id'] == post['id'])),
            ),
          ),
        );
      },
    );
  }
}

