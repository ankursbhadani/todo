import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'add_note.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> _notes = [];
  List<String> _important=[];
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _getNotesFromFirestore();
  }

  _getNotesFromFirestore() {
    FirebaseFirestore.instance.collection('notes').snapshots().listen((snapshot) {
      List<String> notes = snapshot.docs
          .map((doc) => (doc.data() as Map<String, dynamic>?)?['note'] as String?)
          .where((note) => note != null)
          .map((note) => note!)
          .toList();
      setState(() {
        _notes = notes;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("To-Do List"),
        centerTitle: true,
      ),
      body: _selectedIndex == 0
          ? _buildNotesList()
          : _selectedIndex == 1
          ? _buildCreateTasks() // Placeholder for saved tasks
          : _buildImportantTasks(), // Placeholder for important tasks
      bottomNavigationBar: BottomNavigationBar(
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Notes',
          ),
          BottomNavigationBarItem(
            icon: InkWell(
              onTap: (){
                showModalBottomSheet(
                  isDismissible: true,
                  isScrollControlled: true,
                  useSafeArea: true,
                  context: context,
                  builder: (context) {
                    return AddNote(
                      onSave: (note) {
                          _saveNoteToFirestore(note);
                       // Navigator.pop(context); // Close the bottom sheet after saving
                      },
                    );
                  },
                );
              },
                child: Icon(Icons.add_circle,size: 50,),),
            label: 'New Task',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Important',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildNotesList() {
    return ListView.builder(
      itemCount: _notes.length,
      itemBuilder: (BuildContext context, int index) {
        final note = _notes[index];
        return Dismissible(
          key: Key(note), // Key for identifying the item for dismissal
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            child: const Icon(Icons.delete),
          ),
          secondaryBackground: Container(
            color: Colors.yellow,
            alignment: Alignment.centerRight,
            child: const Icon(Icons.star),
          ),
          onDismissed: (direction) {
            setState(() {
              if(direction == DismissDirection.startToEnd){
                _deleteNoteFromFirestore(note); // Delete note from Firestore
                _notes.removeAt(index);
               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Note Deleted")));
              }else if(direction == DismissDirection.endToStart){
                _important.add(note); // Add the note to the important list
                _notes.removeAt(index);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Note marked as favorite'),
                  ),
                );
              }
            });

          },
          child: Card(
            child: ListTile(
              title: Text(
                note,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCreateTasks() {
    // Placeholder widget for saved tasks
    return const Center(
      child: Text('Create Tasks'),
    );
  }

  Widget _buildImportantTasks() {
    return ListView.builder(
      itemCount: _important.length,
      itemBuilder: (BuildContext context, int index) {
        final note = _important[index];
        return Card(
          child: ListTile(
            title: Text(
              note,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        );
      },
    );
  }

  void _saveNoteToFirestore(String note) {
    // Save note to Firestore
    FirebaseFirestore.instance.collection('notes').add({
      'note': note,
    });
  }
  void _deleteNoteFromFirestore(String note) {
    // Find the document ID of the note to delete
    FirebaseFirestore.instance
        .collection('notes')
        .where('note', isEqualTo: note)
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        // Delete the document from Firestore
        doc.reference.delete();
      });
    }).catchError((error) {
      print("Error deleting note: $error");
    });
  }
}
