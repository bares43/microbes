import "dart:html";
import "package:vector_math/vector_math.dart";
import 'package:test/test.dart';
import "../src/app/Game.dart";
import "../src/app/Microbe.dart";
import "../src/app/DNA.dart";
import "../src/app/Renderer.dart";

void main(){

  CanvasElement canvas;
  Renderer renderer;
  Game game;
  Microbe microbe;
  DNA dna;

  setUp((){
    canvas = new CanvasElement();
    renderer = new Renderer(canvas);
    game = new Game(500, 500, renderer);
    game.initGame();
  });

  group("setting speed", (){

    test("setting a higher value than the MAX_SPEED", (){
      dna = new DNA.createRoot("","");
      microbe = new Microbe(game, new Vector2(10.0, 10.0), dna);

      microbe.speed = microbe.MAX_SPEED + 1;
      expect(microbe.speed, equals(microbe.MAX_SPEED));
    });

    test("setting a lower value than the MIN_SPEED", (){
      dna = new DNA.createRoot("","");
      microbe = new Microbe(game, new Vector2(10.0, 10.0), dna);

      microbe.speed = microbe.MIN_SPEED - 1;
      expect(microbe.speed, equals(microbe.MIN_SPEED));
    });

    test("setting a value betwen MIN_SPEED and MAX_SPEED", (){
      dna = new DNA.createRoot("","");
      microbe = new Microbe(game, new Vector2(10.0, 10.0), dna);

      microbe.speed = microbe.MIN_SPEED + 1;
      expect(microbe.speed, equals(microbe.MIN_SPEED + 1));
    });

  });

  group("setting size", (){

    test("setting a higher value than the MAX_SIZE", (){
      dna = new DNA.createRoot("","");
      dna.size_copy_energy = false;
      microbe = new Microbe(game, new Vector2(10.0, 10.0), dna);

      microbe.size = microbe.MAX_SIZE + 1;
      expect(microbe.size, equals(microbe.MAX_SIZE));
    });

    test("setting a lower value than the MIN_SIZE", (){
      dna = new DNA.createRoot("","");
      dna.size_copy_energy = false;
      microbe = new Microbe(game, new Vector2(10.0, 10.0), dna);

      microbe.size = 0;
      expect(microbe.size, equals(1));
    });

    test("setting a value betwen MIN_SIZE and MAX_SIZE", (){
      dna = new DNA.createRoot("","");
      dna.size_copy_energy = false;
      microbe = new Microbe(game, new Vector2(10.0, 10.0), dna);

      microbe.size = microbe.MAX_SIZE - 1;
      expect(microbe.size, equals(microbe.MAX_SIZE - 1));
    });

    test("size copy energy", (){
      dna = new DNA.createRoot("","");
      dna.size_copy_energy = true;
      dna.base_energy = 10.0;
      microbe = new Microbe(game, new Vector2(10.0, 10.0), dna);

      microbe.size = 2;
      expect(microbe.size, equals(10));
    });

    test("size copy energy which is higher than MAX_SIZE", (){
      dna = new DNA.createRoot("","");
      dna.size_copy_energy = true;
      dna.base_energy = (microbe.MAX_SIZE + 1).toDouble();
      microbe = new Microbe(game, new Vector2(10.0, 10.0), dna);

      expect(microbe.size, equals(microbe.MAX_SIZE.toDouble()));
    });

  });
}