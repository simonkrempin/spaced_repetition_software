import "package:flutter/material.dart";
import "package:spaced_repetition_software/app_container.dart";
import 'package:spaced_repetition_software/context/explorer_context.dart';
import "package:spaced_repetition_software/database/db_connector.dart";
import "package:spaced_repetition_software/database/deck_card_repository.dart";
import "package:provider/provider.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DBConnector.connect();
  checkForTables();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "LearnLoop",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFd0bcff),
          primaryContainer: Color(0xFF4a4458),
          background: Color(0xFF141218),
          surface: Color(0xFF211f26),
        ),
        useMaterial3: true,
      ),
      home: ChangeNotifierProvider(
        create: (_) => ExplorerContext(),
        child: const AppContainer(),
      )
    );
  }
}
