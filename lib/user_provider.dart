import 'package:flutter/material.dart';

class UserChangeNotifier extends ChangeNotifier {
  String userId = "";
  String roomName = "";
  String get id => this.userId;
  String get room => this.roomName;
  void updateUserId(String userId) {
    this.userId = userId;
    notifyListeners();
  }

  void updateRoomName(String roomName) {
    this.roomName = roomName;
    notifyListeners();
  }
}
