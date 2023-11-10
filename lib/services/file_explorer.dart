import 'package:spaced_repetition_software/model/deck.dart';
import '../model/card.dart';
import 'db_connector.dart';

checkForTables() async {
  var db = await DBConnector.getConnection();

  var cardTable = await db.query("sqlite_master", where: "type = ? AND name = ?", whereArgs: ['table', 'card']);
  if (cardTable.isEmpty) {
    await db.execute("""
      CREATE TABLE card (
        id INTEGER PRIMARY KEY,
        front TEXT,
        back TEXT,
        deck_id INTEGER,
        repeat_next DateTime,
        repeat_last INTEGER
      )""");
  }

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

Future<List<Card>> getCards(int deckId) async {
  var db = await DBConnector.getConnection();
  var cards = await db.query("card", where: "deck_id = $deckId");
  return cards.map((f) => Card.fromMap(f)).toList();
}

getCardsToLearn() async {
  var db = await DBConnector.getConnection();
  var cards = await db.query("card", where: "repeat_next <= CURRENT_TIMESTAMP");
  return cards;
}

addCard(String front, String back, int deckId) async {
  var db = await DBConnector.getConnection();
  await db.insert("card", {
    "front": front,
    "back": back,
    "deck_id": deckId,
    "repeat_next": DateTime.now().toIso8601String(),
    "repeat_last": 0
  });
}

addDeck(String name, int parentId) async {
  var db = await DBConnector.getConnection();
  await db.insert("deck", {"name": name, "parent_id": parentId});
}