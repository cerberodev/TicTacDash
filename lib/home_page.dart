import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: createRoom,
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              TextField(
                onChanged: (String newName) {
                  this.name = newName;
                },
                decoration: InputDecoration(hintText: "Player name"),
              ),
              Expanded(
                child: SizedBox(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _store = Firestore.instance;
  void createRoom() async {
    AuthResult result = await _auth.signInAnonymously();
    String uid = result.user.uid;
    String roomName = 'tempa';
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
          'player': '',
        });
      } else {
        _store.collection('rooms').document().setData({
          'active': true,
          'creator': uid,
          'name': roomName,
          'player': '',
        });
      }
    });
    /* ;*/
  }
}
