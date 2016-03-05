import "dart:html";
import "package:vector_math/vector_math.dart";
import 'package:test/test.dart';
import "../src/app/Game.dart";
import "../src/app/Microbe.dart";
import "../src/app/DNA.dart";
import "../src/app/Renderer.dart";

void main() {
  CanvasElement canvas;
  Renderer renderer;
  Game game;
  DNA dna;
  Microbe microbe;

  setUp((){
    canvas = new CanvasElement();
    renderer = new Renderer(canvas);

    game = new Game(500, 500, renderer);
    game.enable_log = false;
    game.initGame();
    game.microbes = new List();
    game.MAX_COUNT_OF_MICROBES = 10;
  });

  test("microbe should correctly multiply and dna should be cloned", () {
    dna = new DNA.createRoot("", "");
    dna.min_energy_for_multiplying = 1.0;
    dna.max_childs = 1;
    dna.energy_cost_for_multiplying = 1.0;

    microbe = new Microbe(game, new Vector2(10.0, 10.0), dna);
    microbe.energy = 1.0;
    microbe.childrenCount = 0;
    game.addMicrobe(microbe);
    game.addMicrobes();

    expect(microbe.dna.generation, equals(0));
    microbe.multiply();
    game.addMicrobes();
    expect(microbe.energy, equals(0.0));

    Microbe child = game.microbes[1];

    expect(child, isNotNull);
    expect(child.dna.root.name, equals(microbe.dna.name));
    expect(child.dna.generation, equals(1));
  });

  test(
      "microbe shoudnt multiply because max count of microbes in game is reached", () {
    game.MAX_COUNT_OF_MICROBES = 1;

    DNA dna = new DNA.createRoot("", "");
    dna.min_energy_for_multiplying = 1.0;
    dna.max_childs = 1;
    dna.energy_cost_for_multiplying = 1.0;

    Microbe microbe = new Microbe(game, new Vector2(10.0, 10.0), dna);
    microbe.energy = 10.0;
    game.addMicrobe(microbe);
    game.addMicrobes();

    microbe.multiply();
    game.addMicrobes();
    expect(game.microbes.length, equals(1));
  });

  test("microbe shoudnt multiply because hasnt amount energy", () {
    game.MAX_COUNT_OF_MICROBES = game.microbes.length + 1;

    dna = new DNA.createRoot("", "");
    dna.min_energy_for_multiplying = 1.0;
    dna.max_childs = 1;
    dna.energy_cost_for_multiplying = 1.0;

    microbe = new Microbe(game, new Vector2(10.0, 10.0), dna);
    microbe.energy = 0.0;
    microbe.childrenCount = 0;
    game.addMicrobe(microbe);
    game.addMicrobes();

    microbe.dna.max_childs = 10;
    microbe.multiply();
    game.addMicrobes();
    expect(game.microbes.length, equals(1));
  });

  test(
      "microbe shoudnt multiply because his max count of descendent is reached", () {
    game.MAX_COUNT_OF_MICROBES = game.microbes.length + 1;

    dna = new DNA.createRoot("", "");
    dna.min_energy_for_multiplying = 1.0;
    dna.max_childs = 1;
    dna.energy_cost_for_multiplying = 1.0;

    microbe = new Microbe(game, new Vector2(10.0, 10.0), dna);
    microbe.energy = 0.0;
    microbe.childrenCount = 0;
    game.addMicrobe(microbe);
    game.addMicrobes();

    microbe.energy = microbe.dna.min_energy_for_multiplying + 1.0;
    microbe.dna.max_childs = microbe.childrenCount;
    microbe.multiply();
    game.addMicrobes();
    expect(game.microbes.length, equals(1));
  });
}
