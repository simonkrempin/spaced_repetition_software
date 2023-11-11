class Card {
  int? id;
  String front;
  String back;
  int deckId;
  int repeatLast;
  DateTime repeatNext;

  Card({
    this.id,
    required this.front,
    required this.back,
    required this.deckId,
    required this.repeatLast,
    required this.repeatNext,
  });

  factory Card.fromMap(Map<String, Object?> map) {
    return Card(
      id: map['id'] as int,
      front: map['front'] as String,
      back: map['back'] as String,
      deckId: map['deck_id'] as int,
      repeatLast: map['repeat_last'] as int,
      repeatNext: DateTime.parse(map['repeat_next'] as String),
    );
  }
}

class CardDTO {
  String? front;
  String? back;
  int? deckId;
  int? lastRepeat;
  DateTime? nextRepeat;

  CardDTO({
    this.front,
    this.back,
    this.deckId,
    this.lastRepeat,
    this.nextRepeat
  });
}