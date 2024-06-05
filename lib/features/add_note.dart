import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddNote extends StatefulWidget {
  final String? initialNote;
  final void Function(dynamic note) onSave; // Declare onSave callback

  const AddNote({Key? key, required this.onSave, this.initialNote}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late TextEditingController noteController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    noteController = TextEditingController(text:widget.initialNote ?? "");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: noteController.text.isEmpty?
          const Text("Create Note"):Text("Edit Your Note "),
        centerTitle: true,
      ),
      body: Center(
        child: Column(

          crossAxisAlignment:CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IntrinsicWidth(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1.0,
                      ),
                    ),
                  ),
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    controller: noteController,
                    keyboardType: TextInputType.text,
                    maxLength: 800,
                    decoration: const InputDecoration(
                        labelText: "Note",
                        hintText: "Text goes here",
                      border: InputBorder.none
                    ),
                  ),
                ),
              ),

            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                String note = noteController.text;
                if(note.isNotEmpty){
                  widget.onSave(note);
                 // _saveNoteToPrefs(note);
                  noteController.clear();
                  Navigator.of(context, rootNavigator: true).pop();
                }else{
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please Enter Valid Input.'),
                    ),
                  );
                }

              },
              child: Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

 // Future<void> _saveNoteToPrefs(String note) async {
   // SharedPreferences prefs = await SharedPreferences.getInstance();
    //List<String> notes = prefs.getStringList('notes') ?? [];
    //notes.add(note);
    //await prefs.setStringList('notes', notes);
  //}
}
