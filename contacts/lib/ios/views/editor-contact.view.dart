import 'package:contacts/ios/styles.dart';
import 'package:contacts/ios/views/home.view.dart';
import 'package:contacts/models/contact.model.dart';
import 'package:contacts/repositories/contact.repository.dart';
import 'package:flutter/cupertino.dart';

class EditorContactView extends StatefulWidget {
  final ContactModel model;

  EditorContactView({required this.model});

  @override
  _EditorContactViewState createState() => _EditorContactViewState();
}

class _EditorContactViewState extends State<EditorContactView> {
  final _formKey = new GlobalKey<FormState>();
  final _repository = new ContactRepository();

  onSubmit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    //se estiver trabalhando com onSave ao invés de onChanged, tem que salvar
    //_formKey.currentState.save();

    if (widget.model.id == 0) {
      create();
    } else {
      update();
    }
  }

  create() {
    widget.model.id = null;
    widget.model.image = "";
    _repository.create(widget.model).then((_) {
      onSuccess();
    }).catchError((_) {
      onError();
    });
  }

  update() {
    _repository.update(widget.model).then((_) {
      onSuccess();
    }).catchError((_) {
      onError();
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

  onError() {
    showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return new CupertinoAlertDialog(
            title: new Text("Falha na operação"),
            content: new Text("Ops, parece que deu ruim"),
            actions: [
              CupertinoButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: widget.model.id == 0
                ? Text(
                    "Novo Contato",
                    style: TextStyle(color: primaryColor, fontSize: 24),
                  )
                : Text(
                    "Editar Contato",
                    style: TextStyle(color: primaryColor, fontSize: 24),
                  ),
          ),
          SliverFillRemaining(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CupertinoTextField(
                      placeholder:
                          widget.model.name != "" ? widget.model.name : "Nome",
                      textCapitalization: TextCapitalization.words,
                      keyboardType: TextInputType.text,
                      onChanged: (val) {
                        widget.model.name = val;
                      },
                    ),
                    SizedBox(height: 20),
                    CupertinoTextField(
                      placeholder: widget.model.phone != ""
                          ? widget.model.phone
                          : "Telefone",
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        widget.model.phone = val;
                      },
                    ),
                    SizedBox(height: 20),
                    CupertinoTextField(
                      placeholder: widget.model.email != ""
                          ? widget.model.email
                          : "Email",
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (val) {
                        widget.model.email = val;
                      },
                    ),
                    SizedBox(height: 20),
                    CupertinoButton.filled(
                      child: Text(
                        "Salvar",
                        style: TextStyle(color: accentColor),
                      ),
                      onPressed: onSubmit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
