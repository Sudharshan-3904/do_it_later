// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:date_field/date_field.dart';

void main() {
  runApp(const DoItLaterApp());
}

class DoItLaterApp extends StatefulWidget {
  const DoItLaterApp({super.key});

  @override
  _DoItLaterAppState createState() => _DoItLaterAppState();
}

class _DoItLaterAppState extends State<DoItLaterApp> {
  List<ToDoListItem> allListItems = [];

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
        allListItems: allListItems,
        onAddItem: addNewToDoListItem,
        reorderItems: reorderItems,
      ),
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
            builder: (context) => ToDoListItemDetailsScreen(
              currentListItem: widget,
            ),
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
                      // Call reorderItems on the parent widget
                      (context.findAncestorStateOfType<_DoItLaterAppState>()
                              as _DoItLaterAppState)
                          .reorderItems();
                    },
                  ),
                  Text(
                    widget.title,
                    style: TextStyle(
                      color: Colors.lightBlue[400],
                      decoration: widget.done == true
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
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
              "Deadline: ${formatDateTime(currentListItem.deadlineDateTime)}",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text("Category: ${currentListItem.category}",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 5),
            Text("Priority: ${currentListItem.priority}",
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
  final Function reorderItems;

  const ToDoListItemListScreen({
    super.key,
    required this.allListItems,
    required this.onAddItem,
    required this.reorderItems,
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
          final toDoListItemToDisplay = allListItems[index];
          return toDoListItemToDisplay;
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddToDoItemScreen(onAddItem: onAddItem),
            ),
          );
        },
        child: const Icon(Icons.add),
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
  String name = "";
  String cat = "";
  String desc = "";
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
                  deadlineDate = value!;
                }),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                ToDoListItem newItem = ToDoListItem(
                  title: name,
                  description: desc,
                  deadlineDateTime: deadlineDate,
                  category: cat,
                  priority: priority,
                );
                widget.onAddItem(newItem);
                Navigator.pop(context);
              },
              child: const Text('Add Item'),
            ),
          ],
        ),
      ),
    );
  }
}
