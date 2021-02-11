import 'dart:async';

import 'package:appflutter/Common/DateFormatApp.dart';
import 'package:appflutter/DataBase/DataBase.dart';
import 'package:appflutter/Model/UserChat.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatAppBar extends StatefulWidget implements PreferredSizeWidget {
  UserChat peer;
  ChatAppBar(this.peer);
  @override
  State<StatefulWidget> createState() =>ChatAppBarState(this.peer);

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class ChatAppBarState extends State<ChatAppBar>{
  UserChat peer;
  ChatAppBarState(this.peer);
  StreamSubscription<Event>onChangeSubs;

  @override
  void initState() {
    onChangeSubs = DataBase.tableUser.orderByKey().equalTo(peer.id).onChildChanged.listen(onEntryChange);

    super.initState();
  }

  onEntryChange(Event event)async {
    UserChat newUser=UserChat.toUser(event.snapshot);
    if(mounted)
      setState(() {
        peer=newUser;
      });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return AppBar(
      backgroundColor: Colors.white,
      titleSpacing: 0,
      iconTheme: IconThemeData(color: Colors.black54),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(padding:EdgeInsets.all(5), child:CircleAvatar(
            radius: 17,
            backgroundImage: NetworkImage(peer.photoUrl),
          )),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                peer.userName,
                style: Theme.of(context).textTheme.subhead,
                overflow: TextOverflow.clip,
              ),
              Text(
                peer.isOnline?"Online":DateFormatApp.getDateFormat(peer.lastTime),
                style: Theme.of(context).textTheme.subtitle.apply(
                  color: Colors.green,
                ),
              )
            ],
          ))
        ],
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.phone),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.videocam),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }


}