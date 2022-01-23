import 'package:contacts/android/views/home.view.dart';
import 'package:contacts/controllers/auth.controller.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  @override
  _SplashViewState createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final controller = new AuthController();

  @override
  void initState() {
    super.initState();
    controller.authenticate().then((value) {
      if (value == true) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomeView(),
          ),
        );
      } else {}
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: double.infinity),
          Icon(
            Icons.fingerprint,
            size: 72,
            color: Theme.of(context).accentColor,
          ),
          SizedBox(height: 20),
          Text(
            "Meus Contatos",
            style: TextStyle(
              fontSize: 24,
              color: Theme.of(context).accentColor,
            ),
          )
        ],
      ),
    );
  }
}
