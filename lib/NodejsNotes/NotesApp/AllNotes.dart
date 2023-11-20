
import 'package:firebaseflutterproject/NodejsNotes/NotesApp/addNote.dart';
import 'package:firebaseflutterproject/NodejsNotes/NotesApp/notesProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class GetNotes extends StatefulWidget {
  const GetNotes({Key? key}) : super(key: key);

  @override
  State<GetNotes> createState() => _GetNotesState();
}

class _GetNotesState extends State<GetNotes> {
String searchQuery="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
              context, MaterialPageRoute(
              fullscreenDialog: true,
              builder: (context) => AddNote(
                isUpdate: false,

              )));
        },
        child: Icon(Icons.add_circle_outline),
      ),
      appBar: AppBar(
        title:const Text("All Notes"),
      ),
      body:
      Consumer<NotesProvider>(

        builder: (BuildContext context,getNotes,child){
          return

            getNotes.isLoading ?
            Center(
              child: CircularProgressIndicator(
                color: Colors.redAccent,
              ),
            )
                :

            getNotes.notes.length > 0 ?
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextFormField(
                    style: TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: "Search Notes",

                    ),
                    onChanged: (value){
                    setState(() {
                      searchQuery=value;
                    });
                    },
                  ),
                ),
                getNotes.getSearchData(searchQuery).length > 0 ?
                Expanded(child: GridView.builder(
                    shrinkWrap: true,
                    itemCount: getNotes.getSearchData(searchQuery).length,
                    gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2
                    ),
                    itemBuilder: (BuildContext context,int index){
                      var currentNote=getNotes.getSearchData(searchQuery)[index];
                      return  InkWell(
                        onTap: (){
                          Navigator.push(
                              context, MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (context) => AddNote(
                                isUpdate: true,
                                note: currentNote,

                              )));
                        },
                        child:  Container(
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(10.0)
                          ),
                          margin: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                          child:Column(
                            //    mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: (){
                                        getNotes.deleteNote(currentNote);
                                      }, icon: Icon(Icons.delete,color:Colors.white,size: 20,)),
                                ],),
                              Text("${currentNote.title} ",
                                style: TextStyle(color: Colors.white),),
                              Text("${getNotes.notes[index].content} ",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                style: TextStyle(color: Colors.white, fontSize: 18,),),
                              Text("${currentNote.dataAdded} ",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 5,
                                style: TextStyle(color: Colors.white, fontSize: 14,),),
                            ],
                          ),
                        ),
                      );

                    }))
                :
                Center(
                  child: Text("No Notes Found",style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.w600),),
                )
                ,
              ],
            )

          :

              Center(
                child: Text("No Notes Yet",style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.w600),),
              )
          ;
        },
      )

    );
  }
}
