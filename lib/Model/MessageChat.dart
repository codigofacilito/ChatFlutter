import 'package:appflutter/DataBase/DataBase.dart';
import 'package:firebase_database/firebase_database.dart';

class MessageChat {
  String id;
  String content;
  String idFrom;
  String idTo;
  String timestamp;
  int type;
  bool seen;

  MessageChat(
      {this.id="",
        this.content="" ,
        this.idFrom ="",
        this.idTo="" ,
        this.timestamp="1612520639893" ,
        this.type=0 ,
        this.seen=false});

  Map<String, dynamic> toMap() {
    return {
      'id': this.timestamp,
      'content': this.content,
      'idFrom': this.idFrom,
      'idTo': this.idTo,
      'timestamp': this.timestamp,
      'type': this.type,
      'seen': this.seen
    };
  }

  MessageChat.toMessage(DataSnapshot snap) {
    this.id = snap.key;
    this.content = snap.value['content'];
    this.idFrom = snap.value['idFrom'];
    this.idTo = snap.value['idTo'];
    this.timestamp = snap.value['timestamp'];
    this.type = snap.value['type'];
    this.seen = snap.value['seen'];
  }

  save(String groupChatId){
    DataBase.tableMessage.child(groupChatId).child(this.timestamp).set(this.toMap());
  }

  update(String groupChatId)async{
   await DataBase.tableMessage.child(groupChatId).child(this.id).update({"seen":this.seen});
  }
}
