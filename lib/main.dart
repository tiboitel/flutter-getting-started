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
  var current = 'Click the button to generate an Evil Lord Name !';

  void generateEvilDemonLordName() {
    final name = WordPair.random().asLowerCase;
    final wordPair = generateWordPairs().take(1).single;
    final noun = wordPair.first; // Generate one random noun
    final adjective = wordPair.second; // Generate one random adjective

    current = '$name\r\nthe $adjective $noun';
    notifyListeners();
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var evilDemonLordName = appState.current;
    final theme = Theme.of(context);

  return Scaffold(
    body: 
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('Generate a random Evil Demon Lord Name !', style: theme.textTheme.headlineLarge!.copyWith(color: theme.colorScheme.primary)),
            ),
            // SizedBox(height: 20),
            EvildDemonLordLabel(evilDemonLordName: evilDemonLordName),
            SizedBox(height: 20),
            // Add a button
            ElevatedButton(
              onPressed: () {
                appState.generateEvilDemonLordName();
              },
              child: Text('Generate !'),
            ),
          ],
        ),
      ),
    );
  }
}

class EvildDemonLordLabel extends StatelessWidget {
  const EvildDemonLordLabel({
    super.key,
    required this.evilDemonLordName,
  });

  final String evilDemonLordName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displaySmall!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.secondary,    // ← And also this.
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(evilDemonLordName, style: style, semanticsLabel: "${evilDemonLordName}",),

      ),
    );
  }
}
