import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class TakePictureView extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureView({required this.camera});

  @override
  _TakePictureState createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePictureView> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(
      widget.camera,
      ResolutionPreset.high,
    );
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  //retorna o caminho da foto
  Future<String> takePhoto() async {
    try {
      await _initializeControllerFuture;
      final imagePath = await _cameraController.takePicture();
      return imagePath.path;
    } catch (ex) {
      return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Nova Imagem",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 20,
          ),
        ),
      ),
      body: FutureBuilder(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.camera,
        ),
        onPressed: () {
          takePhoto().then((path) {
            Navigator.pop(context, path);
          });
        },
      ),
    );
  }
}
