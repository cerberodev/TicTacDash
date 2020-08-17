import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictacdash/tictactoe_page.dart';
import 'package:tictacdash/user_provider.dart';

class HomePage extends StatelessWidget {
  String name = "";
  String roomName = "";
  String uid = "";
  TextEditingController tec = TextEditingController();
  //Todo: Fix hot restart bug
  @override
  Widget build(BuildContext context) {
    uid = Provider.of<UserChangeNotifier>(context).userId;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => launchPopup(context),
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              TextField(
                controller: tec,
                onChanged: (String newName) {
                  this.name = newName;
                },
                decoration: InputDecoration(hintText: "Player name"),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _store.collection('rooms').snapshots(),
                  builder:
                      (BuildContext context, AsyncSnapshot<QuerySnapshot> qs) {
                    if (!qs.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                        itemCount: qs.data.documents.length,
                        itemBuilder: (BuildContext context, int position) {
                          String name =
                              qs.data.documents[position].data["name"];
                          String creator =
                              qs.data.documents[position].data["creator"];
                          bool active =
                              qs.data.documents[position].data['active'];
                          String player2 =
                              qs.data.documents[position].data['player2'];
                          int counter = 0;
                          counter = active ? counter + 1 : counter;
                          counter = player2 == "" ? counter + 1 : counter;
                          String players = "$counter/ 2";
                          return ListTile(
                              onTap: () {
                                if (uid == creator) {
                                  Provider.of<UserChangeNotifier>(context,
                                          listen: false)
                                      .updateRoomName(name);
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) {
                                    return TicTacToePage();
                                  }));
                                } else {
                                  _store
                                      .collection('rooms')
                                      .document(qs
                                          .data.documents[position].documentID)
                                      .updateData({
                                    'player': uid,
                                    'player2Name': tec.text,
                                  });
                                }
                              },
                              title: Text(name),
                              trailing: Text(players));
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void launchPopup(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext newContext) {
          return AlertDialog(
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.of(newContext).pop();
                    },
                    child: Text("Cancel")),
                FlatButton(
                    onPressed: () {
                      createRoom(context);
                    },
                    child: Text("Create Room"))
              ],
              content: Container(
                child: TextField(
                  onChanged: (String newRoomName) {
                    roomName = newRoomName;
                  },
                  decoration: InputDecoration(hintText: "Room name"),
                ),
              ));
        });
  }

  Firestore _store = Firestore.instance;
  void createRoom(BuildContext context) async {
    name = tec.text;
    if (roomName == "" || name == "") {
      return;
    }
    Provider.of<UserChangeNotifier>(context, listen: false)
        .updateRoomName(roomName);
    //Creates or updates user id
    _store.collection('users').document(uid).setData(({
          'username': name,
        }));
    //Create or updates rooms
    _store
        .collection('rooms')
        .where('creator', isEqualTo: uid)
        .where('name', isEqualTo: roomName)
        .snapshots()
        .first
        .then((QuerySnapshot value) {
      if (value.documents.length > 0) {
        String documentId = value.documents.first.documentID;
        _store.collection('rooms').document(documentId).setData({
          'active': true,
          'creator': uid,
          'name': roomName,
          'player1Name': name,
          'player': '',
          'player2Name': '',
          'room': '000000000',
          'turn': 'creator',
        });
      } else {
        _store.collection('rooms').document().setData({
          'active': true,
          'creator': uid,
          'name': roomName,
          'player': '',
          'player1Name': name,
          'player2Name': '',
          'room': '000000000',
          'turn': 'creator',
        });
      }
    });
    /* ;*/

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return TicTacToePage();
    }));
  }
}
