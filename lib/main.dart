import 'package:english_words/english_words.dart'; // Package for generating English words.
import 'package:flutter/material.dart'; // Flutter material package for building UI.
import 'package:provider/provider.dart'; // Provider package for state management.


// Main entry point of the application.
void main() {
  runApp(MyApp()); // Create an instance of MyApp and passing it to runApp function.
}

// MyApp class inherits from Stateless Widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wrap the entire app with ChangeNotifierProvider for state management
    return ChangeNotifierProvider(
      create: (context) => MyAppState(), // Create an instance of MyAppState as the initial state 
      child: MaterialApp(
        title: 'Marathon',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
        ),
        home: MyHomePage(),
      ),
    );
  }
}



class MyAppState extends ChangeNotifier {
  var current = "Click the button to generate an Evil Lord Name !";

  void generateEvilLordName() {
    final name = WordPair.random().asLowerCase;
    final wordPair = generateWordPairs().take(1).single;
    final noun = wordPair.first; // Generate one random noun
    final adjective = wordPair.second; // Generate one random adjective

    current = '$name The $adjective $noun';
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 40.0), // Adjust the value as needed,
        child: Column(
          children: [
            Text('A random Evil Demon Lord Name:'),
            Text(appState.current)    ,

            // Add a button
            ElevatedButton(
              onPressed: () {
                appState.generateEvilLordName();
              },
              child: Text('Generate !'),
            ),
          ],
        ),
      ),
    );
  }
}
