import 'dart:io';
import 'package:contacts/android/views/details.view.dart';
import 'package:contacts/models/contact.model.dart';
import 'package:contacts/settings.dart';
import 'package:flutter/material.dart';

class ContactListItem extends StatelessWidget {
  final ContactModel model;

  const ContactListItem({required this.model});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(model.name),
      subtitle: Text(model.phone),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(48),
          image: new DecorationImage(
            fit: BoxFit.cover,
            image: model.image != ""
                ? FileImage(File(model.image))
                : AssetImage(DEFAULT_PROFILE_PICTURE_PATH) as ImageProvider,
          ),
        ),
      ),
      trailing: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailsView(id: model.id ?? 0),
            ),
          );
        },
        child: Icon(
          Icons.person,
          color: Theme.of(context).primaryColor,
        ),
      ),
    );
  }
}
