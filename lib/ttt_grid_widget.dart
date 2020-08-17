import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TTTGridWidget extends StatefulWidget {
  String room;
  final bool isCreator;
  bool isMyTurn;
  final bool isPlayer;
  final int size;
  final String documentId;
  TTTGridWidget(
      {this.documentId,
      this.room,
      this.isPlayer,
      this.isCreator,
      this.isMyTurn,
      this.size});

  @override
  _TTTGridWidgetState createState() => _TTTGridWidgetState();
}

class _TTTGridWidgetState extends State<TTTGridWidget> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: widget.room.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.size),
      itemBuilder: (BuildContext context, int position) {
        return GestureDetector(
          onTap: () {
            updateMove(position);
          },
          child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
              ),
              child: Text(
                getSymbolFromNumber(
                    widget.room.substring(position, position + 1)),
                style: TextStyle(fontSize: 45),
              )),
        );
      },
    );
  }

  String getSymbolFromNumber(String item) {
    switch (item) {
      case "0":
        return "";
        break;
      case "1":
        return "O";
        break;
      case "2":
        return "X";
        break;
    }
  }

  Firestore _store = Firestore.instance;

  void updateMove(int position) {
    print(position);
    String myMove = "0";
    if (widget.isPlayer) {
      //Check my symbol
      String value = widget.room.substring(position, position + 1);
      if (value != "0") {
        return;
      }
      if (widget.isCreator) {
        myMove = "1";
      } else {
        myMove = "2";
      }
      if (widget.isMyTurn) {
        int start = position;
        int end = position + 1;
        if (end > 9) {
          end = 9;
        }
        String tempRoom = widget.room.substring(0, start) +
            myMove +
            widget.room.substring(end, 9);
        _store.collection("rooms").document(widget.documentId).updateData({
          "room": tempRoom,
          "turn": widget.isCreator ? "challenger" : "creator"
        });
      }
    }
  }
}
