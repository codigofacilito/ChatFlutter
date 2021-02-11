
import 'dart:async';

import 'package:appflutter/Common/DateFormatApp.dart';
import 'package:appflutter/DataBase/DataBase.dart';
import 'package:appflutter/Model/MessageChat.dart';
import 'package:appflutter/Model/UserChat.dart';
import 'package:appflutter/Pages/ChatPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  UserChat peer;
  UserChat user;
  UserCard(this.user, this.peer);

  @override
  State<StatefulWidget> createState() =>UserCardState(this.user, this.peer);
}

class UserCardState extends State<UserCard>{
  UserChat peer;
  UserChat user;
  UserCardState(this.user, this.peer);

  int count=0;
  MessageChat messageChat=MessageChat();
  StreamSubscription<Event>onAddedLastMessage;
  StreamSubscription<Event>onAddedSeen;
  @override
  void initState() {
    onAddedLastMessage = DataBase.tableMessage
        .child(getGroupId(user.id,peer.id))
        .limitToLast(1).onChildAdded.listen(onEntryAdded);


    onAddedSeen = DataBase.tableMessage
        .child(getGroupId(user.id,peer.id))
        .orderByChild("seen")
        .equalTo(false)
        .onChildAdded.listen(onEntrySeen);
  }

  getGroupId(String userId,String peerId){
    return  (userId.hashCode <= peerId.hashCode)? '${userId}-${peerId}':
    '${peerId}-${userId}';
  }

  onEntryAdded(Event event)async {
    MessageChat message=MessageChat.toMessage(event.snapshot);
    if(mounted)
      setState(() {
        this.messageChat=message;
      });
  }

  onEntrySeen(Event event)async {
    MessageChat message=MessageChat.toMessage(event.snapshot);
    if(message.idFrom!=user.id)
      setState(() {
        count=count+1;
      });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      elevation: 0.2,
      child:
      ListTile(
        isThreeLine: true,
        onTap: () {
       Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      ChatPage(
                        user: user,
                        peer: peer,
                      )));
        }
        ,
        leading:CircleAvatar(radius: 30,
          backgroundImage:
          NetworkImage(peer.photoUrl),
        ),
        title: Text(
          "${peer.userName}",
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          "${this.messageChat.content}",
          style: !(messageChat.seen)
              ? Theme.of(context)
              .textTheme
              .bodyText1
              .apply(color: Colors.black87)
              : Theme.of(context)
              .textTheme
              .bodyText1
              .apply(color: Colors.black54),
        ),
        trailing:  Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(DateFormatApp.getDateFormat(messageChat.timestamp)),
            count>0
                ? Container(
              alignment: Alignment.center,
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
                shape: BoxShape.circle,
              ),
              child: Text(
                "${count}",
                style: TextStyle(color: Colors.white),
              ),
            )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }



}
