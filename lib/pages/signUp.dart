import 'package:flutter/material.dart';
import 'package:flutterapp/pages/home.dart';
import 'package:flutterapp/services/auth.dart';

class signUp extends StatefulWidget {
  signUp({Key key, this.title}) : super(key: key);

  static const String routeName = "/signUp";

  final String title;

  @override
  _signUpState createState() => new _signUpState();
}

class _signUpState extends State<signUp> {
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  String phoneError;
  String passwordError;
  String authError;

  fnSignUp() async {
    if (this.phoneCtrl.text.toString().trim().length != 10) {
      setState(() {
        this.phoneError = "Please enter a valid phone no";
      });
      return;
    } else {
      setState(() {
        this.phoneError = null;
      });
    }
    if (this.passwordCtrl.text.toString().trim().length < 6) {
      setState(() {
        this.passwordError = "Please enter a valid password (minimum length 6)";
      });
      return;
    } else {
      setState(() {
        this.passwordError = null;
      });
    }
    String result = await auth().fnRegister(this.phoneCtrl.text.trim(), this.passwordCtrl.text.trim());
    if (result == "Success!") {
      this.authError = null;
      Navigator.of(context).pushReplacementNamed(Home.routeName);
    } else {
      setState(() {
        this.authError = result;
      });
    }
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              child: TextFormField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(labelText: "Phone No.", errorText: phoneError),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16.0),
              child: TextFormField(
                obscureText: true,
                controller: passwordCtrl,
                decoration: InputDecoration(labelText: "Password", errorText: passwordError),
              ),
            ),
            Container(
              child: RaisedButton(
                onPressed: this.fnSignUp,
                child: Text("Sign Up"),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16.0),
              child: authError != null ? Text("${authError}") : Center(),
            )
          ],
        ),
      ),
    );
  }
}
