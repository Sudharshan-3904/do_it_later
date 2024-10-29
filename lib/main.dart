import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';

void main() {
  runApp(const DoItLaterApp());
}

class DoItLaterApp extends StatefulWidget {
  const DoItLaterApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DoItLaterAppState createState() => _DoItLaterAppState();
}

class _DoItLaterAppState extends State<DoItLaterApp> {
  List<ToDoListItem> allListItems = [];

  void addNewToDoListItem(ToDoListItem latestItem) {
    setState(() {
      allListItems.add(latestItem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Do It Later',
      theme: ThemeData(
        primarySwatch: Colors.lightBlue,
        scaffoldBackgroundColor: Colors.lightBlue[50],
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.lightBlue,
        ),
      ),
      home: ToDoListItemListScreen(
          allListItems: allListItems, onAddItem: addNewToDoListItem),
    );
  }
}

// ignore: must_be_immutable
class ToDoListItem extends StatefulWidget {
  bool? done;
  final String title;
  final String description;
  final DateTime eventDateTime;
  final DateTime reminderDateTime;
  final String category;
  bool? overdue;

  ToDoListItem({
    super.key,
    this.done,
    required this.title,
    required this.description,
    required this.eventDateTime,
    required this.reminderDateTime,
    required this.category,
    this.overdue,
  });

  @override
  // ignore: library_private_types_in_public_api
  _ToDoListItemState createState() => _ToDoListItemState();
}

class _ToDoListItemState extends State<ToDoListItem> {
  @override
  void initState() {
    super.initState();
    _checkIfOverdue();
  }

  void _checkIfOverdue() {
    if (DateTime.now().isAfter(widget.reminderDateTime)) {
      setState(() {
        widget.overdue = true;
      });
    }
  }

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ToDoListItemDetailsScreen(currentListItem: widget),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Checkbox(
                    value: widget.done,
                    onChanged: (bool? value) {
                      setState(() {
                        widget.done = value ?? false;
                      });
                    },
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      // color: widget.overdue ? Colors.red : Colors.lightBlue[400],
                      color: Colors.lightBlue[400],
                    ),
                  ),
                ],
              ),
              Text(formatDateTime(widget.eventDateTime)),
              Text(widget.description),
            ],
          ),
        ),
      ),
    );
  }
}

class ToDoListItemDetailsScreen extends StatelessWidget {
  final ToDoListItem currentListItem;

  const ToDoListItemDetailsScreen({super.key, required this.currentListItem});

  String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentListItem.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Date and Time: ${formatDateTime(currentListItem.eventDateTime)}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              "Reminder: ${formatDateTime(currentListItem.reminderDateTime)}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text("Category: ${currentListItem.category}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 10),
            Text(currentListItem.description,
                style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

class ToDoListItemListScreen extends StatelessWidget {
  final List<ToDoListItem> allListItems;
  final Function(ToDoListItem) onAddItem;

  const ToDoListItemListScreen({
    super.key,
    required this.allListItems,
    required this.onAddItem,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Do It Later'),
      ),
      body: ListView.builder(
        itemCount: allListItems.length,
        itemBuilder: (context, index) {
          final toDoLIstItemToDisplay = allListItems[index];
          return ListTile(
            title: Text(toDoLIstItemToDisplay.title),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddToDoItemScreen(
                      onAddItem: onAddItem,
                    )),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

// ignore: must_be_immutable
class AddToDoItemScreen extends StatelessWidget {
  final Function(ToDoListItem) onAddItem;
  AddToDoItemScreen({super.key, required this.onAddItem});

  var name = "";
  var cat = "";
  var desc = "";
  DateTime eventDate = DateTime(2024);
  DateTime reminderDate = DateTime(2024);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Item')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(
            decoration: const InputDecoration(labelText: 'Title'),
            onChanged: (value) {
              name = value;
            },
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: const InputDecoration(labelText: 'Description'),
            onChanged: (value) {
              desc = value;
            },
          ),
          const SizedBox(height: 10),
          TextField(
            decoration: const InputDecoration(labelText: 'Category'),
            onChanged: (value) {
              cat = value;
            },
          ),
          const SizedBox(height: 10),
          DateTimeFormField(
            decoration: const InputDecoration(labelText: 'Enter Event Date'),
            firstDate: DateTime.now().add(const Duration(days: 30)),
            lastDate: DateTime.now().add(const Duration(days: 90)),
            initialPickerDateTime: DateTime.now().add(const Duration(days: 35)),
            onChanged: (DateTime? value) {
              eventDate = value!;
            },
          ),
          const SizedBox(height: 10),
          DateTimeFormField(
            decoration: const InputDecoration(labelText: 'Enter Reminder Date'),
            firstDate: DateTime.now().add(const Duration(days: 30)),
            lastDate: DateTime.now().add(const Duration(days: 90)),
            initialPickerDateTime: DateTime.now().add(const Duration(days: 35)),
            onChanged: (DateTime? value) {
              eventDate = value!;
            },
          ),
          FloatingActionButton(
            onPressed: () {
              ToDoListItem newItem = ToDoListItem(
                  title: name,
                  description: desc,
                  eventDateTime: eventDate,
                  reminderDateTime: reminderDate,
                  category: cat);
              onAddItem(newItem);
              Navigator.pop(context);
            },
            child: const Icon(Icons.add),
          ),
        ]),
      ),
    );
  }
}
