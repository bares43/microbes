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
  Vector2 position;
  DNA dna;
  Microbe hunter;
  Microbe victim;

  setUp((){
    canvas = new CanvasElement();
    renderer = new Renderer(canvas);

    game = new Game(500,500, renderer);
    game.enable_log = false;
    game.initGame();

    position = new Vector2(10.0, 10.0);
  });

  group("force eating",(){
    test("victim should be dead", (){
      dna = new DNA.createRoot("","");
      dna.min_energy_for_multiplying = 1.0;
      dna.max_childs = 1;
      dna.energy_cost_for_multiplying = 1.0;

      hunter = new Microbe(game, position, dna);
      game.addMicrobe(hunter);
      game.addMicrobes();

      victim = new Microbe(game, position, dna);
      game.addMicrobe(victim);
      game.addMicrobes();

      victim.energy = 5.0;
      hunter.energy = 4.0;
      victim.size = 2;
      hunter.size = 1;

      hunter.eat(victim, true);
      expect(victim.alive, equals(false));
    });

    test("hunter should has victims energy and size",(){
      dna = new DNA.createRoot("","");
      dna.min_energy_for_multiplying = 1.0;
      dna.max_childs = 1;
      dna.energy_cost_for_multiplying = 1.0;
      dna.size_copy_energy = false;

      hunter = new Microbe(game, position, dna);
      game.addMicrobe(hunter);
      game.addMicrobes();

      victim = new Microbe(game, position, dna);
      game.addMicrobe(victim);
      game.addMicrobes();

      victim.energy = 5.0;
      hunter.energy = 4.0;
      victim.size = 2;
      hunter.size = 1;

      hunter.eat(victim, true);

      expect(hunter.energy, equals(9.0));
      expect(hunter.size, equals(3));
    });
  });

  test("eating should not be allowed because hunter has lower energy",(){
    dna = new DNA.createRoot("","dna");
    dna.can_eat_same_dna = true;
    dna.can_eat_same_dna_contemporary = true;

    hunter = new Microbe(game, position, dna);
    victim = new Microbe(game, position, dna);

    hunter.energy = 4.0;
    victim.energy = 5.0;

    expect(hunter.isAllowedEatMicrobe(victim), equals(false));
  });

  test("cannot eat himself",(){
    dna = new DNA.createRoot("","dna");
    dna.can_eat_same_dna = false;
    dna.can_eat_same_dna_contemporary = true;

    hunter = new Microbe(game, position, dna);

    expect(hunter.isAllowedEatMicrobe(hunter), equals(false));
  });

  test("cannot eat same dna",(){
    dna = new DNA.createRoot("","dna");
    dna.can_eat_same_dna = false;
    dna.can_eat_same_dna_contemporary = true;

    hunter = new Microbe(game, position, dna);
    victim = new Microbe(game, position, dna);

    hunter.energy = 5.0;
    victim.energy = 4.0;

    expect(hunter.isAllowedEatMicrobe(victim), equals(false));
  });

  test("cannot eat same dna contemporary",(){
    dna = new DNA.createRoot("","dna");
    dna.can_eat_same_dna = true;
    dna.can_eat_same_dna_contemporary = false;

    hunter = new Microbe(game, position, dna);
    victim = new Microbe(game, position, dna);

    hunter.energy = 5.0;
    victim.energy = 4.0;

    expect(hunter.isAllowedEatMicrobe(victim), equals(false));
  });

  group("eating same dna descendant", (){
    test("should not eat because generation diff is lower than min_diff", (){
      dna = new DNA.createRoot("","dna");
      dna.can_eat_same_dna = true;
      dna.can_eat_same_dna_descendant_min_diff = 2;
      dna.can_eat_same_dna_descendant_max_diff = 3;

      DNA dnaVictim = new DNA.clone(dna);

      hunter = new Microbe(game, position, dna);
      victim = new Microbe(game, position, dnaVictim);

      hunter.energy = 5.0;
      victim.energy = 4.0;

      expect(hunter.isAllowedEatMicrobe(victim), equals(false));
    });

    test("should eat because generation diff is equal min_diff", (){
      dna = new DNA.createRoot("","dna");
      dna.can_eat_same_dna = true;
      dna.can_eat_same_dna_descendant_min_diff = 2;
      dna.can_eat_same_dna_descendant_max_diff = 3;

      DNA dnaVictim = new DNA.clone(dna);

      hunter = new Microbe(game, position, dna);
      victim = new Microbe(game, position, dnaVictim);

      hunter.energy = 5.0;
      victim.energy = 4.0;

      victim.dna.generation = 2;
      expect(hunter.isAllowedEatMicrobe(victim), equals(true));
    });

    test("should eat because generation diff is equal max_diff", (){
      dna = new DNA.createRoot("","dna");
      dna.can_eat_same_dna = true;
      dna.can_eat_same_dna_descendant_min_diff = 2;
      dna.can_eat_same_dna_descendant_max_diff = 3;

      DNA dnaVictim = new DNA.clone(dna);

      hunter = new Microbe(game, position, dna);
      victim = new Microbe(game, position, dnaVictim);

      hunter.energy = 5.0;
      victim.energy = 4.0;

      victim.dna.generation = 3;
      expect(hunter.isAllowedEatMicrobe(victim), equals(true));
    });

    test("should not eat because generation diff is higher than max_diff", (){
      dna = new DNA.createRoot("","dna");
      dna.can_eat_same_dna = true;
      dna.can_eat_same_dna_descendant_min_diff = 2;
      dna.can_eat_same_dna_descendant_max_diff = 3;

      DNA dnaVictim = new DNA.clone(dna);

      hunter = new Microbe(game, position, dna);
      victim = new Microbe(game, position, dnaVictim);

      hunter.energy = 5.0;
      victim.energy = 4.0;

      victim.dna.generation = 4;
      expect(hunter.isAllowedEatMicrobe(victim), equals(false));
    });
  });

  group("eating same dna ancestor", (){
    test("should not eat because generation diff is lower than min_diff",(){
      dna = new DNA.createRoot("","dna");

      DNA dnaHunter = new DNA.clone(dna);
      dnaHunter.can_eat_same_dna = true;
      dnaHunter.can_eat_same_dna_ancestor_min_diff = 2;
      dnaHunter.can_eat_same_dna_ancestor_max_diff = 3;

      hunter = new Microbe(game, position, dnaHunter);
      victim = new Microbe(game, position, dna);

      hunter.energy = 5.0;
      victim.energy = 4.0;

      expect(hunter.isAllowedEatMicrobe(victim), equals(false));
    });

    test("should eat because generation diff is equal min_diff",(){
      dna = new DNA.createRoot("","dna");

      DNA dnaHunter = new DNA.clone(dna);
      dnaHunter.can_eat_same_dna = true;
      dnaHunter.can_eat_same_dna_ancestor_min_diff = 2;
      dnaHunter.can_eat_same_dna_ancestor_max_diff = 3;

      hunter = new Microbe(game, position, dnaHunter);
      victim = new Microbe(game, position, dna);

      hunter.energy = 5.0;
      victim.energy = 4.0;

      hunter.dna.generation = 2;
      expect(hunter.isAllowedEatMicrobe(victim), equals(true));
    });

    test("should eat because generation diff is equal max_diff",(){
      dna = new DNA.createRoot("","dna");

      DNA dnaHunter = new DNA.clone(dna);
      dnaHunter.can_eat_same_dna = true;
      dnaHunter.can_eat_same_dna_ancestor_min_diff = 2;
      dnaHunter.can_eat_same_dna_ancestor_max_diff = 3;

      hunter = new Microbe(game, position, dnaHunter);
      victim = new Microbe(game, position, dna);

      hunter.energy = 5.0;
      victim.energy = 4.0;

      hunter.dna.generation = 3;
      expect(hunter.isAllowedEatMicrobe(victim), equals(true));
    });

    test("should not eat because generation diff is higher than max_diff",(){
      dna = new DNA.createRoot("","dna");

      DNA dnaHunter = new DNA.clone(dna);
      dnaHunter.can_eat_same_dna = true;
      dnaHunter.can_eat_same_dna_ancestor_min_diff = 2;
      dnaHunter.can_eat_same_dna_ancestor_max_diff = 3;

      hunter = new Microbe(game, position, dnaHunter);
      victim = new Microbe(game, position, dna);

      hunter.energy = 5.0;
      victim.energy = 4.0;

      hunter.dna.generation = 4;
      expect(hunter.isAllowedEatMicrobe(victim), equals(false));
    });
  });

  test("cannot eat different",(){
    dna = new DNA.createRoot("","dna");
    dna.can_eat_different_dna = false;
    dna.can_eat_different_dna_contemporary = true;

    DNA dnaVictim = new DNA.createRoot("","victim");

    hunter = new Microbe(game, position, dna);
    victim = new Microbe(game, position, dnaVictim);

    hunter.energy = 5.0;
    victim.energy = 4.0;

    expect(hunter.isAllowedEatMicrobe(victim), equals(false));
  });

  test("cannot eat same dna contemporary",(){
    dna = new DNA.createRoot("","dna");
    dna.can_eat_different_dna = true;
    dna.can_eat_different_dna_contemporary = false;

    DNA dnaVictim = new DNA.createRoot("","victim");

    hunter = new Microbe(game, position, dna);
    victim = new Microbe(game, position, dnaVictim);

    hunter.energy = 5.0;
    victim.energy = 4.0;

    expect(hunter.isAllowedEatMicrobe(victim), equals(false));
  });

  group("eating different dna descendant",(){
    test("should not eat because generation diff is lower than min_diff", (){
      dna = new DNA.createRoot("","dna");
      dna.can_eat_different_dna = true;
      dna.can_eat_different_dna_descendant_min_diff = 2;
      dna.can_eat_different_dna_descendant_max_diff = 3;

      DNA dnaVictim = new DNA.createRoot("","victim");
      dnaVictim.root = dnaVictim;
      dnaVictim.generation = 1;

      hunter = new Microbe(game, position, dna);
      victim = new Microbe(game, position, dnaVictim);

      hunter.energy = 5.0;
      victim.energy = 4.0;

      expect(hunter.isAllowedEatMicrobe(victim), equals(false));
    });

    test("should eat because generation diff is equal min_diff", (){
      dna = new DNA.createRoot("","dna");
      dna.can_eat_different_dna = true;
      dna.can_eat_different_dna_descendant_min_diff = 2;
      dna.can_eat_different_dna_descendant_max_diff = 3;

      DNA dnaVictim = new DNA.createRoot("","victim");
      dnaVictim.root = dnaVictim;
      dnaVictim.generation = 1;

      hunter = new Microbe(game, position, dna);
      victim = new Microbe(game, position, dnaVictim);

      hunter.energy = 5.0;
      victim.energy = 4.0;

      victim.dna.generation = 2;
      expect(hunter.isAllowedEatMicrobe(victim), equals(true));
    });

    test("should eat because generation diff is equal max_diff", (){
      dna = new DNA.createRoot("","dna");
      dna.can_eat_different_dna = true;
      dna.can_eat_different_dna_descendant_min_diff = 2;
      dna.can_eat_different_dna_descendant_max_diff = 3;

      DNA dnaVictim = new DNA.createRoot("","victim");
      dnaVictim.root = dnaVictim;
      dnaVictim.generation = 1;

      hunter = new Microbe(game, position, dna);
      victim = new Microbe(game, position, dnaVictim);

      hunter.energy = 5.0;
      victim.energy = 4.0;

      victim.dna.generation = 3;
      expect(hunter.isAllowedEatMicrobe(victim), equals(true));
    });

    test("should not eat because generation diff is higher than max_diff", (){
      dna = new DNA.createRoot("","dna");
      dna.can_eat_different_dna = true;
      dna.can_eat_different_dna_descendant_min_diff = 2;
      dna.can_eat_different_dna_descendant_max_diff = 3;

      DNA dnaVictim = new DNA.createRoot("","victim");
      dnaVictim.root = dnaVictim;
      dnaVictim.generation = 1;

      hunter = new Microbe(game, position, dna);
      victim = new Microbe(game, position, dnaVictim);

      hunter.energy = 5.0;
      victim.energy = 4.0;

      victim.dna.generation = 4;
      expect(hunter.isAllowedEatMicrobe(victim), equals(false));
    });

  });

  group("eating different dna ancestor",(){
    test("should not eat because generation diff is lower than min_diff",(){
      dna = new DNA.createRoot("","dna");

      DNA dnaHunter = new DNA.createRoot("","hunter");
      dnaHunter.root = dnaHunter;
      dnaHunter.can_eat_different_dna = true;
      dnaHunter.can_eat_different_dna_ancestor_min_diff = 2;
      dnaHunter.can_eat_different_dna_ancestor_max_diff = 3;
      dnaHunter.generation = 1;

      hunter = new Microbe(game, position, dnaHunter);
      victim = new Microbe(game, position, dna);

      hunter.energy = 5.0;
      victim.energy = 4.0;

      expect(hunter.isAllowedEatMicrobe(victim), equals(false));
    });

    test("should eat because generation diff is equal min_diff",(){
      dna = new DNA.createRoot("","dna");

      DNA dnaHunter = new DNA.createRoot("","hunter");
      dnaHunter.root = dnaHunter;
      dnaHunter.can_eat_different_dna = true;
      dnaHunter.can_eat_different_dna_ancestor_min_diff = 2;
      dnaHunter.can_eat_different_dna_ancestor_max_diff = 3;
      dnaHunter.generation = 1;

      hunter = new Microbe(game, position, dnaHunter);
      victim = new Microbe(game, position, dna);

      hunter.energy = 5.0;
      victim.energy = 4.0;

      hunter.dna.generation = 2;
      expect(hunter.isAllowedEatMicrobe(victim), equals(true));
    });

    test("should eat because generation diff is equal max_diff",(){
      dna = new DNA.createRoot("","dna");

      DNA dnaHunter = new DNA.createRoot("","hunter");
      dnaHunter.root = dnaHunter;
      dnaHunter.can_eat_different_dna = true;
      dnaHunter.can_eat_different_dna_ancestor_min_diff = 2;
      dnaHunter.can_eat_different_dna_ancestor_max_diff = 3;
      dnaHunter.generation = 1;

      hunter = new Microbe(game, position, dnaHunter);
      victim = new Microbe(game, position, dna);

      hunter.energy = 5.0;
      victim.energy = 4.0;

      hunter.dna.generation = 3;
      expect(hunter.isAllowedEatMicrobe(victim), equals(true));
    });

    test("should not eat because generation diff is higher than max_diff",(){
      dna = new DNA.createRoot("","dna");

      DNA dnaHunter = new DNA.createRoot("","hunter");
      dnaHunter.root = dnaHunter;
      dnaHunter.can_eat_different_dna = true;
      dnaHunter.can_eat_different_dna_ancestor_min_diff = 2;
      dnaHunter.can_eat_different_dna_ancestor_max_diff = 3;
      dnaHunter.generation = 1;

      hunter = new Microbe(game, position, dnaHunter);
      victim = new Microbe(game, position, dna);

      hunter.energy = 5.0;
      victim.energy = 4.0;

      hunter.dna.generation = 4;
      expect(hunter.isAllowedEatMicrobe(victim), equals(false));
    });

  });

}