import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';

// declaring the theme constants
const MAIN_FONT_SIZE = 24;
var GLOBAL_THEME = "dark";
var scalingFactor = 1.0;

void main() {
  runApp(const DoItLaterApp());
}

class DoItLaterApp extends StatefulWidget {
  const DoItLaterApp({super.key});

  @override
  _DoItLaterAppState createState() => _DoItLaterAppState();
}

class _DoItLaterAppState extends State<DoItLaterApp> {
  List<ToDoListItem> allListItems = [
    ToDoListItem(
      title: '1',
      description: 'one',
      category: 'samples',
      priority: 'Low',
      deadlineDateTime: DateTime.now(),
    ),
    ToDoListItem(
      title: '2',
      description: 'two',
      category: 'samples',
      priority: 'Low',
      deadlineDateTime: DateTime.now(),
    ),
    ToDoListItem(
      title: '3',
      description: 'three',
      category: 'samples',
      priority: 'Low',
      deadlineDateTime: DateTime.now(),
    ),
  ];

  void addNewToDoListItem(ToDoListItem latestItem) {
    setState(() {
      allListItems.add(latestItem);
    });
  }

  void reorderItems() {
    setState(() {
      allListItems.sort((a, b) => a.done ? 1 : -1);
    });
  }

  void editItem(ToDoListItem item) {
    // Add your editing logic here
  }

  void deleteItem(ToDoListItem item) {
    setState(() {
      allListItems.remove(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Do It Later',
      theme: GLOBAL_THEME == "dark" ? ThemeData.dark() : ThemeData.light(),
      initialRoute: '/',
      routes: {
        '/': (context) => ToDoListItemListScreen(
              allListItems: allListItems,
              onAddItem: addNewToDoListItem,
              reorderItems: reorderItems,
              onEditItem: editItem,
              onDeleteItem: deleteItem,
            ),
        '/add': (context) => AddToDoItemScreen(onAddItem: addNewToDoListItem),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}

// ignore: must_be_immutable
class ToDoListItem extends StatefulWidget {
  bool done = false;
  final String title;
  final String description;
  final DateTime deadlineDateTime;
  final String category;
  final String priority;

  ToDoListItem({
    super.key,
    required this.title,
    required this.description,
    required this.deadlineDateTime,
    required this.category,
    required this.priority,
  });

  @override
  _ToDoListItemState createState() => _ToDoListItemState();
}

class _ToDoListItemState extends State<ToDoListItem> {
  bool done = false;

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Checkbox(
                  value: done,
                  onChanged: (bool? newValue) {
                    setState(() {
                      done = newValue ?? false;
                    });
                  },
                ),
                Text(
                  widget.title,
                  style: TextStyle(
                    color: Colors.lightBlue[400],
                    decoration:
                        done ? TextDecoration.lineThrough : TextDecoration.none,
                  ),
                ),
              ],
            ),
            Text(formatDateTime(widget.deadlineDateTime)),
            Text(widget.description),
            Text('Priority: ${widget.priority}'),
          ],
        ),
      ),
    );
  }
}

class ToDoListItemListScreen extends StatelessWidget {
  final List<ToDoListItem> allListItems;
  final Function(ToDoListItem) onAddItem;
  final Function reorderItems;
  final Function(ToDoListItem) onEditItem;
  final Function(ToDoListItem) onDeleteItem;

