
import 'package:firebaseflutterproject/NodejsNotes/NotesApp/api_services/api.dart';
import 'package:firebaseflutterproject/NodejsNotes/NotesApp/models/notes.dart';
import 'package:firebaseflutterproject/NodejsNotes/NotesApp/notesProvider.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart';
class AddNote extends StatefulWidget {
  final bool isUpdate;
  final Notes? note;
  const AddNote({Key? key, required this.isUpdate,  this.note}) : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  TextEditingController title=TextEditingController(text: '');
  TextEditingController content=TextEditingController(text: '');

@override
  void initState() {
    // TODO: implement initState
    super.initState();
   if(widget.isUpdate){
     title.text=widget.note!.title!;
     content.text=widget.note!.content!;

   }
  }
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
  }
  @override
  Widget build(BuildContext context) {
    FocusNode noteFocus=FocusNode();
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: (){

       if(widget.isUpdate){
         print("update is");
         widget.note!.title=title.text;
         widget.note!.content=content.text;
         widget.note!.dataAdded=DateTime.now();
         Provider.of<NotesProvider>(context,listen: false).updateNote(widget.note!);
         Navigator.pop(context);
       }
       else{
         addNewNote();
         Navigator.pop(context);
       }

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
              autofocus: widget.isUpdate ? false : true  ,
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
