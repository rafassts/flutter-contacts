import 'package:contacts/android/views/home.view.dart';
import 'package:contacts/models/contact.model.dart';
import 'package:contacts/repositories/contact.repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
      MaterialPageRoute(
        builder: (context) => HomeView(),
      ),
    );
  }

  onError() {
    var snackBar = new SnackBar(content: new Text("Ops! Algo deu errado."));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widget.model.id == 0
            ? Text(
                "Novo Contato",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 20),
              )
            : Text(
                widget.model.name,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 20),
              ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  labelText: "Nome",
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                initialValue: widget.model.name,
                onChanged: (value) {
                  widget.model.name = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nome inválido';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  labelText: "Telefone",
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                initialValue: widget.model.phone,
                onChanged: (value) {
                  widget.model.phone = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'telefone inválido';
                  }
                  return null;
                },
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                initialValue: widget.model.email,
                onChanged: (value) {
                  widget.model.email = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email inválido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
                onPressed: onSubmit,
                child: Container(
                  height: 30,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save,
                        color: Theme.of(context).accentColor,
                      ),
                      SizedBox(width: 10),
                      Text(
                        "Salvar",
                        style: TextStyle(
                          color: Theme.of(context).accentColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
