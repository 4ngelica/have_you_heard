import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:have_you_heard/models/game.dart';
import 'package:have_you_heard/models/room.dart';
import 'package:have_you_heard/models/player.dart';
import 'package:have_you_heard/models/socket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameController extends GetxController {
  String roomID = 'none';
  Player myPlayer = Player();

  Room room = Room();
  Game game = Game();
  Socket socket = Socket();

  bool onBoarded = false;
  String language = 'not_set';

  GameController();

  void exitGame() {
    game.reset();
    socket.leaveRoom();
  }

  Future<bool> getOnboardedState() async {
    final prefs = await SharedPreferences.getInstance();
    myPlayer.name = prefs.getString('username') ?? 'not_set';
    language = prefs.getString('locale') ?? 'not_set';

    if (myPlayer.name != 'not_set' && language != 'not_set') {
      onBoarded = true;
    }
    return onBoarded;
  }

  void setLocale (String language) {
    Locale locale;
    if (language == 'es') {
      locale = Locale('es', 'AR');
    } else {
      locale = Locale('pt', 'BR');
    }
    Get.updateLocale(locale);
  }

  void setLanguage(String language) {
    this.language = language;
    setLocale(language);
    sendLanguage();
  }
  void sendLanguage() {
    socket.sendLang(language);
  }

  void setPlayerName(String playerName) {
    myPlayer.name = playerName;
    sendPlayerName();
  }
  void sendPlayerName() {
    socket.sendName(myPlayer.name);
  }

  void saveUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
  }

  void createRoom() {
    socket.createRoom();
  }

  void joinRoom(String roomID) {
    socket.joinRoom(roomID);
  }

  void startGame(){
    socket.startGame();
  }

  void votePersona(String persona) {
    socket.votePersona(persona);
  }

  void sendAnswer(String answer) {
    socket.sendAnswer(answer);
  }

  void voteAnswer(String id) {
    socket.voteAnswer(id);
  }
}
