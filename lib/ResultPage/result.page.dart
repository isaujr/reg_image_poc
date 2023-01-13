import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageInfos {
  final double size;
  // final double width;
  // final double height;
  final double percentageCompression;

  const ImageInfos({
    required this.size,
    // required this.width,
    // required this.height,
    required this.percentageCompression,
  });
}

class ResultPage extends StatefulWidget {
  final File originalFile;

  const ResultPage({
    Key? key,
    required this.originalFile,
  }) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool isLoading = false;
  late File compressedImageFile;
  double currentCompressPercentage = 0;
  Timer? timerChangeCompressionDebounce;

  late ImageInfos currentFileInfos;
  late ImageInfos compressedFileInfos;

  @override
  void initState() {
    processImage();
    super.initState();
  }

  void updateCompressionPercentage(double newValue) {
    setState(() {
      currentCompressPercentage = newValue;
    });

    if (timerChangeCompressionDebounce != null &&
        timerChangeCompressionDebounce!.isActive) {
      timerChangeCompressionDebounce?.cancel();
    }

    timerChangeCompressionDebounce = Timer(Duration(seconds: 1), () {
      processImage();
    });
  }

  Future<double> _getSizeFile(File file) async {
    int bytesFile = await file.length();
    return bytesFile / 1000000;
  }

  void processImage() async {
    setState(() {
      isLoading = true;
    });
    compressedImageFile = (await compressImage(widget.originalFile.path))!;

    currentFileInfos = ImageInfos(
      size: await _getSizeFile(widget.originalFile),
      // width: 1024,
      // height: 740,
      percentageCompression: 0,
    );

    compressedFileInfos = ImageInfos(
      size: await _getSizeFile(compressedImageFile),
      // width: 1024,
      // height: 720,
      percentageCompression: currentCompressPercentage,
    );

    setState(() {
      isLoading = false;
    });
  }

  Future<File?> compressImage(String path) {
    int newQuality = 100 - (currentCompressPercentage * 100).toInt();

    return FlutterImageCompress.compressAndGetFile(
      path,
      path.replaceAll('.jpg', '_compressed.jpg'),
      // minHeight: 1024,
      // minWidth: 720,
      autoCorrectionAngle: false,
      quality: newQuality,
    );
  }

  Widget _buildInfosImage(ImageInfos imageInfos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: Text('Taxa de compressão:'),
          trailing: Text(
              '${(imageInfos.percentageCompression * 100).roundToDouble()}%'),
        ),
        // ListTile(
        //   title: Text('Altura:'),
        //   trailing: Text('${imageInfos.height.toStringAsFixed(2)}px'),
        // ),
        // ListTile(
        //   title: Text('Largura'),
        //   trailing: Text('${imageInfos.width.toStringAsFixed(2)}px'),
        // ),
        ListTile(
          title: Text('Tamanho:'),
          trailing: Text("${imageInfos.size.toStringAsFixed(4)}Mb"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Resultado'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Imagem atual:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  _buildInfosImage(currentFileInfos),
                  Divider(),
                  Text(
                    'Imagem tratada:',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  _buildInfosImage(compressedFileInfos),
                ],
              ),
            ),
      bottomSheet: Container(
        height: 120,
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Text(
              'Taxa de compressão',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              '${(currentCompressPercentage * 100).roundToDouble()}%',
              style: TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Slider(
              onChanged: updateCompressionPercentage,
              value: currentCompressPercentage,
            ),
          ],
        ),
      ),
    );
  }
}
