import "package:flutter/material.dart";
import "package:spaced_repetition_software/components/expandable-fab.dart";
import "package:spaced_repetition_software/components/small-fab.dart";
import 'package:spaced_repetition_software/features/explorer/explorer-view.dart';
import "package:spaced_repetition_software/features/learning-view.dart";
import "package:spaced_repetition_software/features/online-view.dart";

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
          title: const Text("HOME"),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_outlined),
              onPressed: () {},
            ),
          ],
        ),
        body: <Widget>[const ExplorerView(), const LearningView(), const OnlineView()][currentPageIndex],
        bottomNavigationBar: NavigationBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          indicatorColor: Theme.of(context).colorScheme.primaryContainer,
          onDestinationSelected: (int index) {
            setState(() {
              currentPageIndex = index;
            });
          },
          selectedIndex: currentPageIndex,
          destinations: const <Widget>[
            NavigationDestination(
              selectedIcon: Icon(Icons.folder, color: Colors.white),
              icon: Icon(Icons.folder_outlined),
              label: 'Items',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.play_arrow, color: Colors.white),
              icon: Icon(Icons.play_arrow_outlined),
              label: 'Lernen',
            ),
            NavigationDestination(
              selectedIcon: Icon(Icons.school, color: Colors.white),
              icon: Icon(Icons.school_outlined),
              label: 'Shared',
            ),
          ],
        ),
        floatingActionButton: ExpandableFab(
          children: [
            SmallFab(icon: Icons.folder_outlined, onPressed: showFolderDialog),
            SmallFab(icon: Icons.file_open_outlined, onPressed: showCardDialog),
          ],
        ),
      ),
    );
  }

  showFolderDialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text("create new folder"),
        content: TextField(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Folder Name',
          ),
        ),
      ),
    );
  }

  showCardDialog() {
    showDialog(
      context: context,
      builder: (context) => const AlertDialog(
        title: Text("create new card"),
        content: SizedBox.expand(
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a search term',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter a search term',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
