import 'dart:typed_data';

import 'package:spaced_repetition_software/utils/date.dart';
import 'package:spaced_repetition_software/models/card.dart';
import 'package:spaced_repetition_software/database/db_connector.dart';
import 'package:sqflite/sqflite.dart';

Future<void> ensureDbStructure(Database db) async {
  db.execute("""
      CREATE TABLE card (
        id INTEGER PRIMARY KEY,
        front TEXT,
        back_text TEXT,
        back_image BLOB,
        deck_id INTEGER,
        repeat_next TEXT,
        repeat_last INTEGER
      )""");
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

addCard(String front, String? backText, Uint8List? image, int deckId) async {
  var db = await DBConnector.getConnection();
  await db.insert("card", {
    "front": front,
    "back_text": backText,
    "back_image": image,
    "deck_id": deckId,
    "repeat_next": getCurrentDate(),
    "repeat_last": 0
  });
}

updateCard(Card card) async {
  var db = await DBConnector.getConnection();
  await db.update(
      "card", {"front": card.front, "back_text": card.backText, "back_image": card.backImage, "deck_id": card.deckId},
      where: "id = ${card.id}");
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

// when a card is known in next mode, the repeat_next values does not increase, since the time of the repetition was to
// short to increase the repeat_last value.
Future<void> cardContentKnownOnNextMode(Card card) async {
  var db = await DBConnector.getConnection();
  await db.update("card", {"repeat_next": getCurrentDate(daysToAdd: card.repeatLast)}, where: "id = ${card.id}");
}

Future<void> deleteCardById(int cardId) async {
  var db = await DBConnector.getConnection();
  await db.delete("card", where: "id = $cardId");
}

Future<void> deleteCardsByDeckId(int deckId) async {
  var db = await DBConnector.getConnection();
  await db.delete("card", where: "deck_id = $deckId");
}

Future<List<Card>> getNextCards() async {
  var db = await DBConnector.getConnection();
  var query = """
    SELECT * FROM card
    WHERE repeat_next = (SELECT min(repeat_next) FROM card)
    ORDER BY repeat_last ASC
  """;
  var cards = await db.rawQuery(query);
  return cards.map((f) => Card.fromMap(f)).toList();
}
