import "package:flutter/material.dart";
import "package:spaced_repetition_software/components/expandable_fab.dart";
import "package:spaced_repetition_software/components/small_fab.dart";
import "package:spaced_repetition_software/dialog/card_dialog.dart";
import "package:spaced_repetition_software/dialog/deck_dialog.dart";
import 'package:spaced_repetition_software/features/explorer/explorer_view.dart';
import "package:spaced_repetition_software/features/learning_view.dart";
import "package:spaced_repetition_software/features/online_view.dart";
import 'package:spaced_repetition_software/context/explorer_context.dart';
import "package:provider/provider.dart";
import "package:spaced_repetition_software/models/deck.dart";
import "package:spaced_repetition_software/models/card.dart" as models;
import "package:spaced_repetition_software/services/deck_service.dart";
import "package:spaced_repetition_software/services/card_service.dart";

class AppContainer extends StatefulWidget {
  const AppContainer({super.key});

  @override
  State<StatefulWidget> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: DragTarget(
            builder: (context, candidateData, rejectedItems) => Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(context.read<ExplorerContext>().deckName, style: const TextStyle(color: Colors.white)),
            ),
            onAccept: (droppedItem) {
              var parentDeck = context.read<ExplorerContext>().parentDeck;
              if (droppedItem is Deck) {
                moveDeck(context, parentDeck, droppedItem);
              } else if (droppedItem is models.Card) {
                moveCard(context, parentDeck, droppedItem);
              } else {
                throw Exception("Unknown dropped item type");
              }
            },
          ),
          leading: context.watch<ExplorerContext>().deckId != 0
              ? IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new),
                  onPressed: () => context.read<ExplorerContext>().goBackInDeck(),
                )
              : null,
          actions: [
            CircleAvatar(
              child: IconButton(
                icon: const Icon(Icons.person_outlined, color: Colors.white),
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 16)
          ],
        ),
        body: <Widget>[
          const ExplorerView(),
          const LearningView(),
          const OnlineView(),
        ][currentPageIndex],
        bottomNavigationBar: NavigationBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          indicatorColor: Theme.of(context).colorScheme.primaryContainer,
          onDestinationSelected: (int index) {
            if (currentPageIndex == index) {
              destinationAction(context);
            } else {
              setState(() {
                currentPageIndex = index;
              });
            }
          },
          selectedIndex: currentPageIndex,
          destinations: <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.folder, color: Theme.of(context).colorScheme.primary),
              icon: const Icon(Icons.folder_outlined),
              label: 'Items',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.play_arrow, color: Theme.of(context).colorScheme.primary),
              icon: const Icon(Icons.play_arrow_outlined),
              label: 'Lernen',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.school, color: Theme.of(context).colorScheme.primary),
              icon: const Icon(Icons.school_outlined),
              label: 'Shared',
            ),
          ],
        ),
        floatingActionButton: AnimatedOpacity(
          opacity: currentPageIndex != 1 ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 100),
          child: ExpandableFab(
            children: [
              SmallFab(icon: Icons.folder_outlined, onPressed: showFolderDialog),
              SmallFab(icon: Icons.file_open_outlined, onPressed: showCardDialog),
            ],
          ),
        ),
      ),
    );
  }

  showFolderDialog() {
    showDialog(
      context: context,
      builder: (alertDialogContext) => DeckDialog(providerContext: context),
    );
  }

  showCardDialog() {
    showDialog(
      context: context,
      builder: (alertDialogContext) => CardDialog(providerContext: context),
    );
  }

  void destinationAction(BuildContext context) {
    switch (currentPageIndex) {
      case 0:
        context.read<ExplorerContext>().returnHome();
        break;
      case 1:
        break;
      case 2:
        break;
    }
  }
}
