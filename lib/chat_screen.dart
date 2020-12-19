
import 'package:chatting_app/chat_bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'check_box.dart';

String currentUserEmail = '';

class ChatScreen extends StatefulWidget {
  final String chatroomId;
  List<String> chatText=[];
  ChatScreen({this.chatroomId,this.chatText});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}
class Wrapper{
  bool buttonDisabled;
  Wrapper(this.buttonDisabled);
  void alter(Wrapper object){
    object.buttonDisabled=!object.buttonDisabled;
  }
}

class _ChatScreenState extends State<ChatScreen> {

  String currentUserEmail = '';
  bool _isVisible=false;

  Wrapper button=Wrapper(false);
  TextEditingController controller = TextEditingController();

  @override
  void initState() {

    super.initState();
    controller.addListener(() {

      setState(() {});
    });
    getUser();
    //currentUserEmail=FirebaseAuth.instance.currentUser().toString();
  }

  void getUser() async {
    User user = FirebaseAuth.instance.currentUser;
    currentUserEmail = user.email;
  }

  /* void getMessagesStream() async {

    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();
    currentUserEmail = currentUser.email;
    await for (var snapshot
        in Firestore.instance.collection('McLarenChat').snapshots()) {
      chatWidgets.clear();
      for (var message in snapshot.documents) {
        String text = message.data['text'];
        String sender = message.data['sender'];
        chatWidgets.add(ChatBubble(
          text: text,
          sender: sender,
          isUser: sender == currentUserEmail,
        ));
      }
      setState(() {});
    }
  }*/


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'chatroom ${widget.chatroomId}',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontFamily: 'OldLondon',
          ),
        ),
        actions: <Widget>[
          /* IconButton(
              icon: Icon(Icons.cloud_download),
              onPressed: getMessagesStream,
            ), */
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                setState(() {
                  _isVisible=!_isVisible;
                });

              }),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('chatrooms')
                        .document(widget.chatroomId)
                        .collection('messages')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return CircularProgressIndicator();
                      }
                      return ListView.builder(
                        itemBuilder: (context, index) {
                          return ChatBubble(
                            text: snapshot.data.documents[index].data['text'],
                            sender:
                            snapshot.data.documents[index].data['sender'],
                            isUser:
                            snapshot.data.documents[index].data['sender'] ==
                                currentUserEmail,
                          );
                        },
                        itemCount: snapshot.data.documents.length,
                        shrinkWrap: true,
                      );
                    },
                  ))),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(

                      controller: controller,
                      maxLines: 1,
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    Icons.send,
                  ),
                  color: Colors.blue,

                  onPressed: controller.text.isEmpty || button.buttonDisabled ? null : sendmessage,

                )
              ],
            ),
          ),
          Visibility(
            visible: _isVisible,
            child: CheckBox(controller: controller,button:button),
          )
        ],
      ),
    );
  }

  Future sendmessage() async {
    await Firestore.instance
        .collection('chatrooms')
        .document(widget.chatroomId)
        .collection('messages')
        .add({
      'sender': currentUserEmail,
      'text': controller.text,
    });
    controller.clear();
  }
}
