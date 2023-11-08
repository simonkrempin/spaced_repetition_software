import "package:flutter/material.dart";
import "package:spaced_repetition_software/views/cards-view.dart";
import "package:spaced_repetition_software/views/learning-view.dart";
import "package:spaced_repetition_software/views/online-view.dart";

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
          title: const Text("HOME"),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_outlined),
              onPressed: () {},
            ),
          ],
        ),
        body: <Widget>[
          const CardsView(),
          const LearningView(),
          const OnlineView()
        ][currentPageIndex],
        bottomNavigationBar: NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.folder),
              icon: Icon(Icons.folder_outlined),
              label: 'Items',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.play_arrow),
              icon: Icon(Icons.play_arrow_outlined),
              label: 'Lernen',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.school),
              icon: Icon(Icons.school_outlined),
              label: 'Shared',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Implement action for adding new items
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
