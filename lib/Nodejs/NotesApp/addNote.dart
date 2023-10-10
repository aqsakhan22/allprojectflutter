import 'package:firebaseflutterproject/Nodejs/NotesApp/models/notes.dart';
import 'package:firebaseflutterproject/Nodejs/NotesApp/notesProvider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
class AddNote extends StatefulWidget {
  const AddNote({Key? key}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController title=TextEditingController(text: '');
  TextEditingController content=TextEditingController(text: '');


  void addNewNote(){
    Notes newNote =Notes(
       id: Uuid().v1(),
       userid: "aqsakhan",
      title: title.text,
      content: content.text,
      dataAdded: DateTime.now()
    );
    Provider.of<NotesProvider>(context,listen: false).addNote(newNote);
    Provider.of<NotesProvider>(context,listen: false).notifyListeners();

    Navigator.pop(context);

  }
  @override
  Widget build(BuildContext context) {
    FocusNode noteFocus=FocusNode();
    NotesProvider notesProvider=Provider.of<NotesProvider>(context,listen: false);
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: (){
          addNewNote();
        }, icon: Icon(Icons.save))],

        title: Text("Add Note"),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            TextFormField(
              controller: title,
              onFieldSubmitted: (val){
                if(val != ""){
                  noteFocus.requestFocus();
                }
              },
              autofocus: true,
              decoration: InputDecoration(
                filled: true,
                hintText: "Enter Title",
                  border: InputBorder.none
              ),

            ),
            SizedBox(height: 10.0,),
            TextFormField(
              controller: content,
              focusNode: noteFocus,
              maxLines: null,
              decoration: InputDecoration(
                filled: true,
                hintText: "Enter Note",
                border: InputBorder.none
              ),

            ),
          ],
        ),
      ),
    );
  }
}
