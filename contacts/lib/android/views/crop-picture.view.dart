import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_crop/image_crop.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

class CropPictureView extends StatefulWidget {
  final String path;

  const CropPictureView({Key? key, required this.path}) : super(key: key);

  @override
  _CropPictureViewState createState() => _CropPictureViewState();
}

class _CropPictureViewState extends State<CropPictureView> {
  final cropKey = GlobalKey<CropState>();

  Future<String> save() async {
    try {
      final uuid = Uuid();
      final fileName = "${uuid.v4()}.jpg";
      final path =
          join((await getApplicationDocumentsDirectory()).path, fileName);

      final area = cropKey.currentState?.area;

      if (area == null) return "";

      final croppedFile = await ImageCrop.cropImage(
        file: File(widget.path),
        area: area,
      );

      //não tem a camera para salvar os itens, então precisa usar este trecho
      final bytes = await croppedFile.readAsBytes();
      final buffer = bytes.buffer;

      File(path).writeAsBytes(
        buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
      );
      //

      return path;
    } catch (ex) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Recortar Imagem",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 20,
          ),
        ),
      ),
      body: Crop(
        key: cropKey,
        aspectRatio: 1 / 1, //recorte quadrado
        image: FileImage(
          File(widget.path),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: () {
          save().then((path) {
            Navigator.pop(context, path);
          });
        },
      ),
    );
  }
}
