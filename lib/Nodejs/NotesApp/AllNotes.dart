import 'package:firebaseflutterproject/Nodejs/NotesApp/addNote.dart';
import 'package:firebaseflutterproject/Nodejs/NotesApp/notesProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class GetNotes extends StatefulWidget {
  const GetNotes({Key? key}) : super(key: key);

  @override
  State<GetNotes> createState() => _GetNotesState();
}

class _GetNotesState extends State<GetNotes> {

  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider=Provider.of<NotesProvider>(context,listen: false);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){

          Navigator.push(
              context, MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => AddNote()));
        },
        child: Icon(Icons.add_circle_outline),
      ),
      appBar: AppBar(
        title:const Text("All Notes"),
      ),
      body: Consumer<NotesProvider>(

        builder: (BuildContext context,getNotes,child){
          return   GridView.builder(
              itemCount: getNotes.notes.length,
              gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2
              ),
              itemBuilder: (BuildContext context,int index){
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(10.0)
                    
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("${getNotes.notes[index].title} ",
                        style: TextStyle(color: Colors.white),),
                      Text("${getNotes.notes[index].content} ",
                        overflow: TextOverflow.ellipsis,
                        maxLines: 5,
                        style: TextStyle(color: Colors.white, fontSize: 18,),),

                    ],
                  ),
                );
              });
        },
      )

    );
  }
}
