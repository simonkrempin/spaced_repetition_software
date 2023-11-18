import "package:flutter/material.dart";
import "package:spaced_repetition_software/app_container.dart";
import 'package:spaced_repetition_software/context/explorer_context.dart';
import "package:spaced_repetition_software/database/db_connector.dart";
import "package:provider/provider.dart";
import "package:spaced_repetition_software/loading_screen.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
        child: FutureBuilder(
          future: DBConnector.connect(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const AppContainer();
            }
            return const LoadingScreen();
          },
        ),
      ),
    );
  }
}
