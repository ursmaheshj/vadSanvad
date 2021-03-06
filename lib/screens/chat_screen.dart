import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vadsanvad/constants.dart';

final _auth = FirebaseAuth.instance;
final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();

  String? message;
  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      e.toString();
    }
  }

  // void getMessages() async {
  //   await for (var snapshot in _firestore.collection('Users').snapshots()) {
  //     for (var message in snapshot.docs) {
  //       for (var a in message.data().values) {
  //         print(a);
  //       }
  //     }
  //   }
  // }
  // void getm() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs) {
  //     for (var m in message.data().values) {
  //       print(m);
  //     }
  //   }
  // }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Flexible(
          child: Hero(
            tag: 'logo',
            child: Image.asset('images/logo.png'),
          ),
        ),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: const Text(
          'vadSanvad',
          style: TextStyle(fontSize: 30.0),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const MessagesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        //Do something with the user input.
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': message,
                        'sender': loggedInUser!.email,
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        // if (snapshot.hasData) {
        //   return const Center(
        //     child: CircularProgressIndicator(
        //         backgroundColor: Colors.lightBlueAccent),
        //   );
        // }
        List<MessageBubble> messageBubbles = [];
        if (snapshot.hasData) {
          final messages = snapshot.data;

          for (var message in messages!.docs.reversed) {
            final messageText = message['text'];
            final messageSender = message['sender'];

            final messageBubble = MessageBubble(
              text: messageText,
              sender: messageSender,
              isMe: loggedInUser!.email == messageSender,
            );
            messageBubbles.add(messageBubble);
          }
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

// ignore: must_be_immutable
class MessageBubble extends StatelessWidget {
  MessageBubble(
      {Key? key, required this.text, required this.sender, required this.isMe})
      : super(key: key);
  String text;
  String sender;
  bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(fontSize: 12.0, color: Colors.black38),
          ),
          Material(
            borderRadius: BorderRadius.only(
                topLeft: isMe ? const Radius.circular(30.0) : Radius.zero,
                topRight: isMe ? Radius.zero : const Radius.circular(30.0),
                bottomLeft: const Radius.circular(30.0),
                bottomRight: const Radius.circular(30.0)),
            elevation: 5,
            color: isMe ? Colors.lightBlue : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                text,
                style: TextStyle(
                    color: isMe ? Colors.white : Colors.black54,
                    fontSize: 15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
