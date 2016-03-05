import "../app/Game.dart";

class Log {

  static final String LOG_TYPE_BORN = "born";
  static final String LOG_TYPE_DEATH = "death";
  static final String LOG_TYPE_EAT = "eat";
  static final String LOG_TYPE_COLLISION = "collision";

  Game game;

  Log(Game game){
    this.game = game;
  }

  void add(String message, [String type]){
    if(game.enable_log) print(message);
  }
}