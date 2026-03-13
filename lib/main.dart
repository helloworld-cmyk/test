import 'package:flutter/material.dart';
import 'package:crop_image/crop_image.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crop Image Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CropImageScreen(),
    );
  }
}

class CropImageScreen extends StatefulWidget {
  const CropImageScreen({super.key});

  @override
  State<CropImageScreen> createState() => _CropImageScreenState();
}

class _CropImageScreenState extends State<CropImageScreen> {
  static const Rect _initialCrop = Rect.fromLTRB(0.1, 0.1, 0.9, 0.9);
  final CropController _controller = CropController(
    aspectRatio: 1.0,
    defaultCrop: _initialCrop,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crop Image Demo')),
      body: Center(
        child: CropImage(
          controller: _controller,
          image: Image.asset('lib/assets/anh-ha-noi.jpg'),
          paddingSize: 24,
          alwaysMove: true,
          maximumImageSize: 500,
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(onPressed: _resetCrop, icon: const Icon(Icons.close)),
              IconButton(
                onPressed: _selectAspectRatio,
                icon: const Icon(Icons.aspect_ratio),
              ),
              IconButton(
                onPressed: _controller.rotateLeft,
                icon: const Icon(Icons.rotate_90_degrees_ccw_outlined),
              ),
              IconButton(
                onPressed: _controller.rotateRight,
                icon: const Icon(Icons.rotate_90_degrees_cw_outlined),
              ),
              TextButton(onPressed: _showResult, child: const Text('Done')),
            ],
          ),
        ),
      ),
    );
  }

  void _resetCrop() {
    _controller.rotation = CropRotation.up;
    _controller.crop = _initialCrop;
    _controller.aspectRatio = 1;
  }

  Future<void> _selectAspectRatio() async {
    final double? value = await showDialog<double>(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          title: const Text('Select aspect ratio'),
          children: [
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, -1.0),
              child: const Text('Free'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, 1.0),
              child: const Text('1:1'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, 4.0 / 3.0),
              child: const Text('4:3'),
            ),
            SimpleDialogOption(
              onPressed: () => Navigator.pop(dialogContext, 16.0 / 9.0),
              child: const Text('16:9'),
            ),
          ],
        );
      },
    );

    if (value == null) {
      return;
    }

    _controller.aspectRatio = value == -1 ? null : value;
    _controller.crop = _initialCrop;
  }

  Future<void> _showResult() async {
    final Image croppedImage = await _controller.croppedImage();
    if (!mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return SimpleDialog(
          contentPadding: const EdgeInsets.all(8),
          title: const Text('Cropped Image'),
          children: [
            const SizedBox(height: 8),
            croppedImage,
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
