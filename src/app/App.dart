import "dart:html";
import "Game.dart";
import "Renderer.dart";
import "MicrobesGenerator.dart";

main(){
  new App();
}

class App {
  Game game;
  Element controlButton;

  App(){
    CanvasElement canvas = querySelector("#canvas");

    Renderer renderer = new Renderer(canvas);

    game = new Game(canvas.width, canvas.height, renderer);
    game.initGame();

    MicrobesGenerator.generate(game);

    controlButton = querySelector(".control__info__button__play");

    controlButton.onClick.listen((event) => playButton(event));
    querySelector(".control__info__button__reset").onClick.listen(resetButton);
  }

  void resetButton(event){
    game.stop();
    game.initGame();
    MicrobesGenerator.generate(game);
    game.run();
  }

  void playButton(event){
    if(controlButton.classes.contains("control__info__button__play--running")){
      game.stop();
      controlButton.classes.add("control__info__button__play--stopped");
      controlButton.classes.remove("control__info__button__play--running");
      controlButton.text = "Start";
    }else{
      game.run();
      controlButton.classes.add("control__info__button__play--running");
      controlButton.classes.remove("control__info__button__play--stopped");
      controlButton.text = "Stop";
    }
  }
}