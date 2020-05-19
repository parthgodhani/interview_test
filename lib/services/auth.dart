import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class auth {
  static Database database;
  static String authUserId;
  static String authUserphone;
  Future<dynamic> fnInit() async {
    auth.database = await openDatabase("db.db", version: 1, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT, phone TEXT, password TEXT)');
      await db.execute('CREATE TABLE IF NOT EXISTS transection (id INTEGER PRIMARY KEY AUTOINCREMENT, userid INTEGER, amount REAL,flag TEXT,note TEXT,category TEXT)');
    });
  }

  Future<String> fnLogin(String phone, String password) async {
    if (auth.database == null) {
      print(auth.database);
      await this.fnInit();
    }
    List<Map> users = await auth.database.query("users", where: "phone = $phone");
    if (users.length == 0) {
      return "Phone No not availabel. PLease try with sign Up";
    }
    if (users.first == null) {
      return "Phone No not availabel. PLease try with sign Up";
    }
    if (users.first["password"] != password) {
      return "Wrong password!";
    }
    if (users.first["password"] == password) {
      await this.fnSetAuthUser(users.first);
      return "Success!";
    }
    return "something went wrong try again later!";
  }

  Future<String> fnRegister(String phone, String password) async {
    if (auth.database == null) {
      await this.fnInit();
    }
    List<Map> users = await auth.database.query("users", where: "phone = $phone");
    if (users.length > 0 && users.first != null) {
      return "Phone No is already availabel please try with login!";
    } else {
      var result = await auth.database.rawInsert('INSERT INTO users(phone, password) VALUES(?, ?)', [
        '$phone',
        '$password'
      ]);
      print(result);
      await this.fnSetAuthUser({
        "id": result,
        "phone": phone
      });
      return "Success!";
    }
    return "something went wrong try again later!";
  }

  Future<dynamic> fnSetAuthUser(Map<dynamic, dynamic> user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("phone", user["phone"]);
    await prefs.setString("id", user["id"].toString());
    auth.authUserId = user["id"].toString();
    auth.authUserphone = user["phone"];
  }

  Future<dynamic> fnCheckAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String phone = await prefs.getString("phone");
    String id = await prefs.getString("id");
    auth.authUserId = id;
    auth.authUserphone = phone;
  }
}
