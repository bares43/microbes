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

  test("microbe should move",(){
    Vector2 position = new Vector2(50.0, 50.0);

    Microbe microbe = new Microbe(game, position, new DNA.createRoot("",""));
    microbe.energy = 10.0;
    microbe.dna.energy_cost_for_moving = 1.0;
    microbe.dna.energy_cost_for_multiplying = .0;

    double x = microbe.position.x;
    double y = microbe.position.y;

    microbe.move();

    expect(microbe.position.x, isNot(x));
    expect(microbe.position.y, isNot(y));
    expect(microbe.energy, equals(9.0));
  });

  test("microbe should not move because of low energy",(){
    Vector2 position = new Vector2(10.0, 10.0);

    Microbe microbe = new Microbe(game, position, new DNA.createRoot("",""));
    microbe.energy = 0.0;
    microbe.dna.energy_cost_for_moving = 1.0;

    int x = microbe.position.x.toInt();
    int y = microbe.position.y.toInt();

    microbe.move();

    expect(microbe.position.x.toInt(), equals(x));
    expect(microbe.position.y.toInt(), equals(y));
    expect(microbe.energy, equals(0.0));
  });

  test("should be a collision",(){
    Vector2 position = new Vector2(10.0, 10.0);

    Microbe microbe = new Microbe(game, position, new DNA.createRoot("",""));
    microbe.size = 10;

    Vector2 position2 = new Vector2(10.0, 10.0);
    Microbe microbe2 = new Microbe(game, position2, new DNA.createRoot("",""));
    microbe2.size = 10;

    expect(microbe.checkCollision(microbe2), equals(true));
  });

  test("should not be a collision",(){
    Vector2 position = new Vector2(10.0, 10.0);

    Microbe microbe = new Microbe(game, position, new DNA.createRoot("",""));
    microbe.size = 10;

    Vector2 position2 = new Vector2(50.0, 50.0);
    Microbe microbe2 = new Microbe(game, position2, new DNA.createRoot("",""));
    microbe2.size = 10;

    expect(microbe.checkCollision(microbe2), equals(false));
  });

}