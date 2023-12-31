import 'dart:typed_data';

import 'package:flutter/material.dart'
    show AsyncSnapshot, BorderRadius, BoxDecoration, BuildContext, Center, CircularProgressIndicator, Container, EdgeInsets, FutureBuilder, Image, Padding, SizedBox, Stack, State, StatefulWidget, Text, Theme, Widget;
import 'package:spaced_repetition_software/models/card.dart';
import 'package:spaced_repetition_software/database/card_repository.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'package:flip_card/flip_card.dart';
import "dart:async";

class LearningView extends StatefulWidget {
  const LearningView({super.key});

  @override
  State<StatefulWidget> createState() => _LearningViewState();
}

class _LearningViewState extends State<LearningView> {
  late final Future<List<SwipeItem>> swipeItems = getSwipeItems();
  late MatchEngine matchEngine;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Center(
          child: Text("finished for today"),
        ),
        FutureBuilder(
          future: swipeItems,
          builder: (BuildContext context, AsyncSnapshot<List<SwipeItem>> snapshot) {
            if (snapshot.hasData) {
              matchEngine = MatchEngine(swipeItems: snapshot.data!);
              return SizedBox(
                height: double.infinity,
                child: SwipeCards(
                  matchEngine: matchEngine,
                  itemBuilder: (BuildContext context, int index) {
                    var card = snapshot.data![index].content as Card;
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: FlipCard(
                        fill: Fill.fillBack,
                        front: _buildContainer(text: card.front),
                        back: _buildContainer(text: card.backText, image: card.backImage),
                      ),
                    );
                  },
                  onStackFinished: () {},
                ),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ],
    );
  }

  Container _buildContainer({String? text, Uint8List? image}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: image != null ? Image.memory(image) : Center(child: Text(text ?? "")),
    );
  }

  Future<List<SwipeItem>> getSwipeItems() async {
    List<SwipeItem> swipeItems = [];

    try {
      var result = await getCardsToLearn();
      for (var card in result) {
        swipeItems.add(SwipeItem(
            content: card,
            likeAction: () {
              cardContentKnown(card);
            },
            nopeAction: () {
              cardContentUnknown(card.id!);
            }));
      }
    } catch (e) {
      return [];
    }

    return swipeItems;
  }
}
