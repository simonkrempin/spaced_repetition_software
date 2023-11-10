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
import 'package:spaced_repetition_software/features/explorer/components/explorer_card_item.dart';
import 'package:spaced_repetition_software/features/explorer/components/explorer_card.dart';

import '../../model/deck.dart';
import "../../services/file_explorer.dart";
import '../../model/card.dart';

class ExplorerView extends StatefulWidget {
  const ExplorerView({super.key});

  @override
  State<StatefulWidget> createState() => _ExplorerViewState();
}

class _ExplorerViewState extends State<ExplorerView> {
  late Future<List<Deck>> decksFuture;
  late Future<List<Card>> cardsFuture;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() {
    decksFuture = getDeck(0);
    cardsFuture = getCards(0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: FutureBuilder(
          future: Future.wait([decksFuture, cardsFuture]),
          builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
            if (snapshot.hasData) {
              List<Deck> decksResult = snapshot.data![0] as List<Deck>;
              List<Card> cardsResult = snapshot.data![1] as List<Card>;

              if (decksResult.isEmpty && cardsResult.isEmpty) {
                return const Center(
                  child: Text("Deck is empty"),
                );
              }

              return Column(
                children: [
                  ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 8);
                    },
                    itemBuilder: (BuildContext context, int index) => ExplorerDeckItem(deck: decksResult[index]),
                    itemCount: decksResult.length,
                  ),
                  const SizedBox(height: 8),
                  ListView.separated(
                    itemBuilder: (BuildContext context, int index) {
                      return const SizedBox(height: 8);
                    },
                    separatorBuilder: (BuildContext context, int index) => ExplorerCardItem(card: cardsResult[index]),
                    itemCount: cardsResult.length,
                  ),
                ],
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
          }),
    );
  }
}
