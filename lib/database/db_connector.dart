import 'package:sqflite/sqflite.dart';
import "package:spaced_repetition_software/database/card_repository.dart" as card_repository;
import "package:spaced_repetition_software/database/deck_repository.dart" as deck_repository;

class DBConnector {
  static Future<Database>? _dbConnection;

  static Future<void> connect() async {
    _dbConnection = openDatabase("learn-loop.db");
  }

  static Future<Database> getConnection () async {
    if (_dbConnection == null) {
      await connect();
    }
    return _dbConnection!;
  }

  static checkDbState() async {
    card_repository.ensureDbStructure();
    deck_repository.ensureDbStructure();
  }
}
