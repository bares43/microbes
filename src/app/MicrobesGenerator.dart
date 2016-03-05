import "package:vector_math/vector_math.dart";
import "../utils/StringUtil.dart";
import "Game.dart";
import "DNA.dart";
import "Microbe.dart";

class MicrobesGenerator {

  static void generate(Game game){

    DNA dna = new DNA.createRoot("#33ccff", StringUtils.randomString(10));
    game.addMicrobe(new Microbe(game, new Vector2(game.random.nextInt(game.canvas_width).toDouble(), game.random.nextInt(game.canvas_height).toDouble()), dna));

    dna = new DNA.createRoot("#006699", StringUtils.randomString(10));
    game.addMicrobe(new Microbe(game, new Vector2(game.random.nextInt(game.canvas_width).toDouble(), game.random.nextInt(game.canvas_height).toDouble()), dna));

    dna = new DNA.createRoot("#ff9900", StringUtils.randomString(10));
    game.addMicrobe(new Microbe(game, new Vector2(game.random.nextInt(game.canvas_width).toDouble(), game.random.nextInt(game.canvas_height).toDouble()), dna));

    dna = new DNA.createRoot("#ff0066", StringUtils.randomString(10));
    game.addMicrobe(new Microbe(game, new Vector2(game.random.nextInt(game.canvas_width).toDouble(), game.random.nextInt(game.canvas_height).toDouble()), dna));

    dna = new DNA.createRoot("#669933", StringUtils.randomString(10));
    game.addMicrobe(new Microbe(game, new Vector2(game.random.nextInt(game.canvas_width).toDouble(), game.random.nextInt(game.canvas_height).toDouble()), dna));

    dna = new DNA.createRoot("#cc6600", StringUtils.randomString(10));
    game.addMicrobe(new Microbe(game, new Vector2(game.random.nextInt(game.canvas_width).toDouble(), game.random.nextInt(game.canvas_height).toDouble()), dna));

    game.addMicrobes();

  }
}