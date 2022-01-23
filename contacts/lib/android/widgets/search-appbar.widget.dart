import 'package:contacts/controllers/home.controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class SearchAppBar extends StatefulWidget {
  final HomeController controller;

  SearchAppBar({required this.controller});

  @override
  _SearchAppBarState createState() => _SearchAppBarState();
}

class _SearchAppBarState extends State<SearchAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: TextButton(
        onPressed: () {
          if (widget.controller.showSearch) widget.controller.search("");
          widget.controller.toggleSearch();
        },
        child: Observer(
          builder: (_) => Icon(
            widget.controller.showSearch ? Icons.close : Icons.search,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      title: Observer(
        builder: (_) => widget.controller.showSearch
            ? TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Pesquisar...",
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                onSubmitted: (value) {
                  widget.controller.search(value);
                },
              )
            : Text(
                "Contatos",
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 20),
              ),
      ),
    );
  }
}
