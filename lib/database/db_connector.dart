import "package:spaced_repetition_software/database/migration.dart";
import 'package:sqflite/sqflite.dart';
import "package:spaced_repetition_software/database/card_repository.dart" as card_repository;
import "package:spaced_repetition_software/database/deck_repository.dart" as deck_repository;

class DBConnector {
  static Future<Database>? _dbConnection;

  static Future<void> connect() async {
    _dbConnection = openDatabase(
      "learn-loop.db",
      onCreate: (db, version) {
        card_repository.ensureDbStructure(db);
        deck_repository.ensureDbStructure(db);
      },
      version: 2,
      onUpgrade: (db, oldVersion, newVersion) {
        switch (oldVersion) {
          case 1:
            migrateFromVersion1(db);
          default:
            print("Migration successful");
        }
      },
    );
  }

  static Future<Database> getConnection() async {
    if (_dbConnection == null) {
      await connect();
    }
    return _dbConnection!;
  }
}
