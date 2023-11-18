import 'package:spaced_repetition_software/database/db_connector.dart';
import 'package:spaced_repetition_software/models/deck.dart';

Future<void> ensureDbStructure() async {
  var db = await DBConnector.getConnection();

  var deckTable = await db.query("sqlite_master", where: "type = ? AND name = ?", whereArgs: ['table', 'deck']);
  if (deckTable.isEmpty) {
    await db.execute("CREATE TABLE deck (id INTEGER PRIMARY KEY, name TEXT, parent_id INTEGER)");
  }
}

Future<List<Deck>> getDecks(int parentId) async {
  var db = await DBConnector.getConnection();
  var folders = await db.query("deck", where: "parent_id = $parentId");
  return folders.map((f) => Deck.fromMap(f)).toList();
}

addDeck(String name, int parentId) async {
  var db = await DBConnector.getConnection();
  await db.insert("deck", {"name": name, "parent_id": parentId});
}

Future<void> updateDeck(Deck deck) async {
  var db = await DBConnector.getConnection();
  await db.update("deck", {"name": deck.name, "parent_id": deck.parentId}, where: "id = ${deck.id}");
}

Future<void> deleteDeckById(int deckId) async {
  var db = await DBConnector.getConnection();
  await db.delete("deck", where: "id = $deckId");
}
