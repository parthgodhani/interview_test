import 'package:flutter/material.dart';
import 'package:flutterapp/pages/addTransection.dart';
import 'package:flutterapp/pages/home.dart';
import 'package:flutterapp/pages/login.dart';
import 'package:flutterapp/pages/signUp.dart';
import 'package:flutterapp/services/auth.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loadding = true;
  @override
  void initState() {
    this.fnLoadData();
    super.initState();
  }

  fnLoadData() async {
    auth a = auth();
    await a.fnInit();
    await a.fnCheckAuth();
    setState(() {
      this.loadding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loadding == true) {
      return Container(
        color: Colors.white,
      );
    }
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: {
        Login.routeName: (context) => Login(),
        signUp.routeName: (context) => signUp(),
        Home.routeName: (context) => Home(),
        addTransection.routeName: (context) => addTransection()
      },
      debugShowCheckedModeBanner: false,
      initialRoute: auth.authUserId != null ? Home.routeName : Login.routeName,
    );
  }
}
