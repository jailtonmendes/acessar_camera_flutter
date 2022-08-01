import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Chamando a instancia do imapicker para ser utilizada
  final ImagePicker _picker = ImagePicker();
  File? imagemSelecionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imagens'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          imagemSelecionada == null
              ? Container()
              : Padding(
                  padding: const EdgeInsets.all(100),
                  child: Image.file(imagemSelecionada!),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  getImageGallery();
                },
                icon: Icon(Icons.add_photo_alternate_outlined),
              ),
              IconButton(
                onPressed: () {
                  getCameraImage();
                },
                icon: Icon(Icons.photo_camera_outlined),
              ),
            ],
          )
        ],
      ),
    );
  }

//PEGAR IMAGEM DA GALERIA
  getImageGallery() async {
    final XFile? imagemTemporaria =
        await _picker.pickImage(source: ImageSource.gallery);

    try {
      if (imagemTemporaria != null) {
        File imagemCortada = await cortarImagem(File(imagemTemporaria.path));

        setState(() {
          imagemSelecionada = File(imagemCortada.path);
        });
      }
    } catch (e) {
      print(e);
    }
  }

//PEGAR IMAGEM DA CAMERA
  getCameraImage() async {
    final XFile? imagemTemporaria =
        await _picker.pickImage(source: ImageSource.camera);

    try {
      if (imagemTemporaria != null) {
        File imagemCortada = await cortarImagem(File(imagemTemporaria.path));
        setState(() {
          imagemSelecionada = File(imagemCortada.path);
        });
      }
    } catch (e) {
      print(e);
    }
  }

//CORTAR IMAGEM
  cortarImagem(File imagemTemporaria) async {
    return await ImageCropper()
        .cropImage(sourcePath: imagemTemporaria.path, aspectRatioPresets: [
      CropAspectRatioPreset.square,
      CropAspectRatioPreset.ratio16x9,
      CropAspectRatioPreset.ratio4x3
    ]);
  }
}
