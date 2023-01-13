import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_poc/ResultPage/result.page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();
  late File originalFile;

  Future<String> _getBytes(String path) async {
    ByteData byteData = await rootBundle.load(path);

    Uint8List bytes = byteData.buffer.asUint8List();

    return base64.encode(bytes);
  }

  void _captureImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      // maxHeight: 1024,
      // maxWidth: 720,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      originalFile = File(pickedFile.path);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultPage(
            originalFile: originalFile,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text('POC Senff compressão de imagem'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _captureImage,
          child: Text('Selecionar imagem'),
        ),
      ),
    );
  }
}
