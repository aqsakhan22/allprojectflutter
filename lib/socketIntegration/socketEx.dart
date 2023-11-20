import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
class SocketExample extends StatefulWidget {
  const SocketExample({Key? key}) : super(key: key);

  @override
  State<SocketExample> createState() => _SocketExampleState();
}

class _SocketExampleState extends State<SocketExample> {
   late IO.Socket socket;
   String SocketUrl="http://192.168.7.110:4000/";
   // String SocketUrl="http://localhost:3000/";
   // in mac book we use setting > wifi > ipa address
   TextEditingController messagecontroller=new TextEditingController(text:'');
   @override
  void initState() {
    // TODO: implement initState
     initSocket();
    super.initState();
  }
   initSocket() {
     socket = IO.io(SocketUrl, <String, dynamic>{
       'autoConnect': false,
       'transports': ['websocket'],
       'reconnection': true,
     });

     socket.connect();
     socket.onConnect((_) {
       print('Connection established');
     });
     socket.on('chat message', (newMessage) {
       print("we receive message is ${newMessage}");
     //  messageList.add(MessageModel.fromJson(data));
     });
     socket.onDisconnect((_) => print('Connection Disconnection'));
     socket.onConnectError((err) => print(err));
     socket.onError((err) => print(err));
   }

   sendMessage() {
     String message = messagecontroller.text.trim();
     if (message.isEmpty) return;
     Map<String,dynamic> messageMap = {
       'message': message,
       'senderId': "senderId",
       'receiverId': "receiverId",
       'time': DateTime.now().millisecondsSinceEpoch,
     };
     print("Message is ${messageMap}");
     socket.emit('chat message', messageMap);
   }

   @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    socket.disconnect();
    socket.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Socket Programing"),
      ),
      body: Column(
        children: [
          TextFormField(
            controller: messagecontroller,
          ),
        ElevatedButton(
            onPressed: (){
              sendMessage();
            }
            ,
            child: Text("Send message"))
        ],
      ),
    );
  }
}
