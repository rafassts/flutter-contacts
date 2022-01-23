import 'package:contacts/android/views/editor-contact.view.dart';
import 'package:contacts/android/widgets/contact-list-item.widget.dart';
import 'package:contacts/android/widgets/search-appbar.widget.dart';
import 'package:contacts/controllers/home.controller.dart';
import 'package:contacts/models/contact.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = HomeController();

  @override
  void initState() {
    super.initState();
    controller.search(""); //sempre busca
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        //não deixa retornar um appbar como widget
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: SearchAppBar(
          controller: controller,
        ),
      ),
      body: Observer(
        builder: (_) => ListView.builder(
          itemCount: controller.contacts.length,
          itemBuilder: (ctx, index) {
            return ContactListItem(model: controller.contacts[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditorContactView(
                model: new ContactModel(
                  id: 0,
                  name: "",
                  email: "",
                  phone: "",
                  image: "",
                  addressLine1: "",
                  addressLine2: "",
                  latLng: "",
                ),
              ),
            ),
          );
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
