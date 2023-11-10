class Card {
  String front;
  String back;
  int deckId;
  int lastRepeat;
  DateTime nextRepeat;

  Card({
    required this.front,
    required this.back,
    required this.deckId,
    required this.lastRepeat,
    required this.nextRepeat,
  });

  factory Card.fromMap(Map<String, Object?> map) {
    return Card(
      front: map['front'] as String,
      back: map['back'] as String,
      deckId: map['deckId'] as int,
      lastRepeat: map['lastRepeat'] as int,
      nextRepeat: DateTime.parse(map['nextRepeat'] as String),
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