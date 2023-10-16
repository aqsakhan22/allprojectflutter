import 'package:firebaseflutterproject/MVVM/utils/utils.dart';
import 'package:firebaseflutterproject/NodejsNotes/NotesApp/api_services/api.dart';
import 'package:firebaseflutterproject/NodejsNotes/NotesApp/models/notes.dart';
import 'package:firebaseflutterproject/TopVariables.dart';
import 'package:flutter/cupertino.dart';
class NotesProvider extends ChangeNotifier{
  bool isLoading=true;
List<Notes> notes=[];

NotesProvider(){
  fetchNotes();
}
void addNote(Notes note) {
  notes.add(note);
  sortNotes();
  notifyListeners();
  ApiServices.addNoteApi(note).then((value) {
     Utils.flushErrorMessage(value['status'], TopVaraible.navigatorKey.currentContext!);
  });

}
void updateNote(Notes note){
  int updateIndex=notes.indexOf(notes.firstWhere((element) => element.id == note.id));
  notes[updateIndex]=note;
  sortNotes();
  notifyListeners();
  ApiServices.updateNoteApi(note).then((value) {
    Utils.flushErrorMessage(value['status'], TopVaraible.navigatorKey.currentContext!);
  });

}
void deleteNote(Notes note){
  int deletedIndex=notes.indexOf(notes.firstWhere((element) => element.id == note.id));
  notes.removeAt(deletedIndex);
  ApiServices.deleNoteApi(note).then((value) {
    Utils.flushErrorMessage(value['status'], TopVaraible.navigatorKey.currentContext!);
  });
  sortNotes();
  notifyListeners();
}
void sortNotes(){
  notes.sort((a,b) => b.dataAdded!.compareTo(a.dataAdded!));
  notifyListeners();
}

void fetchNotes() async{
  notes= await ApiServices.fetchNotes("aqsakhan");
  isLoading=false;
  sortNotes();
  notifyListeners();
}

List<Notes> getSearchData(String query){
  print("query is ${query} ${notes.where((element) => element.title!.toLowerCase().contains(query.toLowerCase())).toList()}");
  return notes.where((element) => element.title!.toLowerCase().contains(query.toLowerCase()) || element.content!.toLowerCase().contains(query.toLowerCase())).toList();


}




}