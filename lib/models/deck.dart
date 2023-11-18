class Deck {
  int id;
  int parentId;
  String name;

  Deck({required this.id, required this.parentId, required this.name});

  factory Deck.fromMap(Map<String, Object?> dbMap) {
    return Deck(
      id: dbMap['id'] as int,
      name: dbMap['name'] as String,
      parentId: dbMap['parent_id'] as int,
    );
  }
}

class DeckDTO {
  int? id;
  int? parentId;
  String? name;

  DeckDTO({this.id, this.parentId, this.name});
}
