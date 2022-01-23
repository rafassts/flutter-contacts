import 'package:camera/camera.dart';
import 'package:contacts/android/views/address.view.dart';
import 'package:contacts/android/views/crop-picture.view.dart';
import 'package:contacts/android/views/home.view.dart';
import 'package:contacts/android/views/loading.view.dart';
import 'package:contacts/android/views/take-picture.view.dart';
import 'package:contacts/models/contact.model.dart';
import 'package:contacts/repositories/contact.repository.dart';
import 'package:contacts/shared/styles.dart';
import 'package:contacts/shared/widgets/contact-details-description.widget.dart';
import 'package:contacts/shared/widgets/contact-details-image.widget.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'editor-contact.view.dart';

class DetailsView extends StatefulWidget {
  final int id;

  const DetailsView({Key? key, required this.id}) : super(key: key);

  @override
  _DetailsViewState createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  final _repository = new ContactRepository();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _repository.getContactById(widget.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          ContactModel contact = snapshot.data as ContactModel;
          return page(context, contact);
        } else {
          return LoadingView();
        }
      },
    );
  }

  Widget page(BuildContext context, ContactModel model) {
    onDeleteSuccess() {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeView(),
        ),
      );
    }

    onDeleteError(err) {
      print(err);
    }

    delete() {
      _repository.delete(widget.id).then((_) {
        onDeleteSuccess();
      }).catchError((err) {
        onDeleteError(err);
      });
    }

    onDelete() {
      showDialog(
          context: context,
          builder: (ctx) {
            return new AlertDialog(
              title: new Text("Exclusão de Contato"),
              content: new Text("Deseja excluir este contato?"),
              actions: [
                TextButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Confirmar"),
                  onPressed: () {
                    delete();
                  },
                ),
              ],
            );
          });
    }

    updateImage(path) {
      _repository.updateImage(widget.id, path).then((_) {
        setState(() {});
      });
    }

    cropPicture(path) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CropPictureView(path: path),
        ),
      ).then((imagePath) {
        updateImage(imagePath);
      });
    }

    takePicture() async {
      final cameras = await availableCameras();
      final firstCamera = cameras.first;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakePictureView(
            camera: firstCamera,
          ),
        ),
      ).then((path) {
        cropPicture(path);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Contato",
          style: TextStyle(
            color: Theme.of(context).primaryColor,
            fontSize: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
            width: double.infinity,
          ),
          ContactDetailsImage(image: model.image),
          SizedBox(height: 10),
          ContactDetailsDescription(
              name: model.name, phone: model.phone, email: model.email),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  launch("tel://${model.email}");
                },
                child: Icon(
                  Icons.phone,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              TextButton(
                onPressed: () {
                  launch("mailto://${model.email}");
                },
                child: Icon(
                  Icons.email,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              TextButton(
                onPressed: takePicture,
                child: Icon(
                  Icons.camera_enhance,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
          ListTile(
            isThreeLine: true,
            title: Text(
              "Endereço",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.addressLine1 != ""
                      ? model.addressLine1
                      : "Nenhum endereço cadastrado",
                  style: TextStyle(fontSize: 12),
                ),
                Text(
                  model.addressLine2 != ""
                      ? model.addressLine2
                      : "Nenhum endereço cadastrado",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
            trailing: TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddressView(
                      model: model,
                    ),
                  ),
                ).then((_) {
                  setState(() {}); //recarrega a página
                });
              },
              child: Icon(
                Icons.pin_drop,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              width: double.infinity,
              height: 50,
              color: Color(0xFFFF0000),
              child: TextButton(
                child: Text(
                  "Excluir",
                  style: TextStyle(
                    color: baseAccentColor,
                  ),
                ),
                onPressed: onDelete,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditorContactView(
                model: new ContactModel(
                  id: model.id,
                  name: model.name,
                  email: model.email,
                  phone: model.phone,
                  addressLine1: model.addressLine1,
                  addressLine2: model.addressLine2,
                  image: model.image,
                  latLng: model.latLng,
                ),
              ),
            ),
          );
        },
        child: Icon(
          Icons.edit,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
