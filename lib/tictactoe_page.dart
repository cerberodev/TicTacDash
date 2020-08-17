import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictacdash/ttt_grid_widget.dart';
import 'package:tictacdash/user_provider.dart';

class TicTacToePage extends StatelessWidget {
  Firestore _store = Firestore.instance;

  int size = 3;

  bool isMyTurn = false;
  bool isPlayer = false;
  bool isCreator = false;

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<UserChangeNotifier>(context).userId;
    String roomName = Provider.of<UserChangeNotifier>(context).room;
    print(uid);
    print(roomName);
    return Scaffold(
      body: Container(
        child: Center(
          child: StreamBuilder(
            stream:  _store
        .collection('rooms')
        .where('creator', isEqualTo: uid)
        .where('name', isEqualTo: roomName)
        .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              snapshot.data.documents.
              return TTTGridWidget(
                  room: "122111200",
                  size: 3,
                  isCreator: isCreator,
                  isMyTurn: isMyTurn,
                  isPlayer: isPlayer);
            },
          ),
        ),
      ),
    );
  }
}
