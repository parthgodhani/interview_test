import 'package:flutterapp/services/auth.dart';

class transection {
  auth a = auth();
  final String tabelName = "transection";
  fnLoadData() async {
    if (auth.database == null) {
      await auth().fnInit();
    }
    List<Map<dynamic, dynamic>> data = await auth.database.query(this.tabelName, where: "userId = ${auth.authUserId}", orderBy: "id DESC");
    List<transectionModel> transectionData = [];
    for (var json in data) {
      transectionData.add(transectionModel.fromJson(json));
    }
    return transectionData;
  }

  fnSaveData(transectionModel data) async {
    if (auth.database == null) {
      await auth().fnInit();
    }
    int result = await auth.database.rawInsert('INSERT INTO ${this.tabelName}(userid, amount, flag, note,category) VALUES(?, ?,?,?,?)', [
      '${data.userId}',
      '${data.amount}',
      '${data.flag}',
      '${data.note}',
      '${data.category}'
    ]);

    return transectionModel(amount: data.amount, flag: data.flag, id: result, note: data.note, userId: data.userId, category: data.category);
  }
}

class transectionModel {
  final int userId;
  final int id;
  final String amount;
  final String flag;
  final String note;
  final String category;

  transectionModel({this.userId, this.id, this.amount, this.flag, this.note, this.category});

  factory transectionModel.fromJson(Map<String, dynamic> json) {
    return transectionModel(userId: json['userId'], id: json['id'], amount: json['amount'].toString(), flag: json['flag'], note: json['note'], category: json["category"]);
  }
}
