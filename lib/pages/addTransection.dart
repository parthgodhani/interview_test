import 'package:flutter/material.dart';
import 'package:flutterapp/services/auth.dart';
import 'package:flutterapp/services/transection.dart';

class addTransection extends StatefulWidget {
  static const String routeName = "/addTransection";
  static List<String> categoryes = [
    "Personal",
    "Airfare",
    "Rant",
    "Phone",
    "Other"
  ];
  @override
  _addTransectionState createState() => new _addTransectionState();
}

class _addTransectionState extends State<addTransection> {
  TextEditingController amountCtrl = TextEditingController();
  TextEditingController noteCtrl = TextEditingController();
  String amountError;
  String amountFlag = "INCOME";
  String category = "Personal";

  transection transectionService = transection();

  fnSave() async {
    if (amountCtrl.text.trim() == "") {
      setState(() {
        this.amountError = "Please Enter a amount";
      });
      return;
    }
    transectionModel data = transectionModel(userId: int.parse(auth.authUserId), note: this.noteCtrl.text, id: null, flag: this.amountFlag, amount: this.amountCtrl.text, category: this.amountFlag == "INCOME" ? "INCOME" : this.category);
    data = await transectionService.fnSaveData(data);
    Navigator.of(context).pop(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              child: TextFormField(
                controller: amountCtrl,
                keyboardType: TextInputType.numberWithOptions(decimal: false, signed: false),
                decoration: InputDecoration(labelText: "Amount", errorText: amountError),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16.0),
              child: DropdownButtonFormField<String>(
                value: this.amountFlag,
                items: <String>[
                  'INCOME',
                  'EXPENCE'
                ].map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                isDense: true,
                decoration: InputDecoration(labelText: "Type"),
                onChanged: (value) {
                  setState(() {
                    this.amountFlag = value;
                  });
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16.0),
              child: DropdownButtonFormField<String>(
                value: this.category,
                items: addTransection.categoryes.map((String value) {
                  return new DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                isDense: true,
                decoration: InputDecoration(labelText: "Type"),
                onChanged: this.amountFlag == "INCOME"
                    ? null
                    : (value) {
                        setState(() {
                          this.category = value;
                        });
                      },
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16.0),
              child: TextFormField(
                controller: noteCtrl,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Note", errorText: amountError),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 16.0),
              child: RaisedButton(
                child: Text("Submit"),
                onPressed: this.fnSave,
              ),
            )
          ],
        ),
      ),
    );
  }
}
