import 'dart:convert';
import 'package:firebaseflutterproject/NodejsNotes/NotesApp/models/notes.dart';
import 'package:http/http.dart' as http;
class ApiServices{
  static const baseUrl="http://192.168.7.105:3000/notes";
  static Future<Map<String,dynamic>> addNoteApi(Notes note) async{
   try{

     Uri requestedUrl=Uri.parse(baseUrl+"/add");
     // print("provider add note is ${note} ${requestedUrl}");
     var response= await  http.post(
         requestedUrl,
         body: note.toMap());

     if(response.statusCode == 200){
       var decoded = jsonDecode(response.body);
       return Future.value({'error':0,'status':decoded['message']});

     }
    else{
       return Future.value({'error':1,'status':"Something went wrong ${response.body}"});

     }


   }
   catch(e){
     print("exception is ${e}");
     return Future.value({'error':1,'status':e.toString()});
   }


  }

  static Future<Map<String,dynamic>> deleNoteApi(Notes note) async{
   try{

     Uri requestedUrl=Uri.parse(baseUrl+"/delete");
     // print("provider add note is ${note} ${requestedUrl}");
     var response= await  http.post(
         requestedUrl,
         body: note.toMap());

     if(response.statusCode == 200){
       var decoded = jsonDecode(response.body);
       return Future.value({'error':0,'status':decoded['message']});

     }
    else{
       return Future.value({'error':1,'status':"Something went wrong ${response.body}"});

     }


   }
   catch(e){
     print("exception is ${e}");
     return Future.value({'error':1,'status':e.toString()});
   }


  }
  static Future<Map<String,dynamic>> updateNoteApi(Notes note) async{
   try{

     Uri requestedUrl=Uri.parse(baseUrl+"/update");
     // print("provider add note is ${note} ${requestedUrl}");
     var response= await  http.post(
         requestedUrl,
         body: note.toMap());
     print("${response.body}");
     if(response.statusCode == 200){
       var decoded = jsonDecode(response.body);
       return Future.value({'error':0,'status':decoded['message']});
     }
    else{
       return Future.value({'error':1,'status':"Something went wrong ${response.body}"});

     }


   }
   catch(e){
     print("exception is ${e}");
     return Future.value({'error':1,'status':e.toString()});
   }


  }
  static Future<List<Notes>> fetchNotes(String userid) async{

    Uri requestedUrl=Uri.parse(baseUrl+"/list");
    var response= await  http.post(
        requestedUrl,
        body: {"userid":userid});
    print("Response body is ${response.body}");
     var decoded = jsonDecode(response.body);
     List<Notes> notes=[];
     for(var noteMap in decoded['data'] ){
     Notes newnote=  Notes.fromMap(noteMap);
     notes.add(newnote);

     }

     return notes;

  }

  static Future<List<Notes>> fetchAllNotes(String userid) async{
    Uri requestedUrl=Uri.parse(baseUrl+"/alllist");
    var response= await  http.get(
        requestedUrl);
    // var decoded = jsonDecode(response.body);
    // print("Response Fetch Api data is ${decoded}");
    return [];

  }
}