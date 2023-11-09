import 'package:sqflite/sqflite.dart';

class DBConnector {
  static Future<Database>? _dbConnection;

  static Future<void> connect() async {
    _dbConnection = openDatabase("card_store.db");
  }

  static Future<Database> getConnection () async {
    if (_dbConnection == null) {
      await connect();
    }
    return _dbConnection!;
  }
}
