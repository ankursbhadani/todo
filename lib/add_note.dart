import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNote extends StatefulWidget {
  final void Function(dynamic note) onSave; // Declare onSave callback

  const AddNote({Key? key, required this.onSave}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController noteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Note"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              maxLines: 3,
              controller: noteController,
              keyboardType: TextInputType.text,
              maxLength: 800,
              decoration: const InputDecoration(
                labelText: "Note", // Changed label to labelText
              ),
            ),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              // Call onSave callback with entered note
              String note = noteController.text;
              widget.onSave(note);
              // Save note to SharedPreferences
              _saveNoteToPrefs(note);
              // Clear text field after saving
              noteController.clear();
              // Close the bottom sheet
              Navigator.of(context, rootNavigator: true).pop();
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  Future<void> _saveNoteToPrefs(String note) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notes = prefs.getStringList('notes') ?? [];
    notes.add(note);
    await prefs.setStringList('notes', notes);
  }
}
