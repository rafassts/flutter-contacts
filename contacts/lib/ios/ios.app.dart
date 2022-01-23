import 'package:contacts/ios/views/home.view.dart';
import 'package:contacts/ios/styles.dart';
import 'package:flutter/cupertino.dart';

class IosApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Contacts',
      theme: iosTheme(),
      debugShowCheckedModeBanner: false,
      home: HomeView(),
    );
  }
}
