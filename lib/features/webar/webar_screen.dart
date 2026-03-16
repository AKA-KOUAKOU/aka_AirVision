import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebARScreen extends StatefulWidget {
  const WebARScreen({super.key});

  @override
  _WebARScreenState createState() => _WebARScreenState();
}

class _WebARScreenState extends State<WebARScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;
  bool _useWebView = false;

  static const String _webArUrl = 'http://10.0.2.2:3000';

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (_) => setState(() => _isLoading = true),
        onPageFinished: (_) => setState(() => _isLoading = false),
        onWebResourceError: (_) => setState(() => _isLoading = false),
      ))
      ..loadRequest(Uri.parse(_webArUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HairVision Web AR'),
        backgroundColor: const Color(0xFF204854),
        foregroundColor: Colors.white,
        actions: [
          if (_useWebView)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _controller.reload(),
            ),
          IconButton(
            icon: Icon(_useWebView ? Icons.close : Icons.open_in_browser),
            onPressed: () =>
                setState(() => _useWebView = !_useWebView),
            tooltip: _useWebView ? 'Fermer' : 'Ouvrir dans l\'app',
          ),
        ],
      ),
      body: _useWebView ? _buildWebView() : _buildLandingPage(),
    );
  }

  Widget _buildWebView() {
    return Stack(
      children: [
        WebViewWidget(controller: _controller),
        if (_isLoading)
          const Center(child: CircularProgressIndicator()),
      ],
    );
  }

  Widget _buildLandingPage() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade100, Colors.blue.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _AnimatedWebIcon(),
              const SizedBox(height: 24),
              const Text(
                'HairVision Web AR',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF204854)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Visualisez votre coiffure idéale dans votre navigateur\ngrâce à la réalité augmentée.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.black54),
              ),
              const SizedBox(height: 32),
              _featureRow(Icons.devices, 'Compatible tous navigateurs modernes'),
              const SizedBox(height: 10),
              _featureRow(Icons.face_retouching_natural,
                  'Essayage AR en temps réel'),
              const SizedBox(height: 10),
              _featureRow(Icons.share, 'Partagez votre look en un clic'),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                icon:
                    const Icon(Icons.open_in_browser, color: Colors.white),
                label: const Text(
                  'Lancer l\'expérience WebAR',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF204854),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () =>
                    setState(() => _useWebView = true),
              ),
              const SizedBox(height: 12),
              Text(
                'URL : $_webArUrl',
                style: const TextStyle(
                    fontSize: 12, color: Colors.black45),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _featureRow(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.purple.shade700, size: 20),
        const SizedBox(width: 10),
        Text(text,
            style: const TextStyle(fontSize: 14, color: Colors.black87)),
      ],
    );
  }
}

class _AnimatedWebIcon extends StatefulWidget {
  @override
  State<_AnimatedWebIcon> createState() => _AnimatedWebIconState();
}

class _AnimatedWebIconState extends State<_AnimatedWebIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (_, __) => Transform.scale(
        scale: _animation.value,
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.purple.shade700.withAlpha(20),
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.web,
              size: 56, color: Colors.purple.shade700),
        ),
      ),
    );
  }
}

