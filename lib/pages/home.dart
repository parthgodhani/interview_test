import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/pages/addTransection.dart';
import 'package:flutterapp/services/transection.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  static const String routeName = "/Home";

  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  bool loadding = true;
  List<transectionModel> transectionData = [];
  transection transectionService = transection();

  @override
  void initState() {
    this.fnLoadData();
    super.initState();
  }

  void fnAddTransection() async {
    var data = await Navigator.of(context).pushNamed(addTransection.routeName);
    if (data != null) {
      setState(() {
        this.transectionData.insert(0, data);
      });
    }
  }

  void _settingModalBottomSheet(context) {
    List<Widget> listTile = addTransection.categoryes
        .map(
          (e) => ListTile(
              leading: Icon(Icons.file_download),
              title: Text('${e}'),
              onTap: () => {
                    this.fnExportData(context, e)
                  }),
        )
        .toList();
    listTile.insert(
        0,
        ListTile(
            leading: Icon(Icons.file_download),
            title: Text('INCOME'),
            onTap: () => {
                  this.fnExportData(context, 'INCOME')
                }));
    listTile.insert(
        0,
        ListTile(
            leading: Icon(Icons.file_download),
            title: Text('All'),
            onTap: () => {
                  this.fnExportData(context, "ALL")
                }));

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: listTile,
            ),
          );
        });
  }

  bool fileLoaddin = false;
  fnExportData(BuildContext context, String flag) async {
    Navigator.of(context).pop();
    setState(() {
      this.fileLoaddin = true;
    });
    var excel = Excel.createExcel();
    String sheet = await excel.getDefaultSheet();
    excel.updateCell(sheet, CellIndex.indexByString("A1"), "TYPE");
    excel.updateCell(sheet, CellIndex.indexByString("B1"), "category");
    excel.updateCell(sheet, CellIndex.indexByString("C1"), "note");
    excel.updateCell(sheet, CellIndex.indexByString("D1"), "amount");
    int j = 1;
    for (int index = 0; this.transectionData.length > index; index++) {
      if (this.transectionData[index].category == flag || flag == "ALL") {
        excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: j), this.transectionData[index].flag);
        excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: j), this.transectionData[index].category);
        excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: j), this.transectionData[index].note);
        excel.updateCell(sheet, CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: j), this.transectionData[index].amount);
        j = j + 1;
      }
    }
    excel.encode().then((onValue) async {
      final String dir = (await getApplicationDocumentsDirectory()).path;
      File("${dir}/excel.xlsx")
        ..createSync(recursive: true)
        ..writeAsBytesSync(onValue);
      var a = await OpenFile.open("${dir}/excel.xlsx", type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
      print(a.hashCode);
      print(a.type);
      setState(() {
        this.fileLoaddin = false;
      });
    });
  }

  fnLoadData() async {
    this.transectionData = await this.transectionService.fnLoadData();
    setState(() {
      this.loadding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: [
          FlatButton(
            textColor: Colors.white,
            onPressed: () {
              _settingModalBottomSheet(context);
            },
            child: Text("Export"),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      body: Stack(
        children: [
          loadding == true
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container(
                  padding: EdgeInsets.all(8.0),
                  child: ListView.builder(
                    itemCount: this.transectionData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        margin: EdgeInsets.all(4.0),
                        color: this.transectionData[index].flag == "INCOME" ? Colors.green.withOpacity(0.5) : Colors.red.withOpacity(0.5),
                        child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "${this.transectionData[index].category}",
                                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        "${this.transectionData[index].note}",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.topRight,
                                child: Text(
                                  "${this.transectionData[index].amount}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
          fileLoaddin == true
              ? Container(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Container()
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: fnAddTransection,
        tooltip: 'Add',
        child: Icon(Icons.add),
      ),
    );
  }
}
