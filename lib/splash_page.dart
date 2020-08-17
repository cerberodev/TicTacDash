import 'package:after_layout/after_layout.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictacdash/home_page.dart';
import 'package:tictacdash/user_provider.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with AfterLayoutMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.yellow[200],
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void afterFirstLayout(BuildContext context) async {
    AuthResult result = await _auth.signInAnonymously();
    String uid = result.user.uid;
    Provider.of<UserChangeNotifier>(context, listen: false).updateUserId(uid);

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return HomePage();
    }));
  }
}
