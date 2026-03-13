import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  _SocialScreenState createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://localhost:3000/api'));
  List<dynamic> _posts = [];

  @override
  void initState() {
    super.initState();
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    try {
      final response = await _dio.get('/posts');
      setState(() {
        _posts = response.data;
      });
    } catch (e) {
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Social Feed')),
      body: ListView.builder(
        itemCount: _posts.length,
        itemBuilder: (context, index) {
          final post = _posts[index];
          return ListTile(
            title: Text(post['content']),
            subtitle: Text(post['user']),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addPost(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addPost(BuildContext context) {
    final TextEditingController _contentController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Post'),
        content: TextField(
          controller: _contentController,
          decoration: const InputDecoration(labelText: 'Content'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await _dio.post('/posts', data: {
                  'content': _contentController.text,
                  'user': 'Current User', // Replace with actual user
                });
                _fetchPosts(); // Refresh posts
                Navigator.of(context).pop();
              } catch (e) {
                // Handle error
              }
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}
