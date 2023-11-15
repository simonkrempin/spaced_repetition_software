import 'package:spaced_repetition_software/model/deck.dart';
import 'package:spaced_repetition_software/utils/date.dart';
import 'package:spaced_repetition_software/model/card.dart';
import 'package:spaced_repetition_software/database/db_connector.dart';

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
        repeat_next TEXT,
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

Future<List<Card>> getCardsToLearn() async {
  var db = await DBConnector.getConnection();
  var cards = await db.query("card", where: "repeat_next <= date(CURRENT_TIMESTAMP)", orderBy: "repeat_last ASC");
  return cards.map((f) => Card.fromMap(f)).toList();
}

addCard(String front, String back, int deckId) async {
  var db = await DBConnector.getConnection();
  await db.insert("card", {
    "front": front,
    "back": back,
    "deck_id": deckId,
    "repeat_next": getCurrentDate(),
    "repeat_last": 0
  });
}

addDeck(String name, int parentId) async {
  var db = await DBConnector.getConnection();
  await db.insert("deck", {"name": name, "parent_id": parentId});
}

updateCard(Card card) async {
  var db = await DBConnector.getConnection();
  await db.update("card", {
    "front": card.front,
    "back": card.back,
    "deck_id": card.deckId
  }, where: "id = ${card.id}");
}

Future<void> updateDeck(Deck deck) async {
  var db = await DBConnector.getConnection();
  await db.update("deck", {"name": deck.name, "parent_id": deck.parentId}, where: "id = ${deck.id}");
}

Future<void> cardContentUnknown(int cardId) async {
  var db = await DBConnector.getConnection();
  await db.update("card", {
    "repeat_next": getCurrentDate(),
    "repeat_last": 0
  }, where: "id = $cardId");
}

Future<void> cardContentKnown(Card card) async {
  var db = await DBConnector.getConnection();
  var nextRepeat = card.repeatLast != 0 ? card.repeatLast * 2 : 1;
  await db.update("card", {
    "repeat_next": getCurrentDate(daysToAdd: nextRepeat),
    "repeat_last": nextRepeat
  }, where: "id = ${card.id}");
}

Future<void> deleteCardById(int cardId) async {
  var db = await DBConnector.getConnection();
  await db.delete("card", where: "id = $cardId");
}

Future<void> deleteDeckById(int deckId) async {
  var db = await DBConnector.getConnection();
  await db.delete("deck", where: "id = $deckId");
}

Future<void> deleteCardsByDeckId(int deckId) async {
  var db = await DBConnector.getConnection();
  await db.delete("card", where: "deck_id = $deckId");
}