  const ToDoListItemListScreen({
    super.key,
    required this.allListItems,
    required this.onAddItem,
    required this.reorderItems,
    required this.onEditItem,
    required this.onDeleteItem,
  });

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Do It Later',
          style: TextStyle(fontSize: MAIN_FONT_SIZE * scalingFactor),
        ),
      ),
      body: ListView.builder(
        itemCount: allListItems.length,
        itemBuilder: (context, index) {
          final toDoListItemToDisplay = allListItems[index];
          return GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          toDoListItemToDisplay.title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text("Category: ${toDoListItemToDisplay.category}"),
                        Text("Priority: ${toDoListItemToDisplay.priority}"),
                        Text(
                          "Deadline: ${formatDateTime(toDoListItemToDisplay.deadlineDateTime)}",
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.edit),
                          title: const Text('Edit'),
                          onTap: () {
                            Navigator.pop(context);
                            onEditItem(toDoListItemToDisplay);
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.delete),
                          title: const Text('Delete'),
                          onTap: () {
                            Navigator.pop(context);
                            onDeleteItem(toDoListItemToDisplay);
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: toDoListItemToDisplay,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            right: 10,
            bottom: 10,
            child: FloatingActionButton(
              heroTag: "addNewItem",
              onPressed: () {
                Navigator.pushNamed(context, '/add');
              },
              child: const Icon(Icons.add, size: 40),
            ),
          ),
          Positioned(
            left: 10,
            top: 15,
            child: FloatingActionButton(
              heroTag: "settings",
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
              child: const Icon(Icons.settings, size: 30),
            ),
          ),
        ],
      ),
    );
  }
}

class AddToDoItemScreen extends StatefulWidget {
  final Function(ToDoListItem) onAddItem;

  const AddToDoItemScreen({super.key, required this.onAddItem});

  @override
  _AddToDoItemScreenState createState() => _AddToDoItemScreenState();
}

class _AddToDoItemScreenState extends State<AddToDoItemScreen> {
  String title = "";
  String category = "";
  String description = "";
  String priority = "Medium";
  DateTime deadlineDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                title = value;
              },
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'Description'),
              onChanged: (value) {
                description = value;
              },
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: const InputDecoration(labelText: 'Category'),
              onChanged: (value) {
                category = value;
              },
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Priority'),
              value: priority,
              items: ['High', 'Medium', 'Low'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  priority = newValue!;
                });
              },
            ),
            const SizedBox(height: 10),
            DateTimeFormField(
              decoration: const InputDecoration(labelText: 'Deadline Date'),
              onChanged: (DateTime? value) {
                if (value != null) {
                  deadlineDate = value;
                }
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (title.isNotEmpty) {
                  ToDoListItem newItem = ToDoListItem(
                    title: title,
                    description: description,
                    deadlineDateTime: deadlineDate,
                    category: category,
                    priority: priority,
                  );
                  widget.onAddItem(newItem);
                  Navigator.pop(context);
                } else {
                  // Show a message if the title is empty
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Title cannot be empty!')),
                  );
                }
              },
              child: const Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(fontSize: MAIN_FONT_SIZE * scalingFactor),
        ),
      ),
      body: const SettingsBody(),
    );
  }
}

class SettingsBody extends StatefulWidget {
  const SettingsBody({super.key});

  @override
  _SettingsBodyState createState() => _SettingsBodyState();
}

class _SettingsBodyState extends State<SettingsBody> {
  bool isDarkMode = true;
  double scalingFactor = 1.0;

  List<double> scalingFactors = [0.5, 0.75, 1.0, 1.25, 1.5];

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
      GLOBAL_THEME = isDarkMode ? "dark" : "light";
      if (context.mounted) {
        final widgetState =
            context.findAncestorStateOfType<_DoItLaterAppState>();
        widgetState?.setState(() {});
      }
    });
  }

  void changeScalingFactor(double newScale) {
    setState(() {
      scalingFactor = newScale;
      GLOBAL_THEME = isDarkMode ? "dark" : "light";
      if (context.mounted) {
        final widgetState =
            context.findAncestorStateOfType<_DoItLaterAppState>();
        widgetState?.setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Dark Mode",
              style: TextStyle(fontSize: MAIN_FONT_SIZE * scalingFactor),
            ),
            Switch(
              value: isDarkMode,
              onChanged: toggleTheme,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              "Scaling Factor",
              style: TextStyle(fontSize: MAIN_FONT_SIZE * scalingFactor),
            ),
            DropdownButtonFormField<double>(
              decoration: const InputDecoration(labelText: 'Scaling Factor'),
              value: scalingFactor,
              items: scalingFactors.map((double value) {
                return DropdownMenuItem<double>(
                  value: value,
                  child: Text(value.toStringAsFixed(2)),
                );
              }).toList(),
              onChanged: (newScale) {
                if (newScale != null) {
                  changeScalingFactor(newScale);
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}
