import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictacdash/user_provider.dart';

import 'splash_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserChangeNotifier>(
          create: (_) => UserChangeNotifier(),
        )
      ],
      child: MaterialApp(
        title: 'TicTacDash',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: SplashPage(),
      ),
    );
  }
}
