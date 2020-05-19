import 'package:flutter/material.dart';
import 'package:flutterapp/pages/home.dart';
import 'package:flutterapp/pages/signUp.dart';
import 'package:flutterapp/services/auth.dart';

class Login extends StatefulWidget {
  static const String routeName = "/Login";

  @override
  _LoginState createState() => new _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  String phoneError;
  String passwordError;
  String authError;
  fnLogin() async {
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
    String result = await auth().fnLogin(this.phoneCtrl.text.trim(), this.passwordCtrl.text.trim());
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

  fnRouteToRegister() {
    Navigator.of(context).pushNamed(signUp.routeName);
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
              padding: EdgeInsets.only(top: 16.0),
              child: RaisedButton(
                onPressed: this.fnLogin,
                child: Text("Login"),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16.0),
              child: RaisedButton(
                onPressed: this.fnRouteToRegister,
                child: Text("Register"),
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
