import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api'));

  final List<Map<String, dynamic>> _posts = [
    {
      'id': 1,
      'content': 'Venez découvrir AirVision ! L\'essayage AR est incroyable. 💇',
      'user': 'Admin',
      'avatar': 'A',
      'timestamp': '2024-04-10T09:00:00.000Z',
      'likes': 12,
      'liked': false,
    },
    {
      'id': 2,
      'content': 'J\'ai enfin trouvé ma coiffure idéale grâce à l\'analyse IA 🎉',
      'user': 'alice',
      'avatar': 'a',
      'timestamp': '2024-04-09T14:30:00.000Z',
      'likes': 8,
      'liked': false,
    },
    {
      'id': 3,
      'content': 'Le style "Tresses" en AR est trop réaliste ! @AirVision',
      'user': 'bob',
      'avatar': 'b',
      'timestamp': '2024-04-08T11:00:00.000Z',
      'likes': 5,
      'liked': false,
    },
  ];

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final response = await _dio.get('/posts');
      if (response.statusCode == 200 && response.data is List) {
        setState(() {
          for (final p in response.data as List) {
            final exists =
                _posts.any((existing) => existing['id'] == p['id']);
            if (!exists) {
              _posts.insert(0, {
                ...Map<String, dynamic>.from(p as Map),
                'avatar': (p['user'] as String)[0],
                'likes': 0,
                'liked': false,
              });
            }
          }
        });
      }
    } catch (_) {
      // Backend may not be running – use local mock data
    }
  }

  Future<void> _addPost(String content) async {
    setState(() => _isLoading = true);
    final newPost = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'content': content,
      'user': 'Moi',
      'avatar': 'M',
      'timestamp': DateTime.now().toIso8601String(),
      'likes': 0,
      'liked': false,
    };
    try {
      await _dio.post('/posts', data: {
        'content': content,
        'user': 'Moi',
      });
    } catch (_) {
      // Add locally if backend is unavailable
    }
    setState(() {
      _posts.insert(0, newPost);
      _isLoading = false;
    });
  }

  String _formatDate(String isoDate) {
    try {
      final dt = DateTime.parse(isoDate);
      return DateFormat('dd/MM/yyyy HH:mm').format(dt);
    } catch (_) {
      return isoDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F5F5),
      appBar: AppBar(
        title: const Text('Fil Social'),
        backgroundColor: const Color(0xFF204854),
        foregroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: _fetchPosts,
        child: _posts.isEmpty
            ? const Center(child: Text('Aucune publication'))
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: _posts.length,
                itemBuilder: (context, index) {
                  return _buildPostCard(_posts[index], index);
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNewPostDialog(context),
        backgroundColor: const Color(0xFF204854),
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildPostCard(Map<String, dynamic> post, int index) {
    final avatarColors = [
      Colors.purple.shade400,
      Colors.blue.shade400,
      Colors.green.shade400,
      Colors.orange.shade400,
      Colors.teal.shade400,
    ];
    final color = avatarColors[index % avatarColors.length];

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: color,
                  radius: 20,
                  child: Text(
                    (post['avatar'] as String).toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '@${post['user']}',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      _formatDate(post['timestamp'] as String),
                      style: const TextStyle(
                          color: Colors.black45, fontSize: 11),
                    ),
                  ],
                ),
                const Spacer(),
                if (post['user'] == 'Moi')
                  IconButton(
                    icon: const Icon(Icons.delete_outline,
                        color: Colors.red, size: 20),
                    onPressed: () =>
                        setState(() => _posts.removeAt(index)),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              post['content'] as String,
              style:
                  const TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      if (post['liked'] as bool) {
                        post['likes'] = (post['likes'] as int) - 1;
                      } else {
                        post['likes'] = (post['likes'] as int) + 1;
                      }
                      post['liked'] = !(post['liked'] as bool);
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        (post['liked'] as bool)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: (post['liked'] as bool)
                            ? Colors.red
                            : Colors.black45,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${post['likes']}',
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(Icons.comment_outlined,
                    color: Colors.black45, size: 20),
                const SizedBox(width: 4),
                const Text('Commenter',
                    style:
                        TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showNewPostDialog(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Nouvelle publication',
                style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 4,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Quoi de neuf ?',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Annuler'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF204854),
                  ),
                  onPressed: () {
                    if (controller.text.trim().isNotEmpty) {
                      _addPost(controller.text.trim());
                      Navigator.pop(context);
                    }
                  },
                  child: _isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2))
                      : const Text('Publier',
                          style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

