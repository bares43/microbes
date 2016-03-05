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
  Microbe microbe;

  setUp((){
    canvas = new CanvasElement();
    renderer = new Renderer(canvas);
    game = new Game(500, 500, renderer);
    game.initGame();

    game.tree.max_objects = 1;
    game.tree.max_levels = 1;
    game.tree.clear();
  });

  group("retrieved microbes in rectangle", (){

    test("microbe should be", (){
      game.tree.clear();
      microbe = new Microbe(game, new Vector2(10.0,10.0), new DNA.createRoot("",""));
      game.tree.insert(microbe);

      List<Microbe> microbes = new List();
      game.tree.retrieve(microbes, microbe);

      expect(microbes.contains(microbe), equals(true));
    });

    test("microbe2 should be", (){
      game.tree.clear();
      microbe = new Microbe(game, new Vector2(10.0,10.0), new DNA.createRoot("",""));
      game.tree.insert(microbe);

      Microbe microbe2 = new Microbe(game, new Vector2(50.0,50.0), new DNA.createRoot("",""));
      game.tree.insert(microbe2);

      List<Microbe> microbes = new List();
      game.tree.retrieve(microbes, microbe);

      expect(microbes.contains(microbe2), equals(true));
    });

    test("microbe2 should not be", (){
      game.tree.clear();
      microbe = new Microbe(game, new Vector2(10.0,10.0), new DNA.createRoot("",""));
      game.tree.insert(microbe);

      Microbe microbe2 = new Microbe(game, new Vector2(300.0,300.0), new DNA.createRoot("",""));
      game.tree.insert(microbe2);

      List<Microbe> microbes = new List();
      game.tree.retrieve(microbes, microbe);

      expect(microbes.contains(microbe2), equals(false));
    });

    test("microbe2 should be", (){
      game.tree.clear();
      microbe = new Microbe(game, new Vector2(10.0,10.0), new DNA.createRoot("",""));
      game.tree.insert(microbe);

      Microbe microbe2 = new Microbe(game, new Vector2(110.0,110.0), new DNA.createRoot("",""));
      game.tree.insert(microbe2);

      List<Microbe> microbes = new List();
      game.tree.retrieve(microbes, microbe);

      expect(microbes.contains(microbe2), equals(true));
    });

  });
}