class Notes{
  String? id;
  String? userid;
  String? title;
  String? content;
  DateTime? dataAdded;

  Notes({this.id,this.userid,this.title,this.content,this.dataAdded});

  factory Notes.fromMap(Map<String,dynamic> map){
    return Notes(
      id: map['id'],
      userid: map['userid'],
      title: map['title'],
      content: map['content'],
      dataAdded: DateTime.tryParse(map['dateAdded'])


    );
  }


  Map<String,dynamic> toMap(){

    return {
      'id':id,   'userid':userid,   'title':title,   'content':content,   'dataAdded':dataAdded!.toIso8601String(),
    };
  }
}