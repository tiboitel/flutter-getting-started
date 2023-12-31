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
  var current = 'Click on Generate !';
  var favorites = <String>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }

    notifyListeners();
  }

  void getEvilDemonLordName() {
    final name = WordPair.random().asLowerCase;
    final wordPair = generateWordPairs().take(1).single;
    final noun = wordPair.first; // Generate one random noun
    final adjective = wordPair.second; // Generate one random adjective

    current = '$name\r\nthe $adjective $noun';
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = FavoritesPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          body: Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}


class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var current = appState.current;

    IconData icon;
    if (appState.favorites.contains(current)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EvildDemonLordLabel(evilDemonLordName: current),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getEvilDemonLordName();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ...

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
        padding: const EdgeInsets.all(30.0),
        child: Text(evilDemonLordName, style: style, semanticsLabel: evilDemonLordName,),

      ),
    );
  }
}

class FavoritesPage extends StatelessWidget { 
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    if (appState.favorites.isEmpty) {
      return Center (
        child: Text('No favorites.'),     
      );
    }

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
          '${appState.favorites.length} favorites !'),
        ),
        for (var evilDemonLordName in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(evilDemonLordName),
          ),

      ],
    );
  }
}