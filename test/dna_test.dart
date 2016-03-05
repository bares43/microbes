import "dart:html";
import "package:vector_math/vector_math.dart";
import 'package:test/test.dart';
import "../src/app/DNA.dart";
import "../src/app/Microbe.dart";
import "../src/app/Renderer.dart";
import '../src/app/Game.dart';

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
  });

  test("access to root dna", (){
    DNA rootDNA = new DNA.createRoot("","dna");
    rootDNA.mutation = (DNA dna, DNA root){};
    DNA firstClonedDNAFromRoot = new DNA.clone(rootDNA);
    DNA secondClonedDNAFromFirst = new DNA.clone(firstClonedDNAFromRoot);

    expect(rootDNA.root, equals(rootDNA));
    expect(firstClonedDNAFromRoot.root, equals(rootDNA));
    expect(secondClonedDNAFromFirst.root, equals(rootDNA));
  });

  test("dna should be cloned",(){
    DNA rootDNA = new DNA.createRoot("#ffffff","dna");
    rootDNA.mutation = (DNA dna, DNA root){};

    ++rootDNA.base_speed;
    ++rootDNA.base_energy;
    ++rootDNA.base_size;
    rootDNA.multiplying_random_position != rootDNA.multiplying_random_position;
    ++rootDNA.max_childs;
    ++rootDNA.min_energy_for_multiplying;
    ++rootDNA.energy_cost_for_moving;
    ++rootDNA.energy_cost_for_multiplying;
    ++rootDNA.grow_period;
    ++rootDNA.multiply_period;
    rootDNA.size_copy_energy != rootDNA.size_copy_energy;
    ++rootDNA.speed_change_by_period;
    ++rootDNA.speed_change_by_period_value;
    ++rootDNA.speed_change_by_size;
    ++rootDNA.speed_change_by_size_value;
    rootDNA.can_eat_same_dna != rootDNA.can_eat_same_dna;
    rootDNA.can_eat_same_dna_contemporary != rootDNA.can_eat_same_dna_contemporary;
    ++rootDNA.can_eat_same_dna_ancestor_min_diff;
    ++rootDNA.can_eat_same_dna_ancestor_max_diff;
    ++rootDNA.can_eat_same_dna_descendant_min_diff;
    ++rootDNA.can_eat_same_dna_descendant_max_diff;
    rootDNA.can_eat_different_dna != rootDNA.can_eat_different_dna;
    rootDNA.can_eat_different_dna_contemporary != rootDNA.can_eat_different_dna_contemporary;
    ++rootDNA.can_eat_different_dna_ancestor_min_diff;
    ++rootDNA.can_eat_different_dna_ancestor_max_diff;
    ++rootDNA.can_eat_different_dna_descendant_min_diff;
    ++rootDNA.can_eat_different_dna_descendant_max_diff;

    DNA firstClonedDNAFromRoot = new DNA.clone(rootDNA);

    expect(firstClonedDNAFromRoot, isNotNull);
    expect(firstClonedDNAFromRoot.generation, equals(1));
    expect(firstClonedDNAFromRoot.color, equals(rootDNA.color));
    expect(firstClonedDNAFromRoot.name, equals(rootDNA.name));

    expect(firstClonedDNAFromRoot.base_speed, equals(rootDNA.base_speed));
    expect(firstClonedDNAFromRoot.base_energy, equals(rootDNA.base_energy));
    expect(firstClonedDNAFromRoot.base_size, equals(rootDNA.base_size));
    expect(firstClonedDNAFromRoot.multiplying_random_position, equals(rootDNA.multiplying_random_position));
    expect(firstClonedDNAFromRoot.max_childs, equals(rootDNA.max_childs));
    expect(firstClonedDNAFromRoot.min_energy_for_multiplying, equals(rootDNA.min_energy_for_multiplying));
    expect(firstClonedDNAFromRoot.energy_cost_for_moving, equals(rootDNA.energy_cost_for_moving));
    expect(firstClonedDNAFromRoot.energy_cost_for_multiplying, equals(rootDNA.energy_cost_for_multiplying));
    expect(firstClonedDNAFromRoot.grow_period, equals(rootDNA.grow_period));
    expect(firstClonedDNAFromRoot.multiply_period, equals(rootDNA.multiply_period));
    expect(firstClonedDNAFromRoot.size_copy_energy, equals(rootDNA.size_copy_energy));
    expect(firstClonedDNAFromRoot.speed_change_by_period, equals(rootDNA.speed_change_by_period));
    expect(firstClonedDNAFromRoot.speed_change_by_period_value, equals(rootDNA.speed_change_by_period_value));
    expect(firstClonedDNAFromRoot.speed_change_by_size, equals(rootDNA.speed_change_by_size));
    expect(firstClonedDNAFromRoot.speed_change_by_size_value, equals(rootDNA.speed_change_by_size_value));
    expect(firstClonedDNAFromRoot.can_eat_same_dna, equals(rootDNA.can_eat_same_dna));
    expect(firstClonedDNAFromRoot.can_eat_same_dna_contemporary, equals(rootDNA.can_eat_same_dna_contemporary));
    expect(firstClonedDNAFromRoot.can_eat_same_dna_ancestor_min_diff, equals(rootDNA.can_eat_same_dna_ancestor_min_diff));
    expect(firstClonedDNAFromRoot.can_eat_same_dna_ancestor_max_diff, equals(rootDNA.can_eat_same_dna_ancestor_max_diff));
    expect(firstClonedDNAFromRoot.can_eat_same_dna_descendant_min_diff, equals(rootDNA.can_eat_same_dna_descendant_min_diff));
    expect(firstClonedDNAFromRoot.can_eat_same_dna_descendant_max_diff, equals(rootDNA.can_eat_same_dna_descendant_max_diff));
    expect(firstClonedDNAFromRoot.can_eat_different_dna, equals(rootDNA.can_eat_different_dna));
    expect(firstClonedDNAFromRoot.can_eat_different_dna_contemporary, equals(rootDNA.can_eat_different_dna_contemporary));
    expect(firstClonedDNAFromRoot.can_eat_different_dna_ancestor_min_diff, equals(rootDNA.can_eat_different_dna_ancestor_min_diff));
    expect(firstClonedDNAFromRoot.can_eat_different_dna_ancestor_max_diff, equals(rootDNA.can_eat_different_dna_ancestor_max_diff));
    expect(firstClonedDNAFromRoot.can_eat_different_dna_descendant_min_diff, equals(rootDNA.can_eat_different_dna_descendant_min_diff));
    expect(firstClonedDNAFromRoot.can_eat_different_dna_descendant_max_diff, equals(rootDNA.can_eat_different_dna_descendant_max_diff));

  });

  test("mutation of dna",(){

    DNA rootDNA = new DNA.createRoot("","dna");
    rootDNA.mutation = (DNA dna, DNA root){};
    DNA firstClonedDNAFromRoot = new DNA.clone(rootDNA);

    rootDNA.mutation = (DNA dna, DNA root){
      dna.max_childs += 1;
      dna.grow_period += 1;
    };

    firstClonedDNAFromRoot = new DNA.clone(rootDNA);
    expect(firstClonedDNAFromRoot.max_childs, equals(rootDNA.max_childs + 1));
    expect(firstClonedDNAFromRoot.grow_period, equals(rootDNA.grow_period + 1));

    firstClonedDNAFromRoot.mutation = (DNA dna, DNA root){
      dna.max_childs += 1;
      dna.grow_period = root.grow_period;
    };

    DNA thirdClonedDNAFromFirst = new DNA.clone(firstClonedDNAFromRoot);
    expect(thirdClonedDNAFromFirst.grow_period, equals(rootDNA.grow_period));
    expect(thirdClonedDNAFromFirst.max_childs, equals(firstClonedDNAFromRoot.max_childs + 1));

    thirdClonedDNAFromFirst.grow_period++;
    expect(thirdClonedDNAFromFirst.grow_period, equals(rootDNA.grow_period + 1));

    thirdClonedDNAFromFirst.mutate();
    expect(thirdClonedDNAFromFirst.grow_period, equals(rootDNA.grow_period));
    expect(thirdClonedDNAFromFirst.max_childs, equals(firstClonedDNAFromRoot.max_childs + 2));

    DNA fourthClonedDNAFromThird = new DNA.clone(thirdClonedDNAFromFirst);
    expect(fourthClonedDNAFromThird.max_childs, equals(thirdClonedDNAFromFirst.max_childs + 1));
    expect(fourthClonedDNAFromThird.grow_period, equals(rootDNA.grow_period));

  });

  test("base_speed", (){
    DNA dna = new DNA.createRoot("","");
    dna.base_speed = 10.0;
    Microbe microbe = new Microbe(game, new Vector2(10.0,10.0), dna);

    expect(microbe.speed, equals(dna.base_speed));
  });

  test("grow_period", (){
    DNA dna = new DNA.createRoot("","");
    dna.grow_period = 3;
    dna.size_copy_energy = false;
    Microbe microbe = new Microbe(game, new Vector2(10.0,10.0), dna);
    microbe.size = 5;

    game.time++;
    microbe.move();
    expect(microbe.size,equals(5));

    game.time++;
    microbe.move();
    expect(microbe.size,equals(5));

    game.time++;
    microbe.move();
    expect(microbe.size,equals(6));

    game.time++;
    microbe.move();
    expect(microbe.size,equals(6));

    game.time++;
    microbe.move();
    expect(microbe.size,equals(6));

    game.time++;
    microbe.move();
    expect(microbe.size,equals(7));
  });

  test("multiply_period", (){
    DNA dna = new DNA.createRoot("","");
    dna.multiply_period = 3;

    Microbe microbe = new Microbe(game, new Vector2(10.0,10.0), dna);
    microbe.size = 5;
    game.addMicrobe(microbe);
    game.addMicrobes();

    game.time++;
    microbe.move();
    game.addMicrobes();
    expect(game.microbes.length,equals(1));

    game.time++;
    microbe.move();
    game.addMicrobes();
    expect(game.microbes.length,equals(1));

    game.time++;
    microbe.move();
    game.addMicrobes();
    expect(game.microbes.length,equals(2));

    game.time++;
    microbe.move();
    game.addMicrobes();
    expect(game.microbes.length,equals(2));

    game.time++;
    microbe.move();
    game.addMicrobes();
    expect(game.microbes.length,equals(2));

    game.time++;
    microbe.move();
    game.addMicrobes();
    expect(game.microbes.length,equals(3));
  });

  test("speed_change_by_period", (){
    DNA dna = new DNA.createRoot("","");
    dna.speed_change_by_period = 3;
    dna.speed_change_by_period_value = 1.5;
    Microbe microbe = new Microbe(game, new Vector2(10.0,10.0), dna);
    microbe.speed = 5.0;
    game.addMicrobe(microbe);
    game.addMicrobes();

    game.time++;
    microbe.move();
    expect(microbe.speed,equals(5.0));

    game.time++;
    microbe.move();
    expect(microbe.speed,equals(5.0));

    game.time++;
    microbe.move();
    expect(microbe.speed,equals(6.5));

    game.time++;
    microbe.move();
    expect(microbe.speed,equals(6.5));

    game.time++;
    microbe.move();
    expect(microbe.speed,equals(6.5));

    game.time++;
    microbe.move();
    expect(microbe.speed,equals(8.0));
  });

  test("speed_change_by_size_value", (){
    DNA dna = new DNA.createRoot("","");
    dna.speed_change_by_size = 3;
    dna.speed_change_by_size_value = 1.5;
    dna.size_copy_energy = false;
    Microbe microbe = new Microbe(game, new Vector2(10.0,10.0), dna);
    microbe.speed = 5.0;
    microbe.size = 1;
    game.addMicrobe(microbe);
    game.addMicrobes();

    microbe.size++;
    expect(microbe.speed, equals(5.0));

    microbe.size++;
    expect(microbe.speed, equals(6.5));

    microbe.size++;
    expect(microbe.speed, equals(6.5));
  });
}