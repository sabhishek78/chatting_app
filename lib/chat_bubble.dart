import 'package:flutter/material.dart';
class ChatBubble extends StatelessWidget {
  String text;
  String sender;
  ShapeBorder shape;
  bool isUser=false;
  ChatBubble({this.text, this.sender,this.shape,this.isUser});
  ShapeBorder shapeMe= RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
          topLeft: Radius.circular(15.0)
      )
  );
  ShapeBorder shapeOthers= RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
          topRight: Radius.circular(15.0)
      )
  );
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        mainAxisAlignment: isUser? MainAxisAlignment.end: MainAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: isUser? CrossAxisAlignment.end: CrossAxisAlignment.start,
            children: <Widget>[
              Text(sender,
                style: TextStyle(color:Colors.grey),
              ),
              SizedBox(
                height: 4,
              ),
              Material(
                color: isUser? Color(0xFF1E88E5):Colors.white,
                elevation: 8,
                shape: isUser? shapeMe: shapeOthers,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 8,horizontal: 18),
                  child: Text(
                    text,
                    style: TextStyle(
                        fontSize: 18,
                        color: isUser? Colors.white: Colors.grey.shade700),
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              )

            ],
          )
        ],
      ),
    );
  }
}
