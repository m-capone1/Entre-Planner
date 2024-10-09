import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, child) {
          return MaterialApp(
            title: 'Entre Planner',
            theme:
                themeNotifier.isDarkMode ? ThemeData.dark() : ThemeData.light(),
            home: const MyHomePage(),
          );
        },
      ),
    );
  }
}

class ThemeNotifier extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
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
        page = const HomePage();
        break;
      case 1:
        page = const ToDoPage();
        break;
      case 2:
        page = const FinancialPage();
        break;
      case 3:
        page = const AIPage();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: const [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.add_task),
                    label: Text('To Do'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.attach_money),
                    label: Text('Finanical'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.auto_awesome),
                    label: Text('AI Assist'),
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
    });
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Entre-Planner',
              style: GoogleFonts.montserrat(
                textStyle: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Welcome Back!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Container(
              padding: const EdgeInsets.all(6.0),
              child: ElevatedButton(
                onPressed: () {
                  themeNotifier.toggleTheme();
                },
                child: themeNotifier.isDarkMode
                    ? const Icon(Icons.dark_mode)
                    : const Icon(Icons.sunny),
              ),
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }
}

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final List<Map<String, dynamic>> _toDoItems = [];
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Enter a To-Do Item',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _addToDoItem,
          child: const Text('Add'),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _toDoItems.length,
            itemBuilder: (context, index) {
              final item = _toDoItems[index];
              return ListTile(
                title: Text('${index + 1}: ${item['text']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.warning_rounded),
                      color: item['urgent'] ? Colors.red : null,
                      onPressed: () {
                        setState(() {
                          _toDoItems.removeAt(index);
                          _toDoItems.insert(
                              0, {'text': item['text'], 'urgent': true});
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _toDoItems.removeAt(index);
                        });
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _addToDoItem() {
    if (_controller.text.isNotEmpty) {
      setState(() {
        _toDoItems.add({'text': _controller.text, 'urgent': false});
        _controller.clear();
      });
    }
  }
}

class FinancialPage extends StatelessWidget {
  const FinancialPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [],
    );
  }
}

class AIPage extends StatelessWidget {
  const AIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: const [],
    );
  }
}
