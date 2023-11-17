import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'
    show
        AsyncSnapshot,
        BuildContext,
        Center,
        CircularProgressIndicator,
        EdgeInsets,
        FutureBuilder,
        ListView,
        Padding,
        SizedBox,
        State,
        StatefulWidget,
        Text,
        Widget,
        Column;
import "package:provider/provider.dart";
import 'package:spaced_repetition_software/context/explorer_context.dart';
import 'package:spaced_repetition_software/features/explorer/components/explorer_card_item.dart';
import 'package:spaced_repetition_software/features/explorer/components/explorer_deck_item.dart';
import 'package:spaced_repetition_software/model/deck_content.dart';
import 'package:spaced_repetition_software/model/deck.dart';
import 'package:spaced_repetition_software/model/card.dart';

class ExplorerView extends StatefulWidget {
  const ExplorerView({super.key});

  @override
  State<StatefulWidget> createState() => _ExplorerViewState();
}

class _ExplorerViewState extends State<ExplorerView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FutureBuilder(
        future: context.watch<ExplorerContext>().getDeckContent(),
        builder: (context, AsyncSnapshot<DeckContent> snapshot) {
          if (snapshot.hasData) {
            final List<Deck> decks = snapshot.data!.decks;
            final List<Card> cards = snapshot.data!.cards;

            if (decks.isEmpty && cards.isEmpty) {
              return const Center(
                child: Text("Deck is empty"),
              );
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (BuildContext context, int index) => ExplorerDeckItem(deck: decks[index]),
                    itemCount: decks.length,
                  ),
                  if (decks.isNotEmpty && cards.isNotEmpty) const SizedBox(height: 8),
                  ListView.separated(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => const SizedBox(height: 8),
                    itemBuilder: (BuildContext context, int index) => ExplorerCardItem(card: cards[index]),
                    itemCount: cards.length,
                  ),
                  const SizedBox(height: 108),
                ],
              ),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
