
import 'package:appflutter/Common/DateFormatApp.dart';
import 'package:appflutter/Common/Keys.dart';
import 'package:appflutter/Model/MessageChat.dart';
import 'package:appflutter/Widgets/ContentMessage.dart';
import 'package:flutter/material.dart';

class ReceivedMessage extends StatelessWidget {
  MessageChat message;
  ReceivedMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Row(
        children: <Widget>[
          Padding(padding:EdgeInsets.only(right: 10),
              child:CircleAvatar(
                radius: 15,
                backgroundImage: NetworkImage(Keys.chatState.currentState.peer.photoUrl),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${Keys.chatState.currentState.peer.userName}",
                style: Theme.of(context).textTheme.caption,
              ),
    Padding(padding: EdgeInsets.only(right: 10),
    child: ContentMessage(message,Colors.black87,Colors.grey[200])),
            ],
          ),
          Text(
            "${DateFormatApp.getDateFormat(message.timestamp)}",
            style: Theme.of(context).textTheme.body2.apply(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
