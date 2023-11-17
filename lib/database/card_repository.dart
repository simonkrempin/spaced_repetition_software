import 'package:spaced_repetition_software/utils/date.dart';
import 'package:spaced_repetition_software/model/card.dart';
import 'package:spaced_repetition_software/database/db_connector.dart';

Future<void> ensureDbStructure() async {
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
  await db.insert(
      "card", {"front": front, "back": back, "deck_id": deckId, "repeat_next": getCurrentDate(), "repeat_last": 0});
}

updateCard(Card card) async {
  var db = await DBConnector.getConnection();
  await db.update("card", {"front": card.front, "back": card.back, "deck_id": card.deckId}, where: "id = ${card.id}");
}

Future<void> cardContentUnknown(int cardId) async {
  var db = await DBConnector.getConnection();
  await db.update("card", {"repeat_next": getCurrentDate(), "repeat_last": 0}, where: "id = $cardId");
}

Future<void> cardContentKnown(Card card) async {
  var db = await DBConnector.getConnection();
  var nextRepeat = card.repeatLast != 0 ? card.repeatLast * 2 : 1;
  await db.update("card", {"repeat_next": getCurrentDate(daysToAdd: nextRepeat), "repeat_last": nextRepeat},
      where: "id = ${card.id}");
}

Future<void> deleteCardById(int cardId) async {
  var db = await DBConnector.getConnection();
  await db.delete("card", where: "id = $cardId");
}

Future<void> deleteCardsByDeckId(int deckId) async {
  var db = await DBConnector.getConnection();
  await db.delete("card", where: "deck_id = $deckId");
}
