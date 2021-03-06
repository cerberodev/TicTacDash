import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tictacdash/ttt_grid_widget.dart';
import 'package:tictacdash/user_provider.dart';

class TicTacToePage extends StatelessWidget {
  final String documentId;
  TicTacToePage({this.documentId});
  Firestore _store = Firestore.instance;

  int size = 3;

  bool isMyTurn = false;
  bool isPlayer = false;
  bool isCreator = false;
  Stream<DocumentSnapshot> getStream(
      String documentId, String uid, String roomName) {
    print(documentId);
    if (documentId != null) {
      return _store.collection('rooms').document(documentId).snapshots();
    } else {
      return _store
          .collection('rooms')
          .where('creator', isEqualTo: uid)
          .where('name', isEqualTo: roomName)
          .snapshots()
          .map((event) => event.documents.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    String uid = Provider.of<UserChangeNotifier>(context).userId;
    String roomName = Provider.of<UserChangeNotifier>(context).room;
    print(uid);
    print(roomName);
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Center(
            child: StreamBuilder<DocumentSnapshot>(
              stream: getStream(documentId, uid, roomName),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                DocumentSnapshot ds = snapshot.data;
                String room = ds['room'];
                if (room == "") {
                  room = "000000000";
                }
                String player2 = ds['player2'];
                String player1 = ds['creator'];
                String player1Name = ds['player1Name'];
                String player2Name = ds['player2Name'];
                String currentTurn = ds['turn'];

                if (uid == player1 || uid == player2) {
                  isPlayer = true;
                }
                if (uid == player1) {
                  isCreator = true;
                }
                if (currentTurn == "creator" && isCreator) {
                  isMyTurn = true;
                } else {
                  isMyTurn = false;
                }
                return Column(
                  children: [
                    Text("$player1Name vs $player2Name"),
                    SizedBox(height: 35),
                    TTTGridWidget(
                        documentId: ds.documentID,
                        room: room,
                        size: 3,
                        isCreator: isCreator,
                        isMyTurn: isMyTurn,
                        isPlayer: isPlayer),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
