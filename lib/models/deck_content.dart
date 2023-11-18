import 'package:spaced_repetition_software/models/card.dart';
import 'package:spaced_repetition_software/models/deck.dart';

class DeckContent {
  final List<Deck> decks;
  final List<Card> cards;

  DeckContent({required this.decks, required this.cards});
}