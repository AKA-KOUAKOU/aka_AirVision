import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FacialAnalysisScreen extends StatefulWidget {
  const FacialAnalysisScreen({super.key});

  @override
  _FacialAnalysisScreenState createState() => _FacialAnalysisScreenState();
}

class _FacialAnalysisScreenState extends State<FacialAnalysisScreen> {
  CameraController? _controller;
  late FaceDetector _faceDetector;
  bool _isDetecting = false;
  String _analysisResult = '';
  double _confidence = 0.0;

  @override
  void initState() {
    super.initState();
    _faceDetector = GoogleMlKit.vision.faceDetector();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(frontCamera, ResolutionPreset.medium);
    await _controller!.initialize();
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('Facial Analysis')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Facial Analysis')),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple.shade50, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                    child: CameraPreview(_controller!),
                  ),
                  if (_analysisResult.isNotEmpty)
                    Positioned(
                      bottom: 20,
                      left: 20,
                      right: 20,
                      child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        color: Colors.black.withOpacity(0.7),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            _analysisResult,
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    'Analysis Progress',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  LinearProgressIndicator(
                    value: _confidence / 100,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple.shade700),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Confidence: ${_confidence.toStringAsFixed(1)}%',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _analyzeFace,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Analyze Face', style: TextStyle(fontSize: 18)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _analyzeFace() async {
    if (_isDetecting) return;
    _isDetecting = true;

    try {
      final image = await _controller!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        final face = faces.first;
        // Simple analysis based on face contours
        String faceShape = 'Unknown';
        if (face.boundingBox.width > face.boundingBox.height * 1.2) {
          faceShape = 'Oval';
        } else if (face.boundingBox.width < face.boundingBox.height * 0.9) {
          faceShape = 'Round';
        } else {
          faceShape = 'Square';
        }

        setState(() {
          _analysisResult = 'Face Shape: $faceShape\nSkin Tone: To be implemented';
          _confidence = 90.0; // Dummy confidence value
        });
      } else {
        setState(() {
          _analysisResult = 'No face detected';
          _confidence = 0.0;
        });
      }
    } catch (e) {
      setState(() {
        _analysisResult = 'Error: $e';
        _confidence = 0.0;
      });
    } finally {
      _isDetecting = false;
    }
  }
}
