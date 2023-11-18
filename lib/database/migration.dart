import "package:sqflite/sqflite.dart";

Future<void> migrateFromVersion1(Database db) async {
  await db.execute("""
    CREATE TABLE card_new (
      id INTEGER PRIMARY KEY,
      front TEXT,
      back_text TEXT,
      back_image BLOB,
      deck_id INTEGER,
      repeat_next TEXT,
      repeat_last INTEGER
    );
  """);

  await db.execute("""
    INSERT INTO card_new (id, front, back_text, back_image, deck_id, repeat_next, repeat_last)
    SELECT id, front, back, NULL, deck_id, repeat_next, repeat_last FROM card;
  """);

  await db.execute("DROP TABLE card");

  await db.execute("""
    ALTER TABLE card_new RENAME TO card;
  """);
}
