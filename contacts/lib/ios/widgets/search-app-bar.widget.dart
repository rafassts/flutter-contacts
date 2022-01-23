import 'package:contacts/controllers/home.controller.dart';
import 'package:contacts/ios/views/editor-contact.view.dart';
import 'package:contacts/models/contact.model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SearchAppBar extends StatelessWidget with ObstructingPreferredSizeWidget {
  final HomeController homeController;

  const SearchAppBar({Key? key, required this.homeController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoNavigationBar(
      leading: GestureDetector(
        onTap: () {
          if (homeController.showSearch) {
            homeController.search("");
          }
          homeController.toggleSearch();
        },
        child: Observer(
          builder: (_) => Icon(homeController.showSearch
              ? CupertinoIcons.clear
              : CupertinoIcons.search),
        ),
      ),
      trailing: GestureDetector(
        child: Icon(CupertinoIcons.add),
        onTap: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
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
      ),
      middle: Observer(
        builder: (_) => homeController.showSearch
            ? CupertinoTextField(
                autofocus: true,
                placeholder: "Pesquisar...",
                onSubmitted: (val) {
                  homeController.search(val);
                },
              )
            : Text("Meus Contatos"),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(52);

  @override
  bool shouldFullyObstruct(BuildContext context) {
    return true;
  }
}
