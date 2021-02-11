

import 'package:appflutter/Common/DateFormatApp.dart';
import 'package:appflutter/Model/MessageChat.dart';
import 'package:flutter/material.dart';

import 'ContentMessage.dart';

class SentMessage extends StatelessWidget {
  MessageChat message;
  SentMessage(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            "${DateFormatApp.getDateFormat(message.timestamp)}",
            style: Theme.of(context).textTheme.body2.apply(color: Colors.grey),
          ),
          Padding(padding: EdgeInsets.only(left: 10),
              child:ContentMessage(message,Colors.white,Colors.green,isSend: true,) ),
        ],
      ),
    );
  }
}
