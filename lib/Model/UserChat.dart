import 'package:appflutter/DataBase/DataBase.dart';
import 'package:firebase_database/firebase_database.dart';

class UserChat {
  String id;
  String bio;
  String userName;
  String photoUrl;
  bool isOnline;
  String lastTime;

  UserChat(
      {this.id,
        this.bio,
        this.userName,
        this.photoUrl,
        this.isOnline ,
        this.lastTime});

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'bio': this.bio,
      'userName': this.userName,
      'photoUrl': this.photoUrl,
      'isOnline': this.isOnline,
      'lastTime': this.lastTime
    };
  }

  UserChat.toUser(var snap) {
    this.id = snap.key;
    this.bio = snap.value['bio'];
    this.userName = snap.value['userName'];
    this.photoUrl = snap.value['photoUrl'];
    this.isOnline = snap.value['isOnline'];
    this.lastTime = snap.value['lastTime'];
  }

  static getUser(String id) async{
    DataSnapshot snapshot= await DataBase.tableUser.equalTo(id,key: "id").once();
    return (snapshot.value!=null)?UserChat.toUser(snapshot):null;
  }

  save(){
    DataBase.tableUser.child(this.id).set(this.toMap());
  }


  updateIsOnline(){
    DataBase.tableUser.child(this.id).update({"isOnline":this.isOnline,"lastTime":this.lastTime});
  }

}
