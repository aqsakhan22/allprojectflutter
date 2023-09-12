import 'package:firebaseflutterproject/TopVariables.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

//learn from
//https://medium.com/flutter-community/flutter-integrating-socket-io-client-2a8f6e208810
class SoccketIntegration {
  IO.Socket socket = IO.io(TopVaraible.socketServerURL, <String, dynamic>{
    'autoConnect': false,
    'reconnection': true,
    'transports': ['websocket'],
  });

  // In order to listen to the changes, we will use a socket.on() method.
  //
  // socket.on('message-received', (data) => print(data));

  // Here, ‘message-received’ is the event name whereas in the function we can specify whatever we want to do after listening to the changes.
  //
  // After listening to the changes, we might need to emit the event from our end, for that we have a socket.emit() method.
  //
  // socket.emit('send-message',{"roomID": "123"});

  initSocket() {
    print('initSocket');

    socket.connect();
    socket.onConnect((_) {
      print('Connection established');
    });
    socket.onDisconnect((_) => print('Connection Disconnection'));
    socket.onConnectError((err) => print(err));
    socket.onError((err) => print(err));
  }

  socketDisconnect() {
    socket.disconnect();
  }

  sendMessage() {
    String message = "hello i am aqsa khan";
    if (message.isEmpty) return;
    Map messageMap = {
      'message': message,
      'senderId': "ID1",
      'receiverId': "RECEIVEID",
      'time': DateTime.now().millisecondsSinceEpoch,
    };
    //sendNewMessage is event when you want to send message to this event
    socket.emit('sendNewMessage', messageMap);
  }

  receiveMessage() {
    //To add a listener, you can use socket.on(),
    // and it will start listening to new events and will be triggered on all emits that happen on the socket server.
    socket.on('getMessageEvent', (newMessage) {
      // messageList.add(MessageModel.fromJson(data));
    });
  }
}
