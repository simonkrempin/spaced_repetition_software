import 'dart:typed_data';

class Card {
  int? id;
  String front;
  String? backText;
  Uint8List? backImage;
  int deckId;
  int repeatLast;
  DateTime repeatNext;

  Card({
    this.id,
    required this.front,
    this.backText,
    this.backImage,
    required this.deckId,
    required this.repeatLast,
    required this.repeatNext,
  });

  factory Card.fromMap(Map<String, Object?> map) {
    return Card(
      id: map["id"] as int,
      front: map["front"] as String,
      backText: map["back_text"] as String?,
      backImage: map["back_image"] as Uint8List?,
      deckId: map["deck_id"] as int,
      repeatLast: map["repeat_last"] as int,
      repeatNext: DateTime.parse(map["repeat_next"] as String),
    );
  }
}

class CardDTO {
  String? front;
  String? backText;
  Uint8List? backImage;
  int? deckId;
  int? lastRepeat;
  DateTime? nextRepeat;

  CardDTO({
    this.front,
    this.backText,
    this.backImage,
    this.deckId,
    this.lastRepeat,
    this.nextRepeat
  });
}