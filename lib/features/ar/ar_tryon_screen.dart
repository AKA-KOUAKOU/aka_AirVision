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
  final List<String> _recommendations = []; // Add this line

  @override
  void dispose() {
    _arCoreController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AR Virtual Try-On')),
      body: Column(
        children: [
          Expanded(
            child: ArCoreView(
              onArCoreViewCreated: _onArCoreViewCreated,
              enableTapRecognizer: true,
            ),
          ),
          if (_recommendations.isNotEmpty)
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _recommendations.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(_recommendations[index]),
                    ),
                  );
                },
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _capturePhoto,
                child: const Text('Capture Photo'),
              ),
              ElevatedButton(
                onPressed: _captureVideo,
                child: const Text('Capture Video'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    _arCoreController = controller;
    _addHairModel();
  }

  void _addHairModel() {
    final node = ArCoreNode(
      shape: ArCoreSphere(
        materials: [ArCoreMaterial(color: Colors.blue)],
        radius: 0.1,
      ),
      position: vector.Vector3(0, 0, -1),
    );
    _arCoreController?.addArCoreNode(node);
  }

  void _capturePhoto() {
    // Implement photo capture functionality
  }

  void _captureVideo() {
    // Implement video capture functionality
  }
}
