import 'db-connector.dart';

checkForTables() async {
  var db = await DBConnector.getConnection();
  var tables = await db.query("sqlite_master", where: "type = 'table'");
  // TODO: this is a not a good way to check if the tables exist, but it works for now
  if (tables.isEmpty) {
    await db.execute("""
      CREATE TABLE card (
        id INTEGER PRIMARY KEY,
        front TEXT,
        back TEXT,
        deck_id INTEGER,
        repeatNext DateTime,
        repeatLast INTEGER
      )""");
    await db.execute("CREATE TABLE deck (id INTEGER PRIMARY KEY, name TEXT, parent_id INTEGER)");
  }
}

getFolder(int parentId) async {
  var db = await DBConnector.getConnection();
  var folders = await db.query("deck", where: "parent_id = $parentId");
  return folders;
}

getCards(int deckId) async {
  var db = await DBConnector.getConnection();
  var cards = await db.query("card", where: "deck_id = $deckId");
  return cards;
}

getCardsToLearn() async {
  var db = await DBConnector.getConnection();
  var cards = await db.query("card", where: "repeatNext <= CURRENT_TIMESTAMP");
  return cards;
}

addCard(String front, String back, int deckId) async {
  var db = await DBConnector.getConnection();
  await db.insert("card", {
    "front": front,
    "back": back,
    "deck_id": deckId,
    "repeatNext": DateTime.now().toIso8601String(),
    "repeatLast": 0
  });
}

addFolder(String name, int parentId) async {
  var db = await DBConnector.getConnection();
  await db.insert("deck", {
    "name": name,
    "parent_id": parentId
  });
}