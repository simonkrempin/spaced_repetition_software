import "package:flutter/material.dart";

class AppContainer extends StatefulWidget {
  const AppContainer({super.key});

  @override
  State<StatefulWidget> createState() => _AppContainerState();
}

class _AppContainerState extends State<AppContainer> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("HOME"),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Implement search action
            },
          ),
        ],
      ),
      body: ListView(
        children: const [
          ListTile(
            leading: CircleAvatar(child: Text('A')),
            title: Text("Bürgerlichesgesetzbuch"),
            trailing: Icon(Icons.more_vert),
          ),
          ListTile(
            leading: CircleAvatar(child: Text('A')),
            title: Text("Handelsgesetzbuch"),
            trailing: Icon(Icons.more_vert),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.folder),
            label: "Items",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_arrow),
            label: "Lernen",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: "Shared",
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implement action for adding new items
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}