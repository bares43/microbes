import "dart:html";
import 'package:test/test.dart';
import "package:vector_math/vector_math.dart";
import "../src/app/Game.dart";
import "../src/app/Microbe.dart";
import "../src/app/DNA.dart";
import "../src/app/Renderer.dart";

void main(){

  CanvasElement canvas;
  Renderer renderer;
  Game game;

  setUp((){
    canvas = new CanvasElement();
    renderer = new Renderer(canvas);

    game = new Game(500,500, renderer);
    game.enable_log = false;
    game.initGame();
    game.microbes = new List();
  });

  group("deffered adding microbes",(){

    test("number of microbes should be 0",(){
      Microbe microbe = new Microbe(game, new Vector2(10.0, 10.0), new DNA.createRoot("",""));
      game.addMicrobe(microbe);
      expect(game.microbes.length, equals(0));
      expect(game.microbesToAdd.length, equals(1));
    });

    test("number of microbes should be 1",(){
      Microbe microbe = new Microbe(game, new Vector2(10.0, 10.0), new DNA.createRoot("",""));
      game.addMicrobe(microbe);
      game.addMicrobes();
      expect(game.microbes.length, equals(1));
      expect(game.microbesToAdd.length, equals(0));
    });

  });

  group("deffered removing microbes",(){

    test("number of microbes should be 1",(){
      Microbe microbe = new Microbe(game, new Vector2(10.0, 10.0), new DNA.createRoot("",""));
      game.addMicrobe(microbe);
      game.addMicrobes();
      game.removeMicrobe(microbe);
      expect(game.microbes.length, equals(1));
      expect(game.microbesToDelete.length, equals(1));
    });

    test("number of microbes should be 0",(){
      Microbe microbe = new Microbe(game, new Vector2(10.0, 10.0), new DNA.createRoot("",""));
      game.addMicrobe(microbe);
      game.addMicrobes();
      game.removeMicrobe(microbe);
      game.deleteMicrobs();
      expect(game.microbes.length, equals(0));
      expect(game.microbesToDelete.length, equals(0));
    });
  });

}
