import 'package:firebaseflutterproject/MVVM/utils/utils.dart';
import 'package:firebaseflutterproject/NodejsNotes/NotesApp/api_services/api.dart';
import 'package:firebaseflutterproject/NodejsNotes/NotesApp/models/notes.dart';
import 'package:firebaseflutterproject/TopVariables.dart';
import 'package:flutter/cupertino.dart';
class NotesProvider extends ChangeNotifier{
List<Notes> notes=[];

NotesProvider(){
  fetchNotes();
}
void addNote(Notes note) {
  notes.add(note);
  notifyListeners();
  ApiServices.addNoteApi(note).then((value) {
     Utils.flushErrorMessage(value['status'], TopVaraible.navigatorKey.currentContext!);
  });

}
void updateNote(Notes note){
  int updateIndex=notes.indexOf(notes.firstWhere((element) => element.id == note.id));
  notes[updateIndex]=note;
  notifyListeners();
  ApiServices.addNoteApi(note).then((value) {
    Utils.flushErrorMessage(value['status'], TopVaraible.navigatorKey.currentContext!);
  });

}
void deleteNote(Notes note){
  int deletedIndex=notes.indexOf(notes.firstWhere((element) => element.id == note.id));
  notes.removeAt(deletedIndex);
  ApiServices.deleNoteApi(note).then((value) {
    Utils.flushErrorMessage(value['status'], TopVaraible.navigatorKey.currentContext!);
  });
  notifyListeners();
}
void fetchNotes() async{
  notes= await ApiServices.fetchNotes("aqsakhan");

  notifyListeners();
}





}