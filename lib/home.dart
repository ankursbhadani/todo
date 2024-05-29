import 'package:flutter/material.dart';
import 'add_note.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _notes = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNote();
  }
  _getNote() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> notes = prefs.getStringList('notes') ?? [];
    print("this is notes $notes");
    setState(() {
      _notes=notes;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
        centerTitle: true,
      ),
      body: Center(
        child: _notes.isEmpty
            ? Center(child: Text("No notes yet"))
            : ListView.builder(
          itemCount: _notes.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Text(_notes[index],style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return AddNote(
                onSave: (note) {
                  setState(() {
                    _notes.add(note);
                  });
                 // Navigator.pop(context); // Close the bottom sheet after saving
                },
              );
            },
          );
        },
        child: Icon(Icons.add),
        tooltip: "Add Note",
      ),
    );
  }
}
