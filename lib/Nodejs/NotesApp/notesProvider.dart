import 'package:firebaseflutterproject/Nodejs/NotesApp/models/notes.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
class NotesProvider extends ChangeNotifier{
List<Notes> notes=[];
void addNote(Notes note){
  print("add note is ${note.title}");
  notes.add(note);
  notifyListeners();
}
void updateNote(){

}
void deleteNote(){}



}