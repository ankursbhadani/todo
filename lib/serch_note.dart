import 'package:flutter/material.dart';
import 'package:todo/home.dart';

import 'data.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';
  List<String> _notes = [];
  TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getNotesFromFirestore();
  }
  _getNotesFromFirestore() {
    GetData getData = GetData();
    getData.getNotesFromFirestore().listen((List<String> notes) {
      setState(() {
        _notes = notes;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: (){
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()));
          },
            child: Icon(Icons.arrow_back)),
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              setState(() {
                _searchQuery = '';
                _searchController.clear();
              });
            },
          ),
        ],
      ),
      body: _buildSearchResults(),
    );
  }

  Widget _buildSearchResults() {
    // Filter notes based on search query
    final filteredNotes = _notes.where((note) {
      if (_searchQuery.isEmpty) {
        return true; // If search query is empty, show all notes
      } else {
        return note.toLowerCase().startsWith(_searchQuery.toLowerCase()); // Check if note starts with the search query
      }
    }).toList();

    return ListView.builder(
      itemCount: filteredNotes.length,
      itemBuilder: (BuildContext context, int index) {
        final note = filteredNotes[index];
        return ListTile(
          title: Text(
            note,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
