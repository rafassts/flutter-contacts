import 'package:contacts/ios/styles.dart';
import 'package:contacts/ios/views/address.view.dart';
import 'package:contacts/ios/views/editor-contact.view.dart';
import 'package:contacts/ios/views/home.view.dart';
import 'package:contacts/ios/views/loading.view.dart';
import 'package:contacts/models/contact.model.dart';
import 'package:contacts/repositories/contact.repository.dart';
import 'package:contacts/shared/widgets/contact-details-description.widget.dart';
import 'package:contacts/shared/widgets/contact-details-image.widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsView extends StatefulWidget {
  final int id;

  const DetailsView({Key? key, required this.id}) : super(key: key);

  @override
  _DetailsViewState createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  final _repository = new ContactRepository();

  onDelete() {
    showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return new CupertinoAlertDialog(
            title: new Text("Exclusão de Contato"),
            content: new Text("Deseja excluir este contato?"),
            actions: [
              CupertinoButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              CupertinoButton(child: Text("Excluir"), onPressed: delete),
            ],
          );
        });
  }

  delete() {
    _repository.delete(widget.id).then((_) {
      onSuccess();
    }).catchError((err) {
      onError(err);
    });
  }

  onSuccess() {
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => HomeView(),
      ),
    );
  }

  onError(err) {
    print(err);
  }

  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _repository.getContactById(widget.id),
      builder: (ctx, snp) {
        if (snp.hasData) {
          ContactModel contact = snp.data as ContactModel;
          return CupertinoPageScaffold(
            child: CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text(
                    "Contato",
                    style: TextStyle(color: primaryColor, fontSize: 24),
                  ),
                  trailing: GestureDetector(
                    child: Icon(
                      CupertinoIcons.pen,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) =>
                              EditorContactView(model: contact),
                        ),
                      );
                    },
                  ),
                ),
                SliverFillRemaining(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                        width: double.infinity,
                      ),
                      ContactDetailsImage(image: contact.image),
                      SizedBox(height: 10),
                      ContactDetailsDescription(
                        name: contact.name,
                        phone: contact.phone,
                        email: contact.email,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          CupertinoButton(
                            child: Icon(CupertinoIcons.phone),
                            onPressed: () {
                              launch("tel://${contact.phone}");
                            },
                          ),
                          CupertinoButton(
                            child: Icon(CupertinoIcons.mail),
                            onPressed: () {
                              launch("mailto://${contact.email}");
                            },
                          ),
                          CupertinoButton(
                            child: Icon(CupertinoIcons.photo_camera),
                            onPressed: () {},
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(width: double.infinity),
                                  Text(
                                    "Endereço",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    contact.addressLine1 != ""
                                        ? contact.addressLine1
                                        : "Nenhum endereço cadastrado",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Text(
                                    contact.addressLine2 != ""
                                        ? contact.addressLine2
                                        : "",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            CupertinoButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => AddressView(),
                                  ),
                                );
                              },
                              child: Icon(
                                CupertinoIcons.location,
                                color: primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      CupertinoButton.filled(
                        child: Text("Excluir Contato"),
                        onPressed: onDelete,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else {
          return LoadingView();
        }
      },
    );
  }
}
