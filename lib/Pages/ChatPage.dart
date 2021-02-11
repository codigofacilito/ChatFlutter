import 'dart:async';
import 'package:appflutter/Common/Keys.dart';
import 'package:appflutter/DataBase/DataBase.dart';
import 'package:appflutter/Model/MessageChat.dart';
import 'package:appflutter/Model/UserChat.dart';
import 'package:appflutter/Widgets/ChatAppBar.dart';
import 'package:appflutter/Widgets/ReceivedMessage.dart';
import 'package:appflutter/Widgets/SentMessage.dart';
import 'package:appflutter/Widgets/StickerGridview.dart';
import 'package:appflutter/Widgets/TextFieldChat.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  UserChat user;
  UserChat peer;

  ChatPage({Key key, this.user, this.peer}) : super(key:Keys.chatState);

  @override
  State createState() => ChatState(this.user, this.peer);
}

class ChatState extends State<ChatPage> {
  UserChat user;
  UserChat peer;

  ChatState(this.user, this.peer);

  String groupChatId = "";
  int _limit = 20;
  final int _limitIncrement = 20;

  bool isShowSticker = false;

  final ScrollController listScrollController = ScrollController();

  final TextEditingController textEditingController = TextEditingController();
  List<MessageChat> messages = List();
  StreamSubscription<Event> onAddedSubs;
  StreamSubscription<Event> onChangeSubs;
  @override
  void initState() {
    super.initState();
    loadGroupChatId();
    listScrollController.addListener(_scrollListener);
    onAddedSubs = getQuery().onChildAdded.listen(onEntryAdded);
    onChangeSubs = getQuery().onChildChanged.listen(onEntryChanged);

  }

  Query getQuery() {
    return DataBase.tableMessage
        .child(groupChatId)
        .orderByChild('timestamp')
        .limitToLast(_limit);
  }


  onEntryAdded(Event event) async {
    MessageChat messageChat = await updateSeen(event.snapshot);
    setState(() {
      messages.add(messageChat);
      messages..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    });
  }

  onEntryChanged(Event event) async {
    if (mounted) {
      MessageChat oldEntry = messages.singleWhere((entry) {
        return entry.id == event.snapshot.key;
      });

      MessageChat messageChat = await updateSeen(event.snapshot);
      setState(() {
        messages[messages.indexOf(oldEntry)] = messageChat;
        messages..sort((a, b) => b.timestamp.compareTo(a.timestamp));
      });
    }
  }

  updateSeen(DataSnapshot snapshot) async {
    MessageChat messageChat = MessageChat.toMessage(snapshot);
    if (messageChat.idFrom != user.id) {
      messageChat.seen = true;
      await messageChat.update(groupChatId);
    }

    return messageChat;
  }

  loadGroupChatId() async {
    setState(() {
      groupChatId = (user.id.hashCode <= peer.id.hashCode)
          ? '${user.id}-${peer.id}'
          : '${peer.id}-${user.id}';
    });
  }

  _scrollListener() {
    if (listScrollController.offset >=
        listScrollController.position.maxScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("llegar al fondo");
      setState(() {
        _limit += _limitIncrement;
      });
    }
    if (listScrollController.offset <=
        listScrollController.position.minScrollExtent &&
        !listScrollController.position.outOfRange) {
      print("llegar al arriba");
      setState(() {
      });
    }
  }



  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      //user..chattingWith=null..updateChattingWith();
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: ChatAppBar(peer),
        body: WillPopScope(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // List of messages
                  buildListMessage(),
                  (isShowSticker)?
                  StickerGridView():SizedBox.shrink(),
                  TextFieldChat()
                ],
              ),
            ],
          ),
          onWillPop: onBackPress,
        ));
  }


  showSticker(bool isShowSticker){
    setState(() {
      this.isShowSticker=isShowSticker;
    });
  }

  buildItem(MessageChat messageChat){
    return (messageChat.idFrom==this.user.id)?SentMessage(messageChat):ReceivedMessage(messageChat);
  }

  Widget buildListMessage() {
    return Flexible(
        child: groupChatId == ''
            ? Center(
            child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red)))
            : ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemBuilder: (context, index) =>
              buildItem(messages[index]),
          itemCount: messages.length,
          reverse: true,
          controller: listScrollController,
        ));
  }

  void onSendMessage(int type, {String content}) {
    content = (content == null) ? textEditingController.text : content;
    // type: 0 = text, 1 = image, 2 = sticker
    if (content.isNotEmpty) {
      textEditingController.clear();
      MessageChat(
          seen: false,
          idFrom: user.id,
          idTo: peer.id,
          timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
          content: content,
          type: type)
          .save(groupChatId);

      listScrollController.animateTo(0.0,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    }
  }


}
