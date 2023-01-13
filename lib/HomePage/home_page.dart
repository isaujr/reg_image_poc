import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _picker = ImagePicker();

  Future<String> _getBytes(String path) async {
    ByteData byteData = await rootBundle.load(path);

    Uint8List bytes = byteData.buffer.asUint8List();

    return base64.encode(bytes);
  }

  void _captureImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
    );

    if (pickedFile != null) {
      File file = File(pickedFile.path);
      int bytesFile = await file.length();
      double realFileSizeMb = bytesFile / 1000000;
      print("This file has ${realFileSizeMb.toStringAsFixed(2)}Mb");
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        decoration: const BoxDecoration(
          color: Colors.white24,
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 200),
            Center(
              child: GestureDetector(
                onTap: _captureImage,
                child: Container(
                  width: size.width * 0.7,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(4),
                    // border: Border.all(color: Colors.black38),
                  ),
                  child: const Center(
                    child: Text(
                      'Selecione uma imagem*',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
