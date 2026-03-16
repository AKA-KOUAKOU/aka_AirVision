import 'package:flutter/material.dart';
import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:vector_math/vector_math_64.dart' as vector;

class ArTryOnScreen extends StatefulWidget {
  const ArTryOnScreen({super.key});

  @override
  _ArTryOnScreenState createState() => _ArTryOnScreenState();
}

class _ArTryOnScreenState extends State<ArTryOnScreen> {
  ArCoreController? _arCoreController;
  int _selectedStyleIndex = 0;

  final List<Map<String, dynamic>> _hairStyles = [
    {'name': 'Court & Lisse', 'icon': Icons.face, 'color': Colors.brown},
    {'name': 'Boucles', 'icon': Icons.air, 'color': Colors.black87},
    {'name': 'Tresses', 'icon': Icons.grain, 'color': Colors.amber},
    {'name': 'Afro', 'icon': Icons.cloud, 'color': Colors.deepOrange},
    {'name': 'Lisse Long', 'icon': Icons.waves, 'color': Colors.blueGrey},
    {'name': 'Pixie Cut', 'icon': Icons.crop, 'color': Colors.purple},
  ];

  @override
  void dispose() {
    _arCoreController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Essayage AR'),
        backgroundColor: const Color(0xFF204854),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: _capturePhoto,
            tooltip: 'Capturer photo',
          ),
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: _captureVideo,
            tooltip: 'Capturer vidéo',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                ArCoreView(
                  onArCoreViewCreated: _onArCoreViewCreated,
                  enableTapRecognizer: true,
                ),
                Positioned(
                  top: 12,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        'Style : ${_hairStyles[_selectedStyleIndex]['name']}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 8),
                  child: Text(
                    'Choisir un style',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF204854)),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: _hairStyles.length,
                    itemBuilder: (context, index) {
                      final style = _hairStyles[index];
                      final isSelected = index == _selectedStyleIndex;
                      return GestureDetector(
                        onTap: () => _selectStyle(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 6),
                          width: 80,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF204854)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: isSelected
                                ? Border.all(
                                    color: const Color(0xFFFDB05E), width: 2)
                                : null,
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: const Offset(0, 2))
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                style['icon'] as IconData,
                                size: 32,
                                color: isSelected
                                    ? Colors.white
                                    : style['color'] as Color,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                style['name'] as String,
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black87,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _selectStyle(int index) {
    setState(() => _selectedStyleIndex = index);
    _addHairModel();
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    _arCoreController = controller;
    _addHairModel();
  }

  void _addHairModel() {
    final color = _hairStyles[_selectedStyleIndex]['color'] as Color;
    final node = ArCoreNode(
      shape: ArCoreSphere(
        materials: [ArCoreMaterial(color: color)],
        radius: 0.12,
      ),
      position: vector.Vector3(0, 0.15, -0.8),
    );
    _arCoreController?.addArCoreNode(node);
  }

  void _capturePhoto() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo capturée !')),
    );
  }

  void _captureVideo() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Enregistrement vidéo démarré...')),
    );
  }
}

