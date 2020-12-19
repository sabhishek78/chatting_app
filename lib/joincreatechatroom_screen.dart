
import 'package:chatting_app/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class JoinCreateChatRoomScreen extends StatefulWidget {
  @override
  _JoinCreateChatRoomScreenState createState() =>
      _JoinCreateChatRoomScreenState();
}

class _JoinCreateChatRoomScreenState extends State<JoinCreateChatRoomScreen> {
  final CollectionReference chatroomRef = FirebaseFirestore.instance.collection('chatrooms');
  String chatroomId = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat Room List"),
        centerTitle: true,
        backgroundColor: Colors.blue,),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),

            SizedBox(
              height: 10,
            ),
            Expanded(
              child: Container(
                color: Colors.lightBlueAccent,
                child: StreamBuilder<QuerySnapshot>(
                  stream:
                  FirebaseFirestore.instance.collection('chatrooms').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(
                        child: Container(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator()),
                      );
                    } else {
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.all(10.0),
                        itemBuilder: (context, index) => GestureDetector(
                          child:Card(
                            elevation: 8.0,
                            margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
                            child: Container(
                              decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
                              child: ListTile(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                                  leading: Container(
                                    padding: EdgeInsets.only(right: 12.0),
                                    decoration: new BoxDecoration(
                                        border: new Border(
                                            right: new BorderSide(width: 1.0, color: Colors.white24))),
                                    child: Icon(Icons.autorenew, color: Colors.white),
                                  ),
                                  title: Text(
                                    '${snapshot.data.docs[index].id}',
                                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                  // subtitle: Text("Intermediate", style: TextStyle(color: Colors.white)),

                                  subtitle: Row(
                                    children: <Widget>[
                                      Icon(Icons.linear_scale, color: Colors.yellowAccent),
                                      Text(" Intermediate", style: TextStyle(color: Colors.white))
                                    ],
                                  ),
                                  trailing:
                                  Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0)),
                            ),
                          ),
                          onTap:() {
                            //Navigator.pushReplacementNamed(context, 'chat');
                            Navigator.push(
                                (context),
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChatScreen(chatroomId: snapshot.data.docs[index].id)));
                          },
                        ),
                        itemCount: snapshot.data.docs.length,

                      );
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter chatroom Id',
              ),
              keyboardType: TextInputType.text,
              maxLength: 12,
              onChanged: (text) {
                chatroomId = text;
              },
            ),
            RaisedButton(
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              child: Text(
                'Create Chat room',
                style: TextStyle(color: Colors.white, fontSize: 21),
              ),
              color: Colors.blue,
              // onPressed: () {Navigator.pushReplacementNamed(context, 'chat');},
              onPressed: () {
                chatroomRef
                    .doc(chatroomId)
                    .set({'timestamp': DateTime.now()});
              },
            ),
            /*   RaisedButton(
              padding: EdgeInsets.all(16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              child: Text(
                'Join Chat room',
                style: TextStyle(color: Colors.white, fontSize: 21),
              ),
              color: Colors.blue,
              onPressed: () {
                //Navigator.pushReplacementNamed(context, 'chat');
                Navigator.push(
                    (context),
                    MaterialPageRoute(
                        builder: (context) =>
                            ChatScreen(chatroomId: chatroomId)));
              },
            ),
            */
          ],
        ),
      ),
    );
  }
}
