import 'dart:io';

import 'package:contacts/ios/styles.dart';
import 'package:contacts/ios/views/details.view.dart';
import 'package:contacts/models/contact.model.dart';
import 'package:contacts/settings.dart';
import 'package:flutter/cupertino.dart';

class ContactListItem extends StatelessWidget {
  final ContactModel model;

  const ContactListItem({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: model.image == ""
                  ? AssetImage(DEFAULT_PROFILE_PICTURE_PATH) as ImageProvider
                  : FileImage(
                      File(model.image),
                    ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  model.name,
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  model.phone,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
        CupertinoButton(
            child: Icon(
              CupertinoIcons.person,
              color: primaryColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => DetailsView(
                    id: model.id ?? 0,
                  ),
                ),
              );
            }),
      ],
    );
  }
}
