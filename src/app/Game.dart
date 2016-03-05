import 'dart:html';
import "dart:math";
import "package:sprintf/sprintf.dart";
import "../utils/Log.dart";
import "../utils/StringUtil.dart";
import "Microbe.dart";
import "Renderer.dart";
import "QuadTree.dart";

class Game {

  int MAX_COUNT_OF_MICROBES = 500;

  QuadTree tree;

  List<Microbe> microbes = new List<Microbe>();
  List<String> baseNames = new List<String>();
  List<Microbe> microbesToAdd = new List();
  List<Microbe> microbesToDelete = new List();
  int time = 0;
  int maxReachedCountOfMicrobes = 0;
  int canvas_width;
  int canvas_height;
  Renderer renderer;
  bool running = false;
  Random random = new Random();
  List<Microbe> canBeCollision;
  Log logger;
  bool enable_log = true;

  Game(int width, int height, Renderer renderer){
    canvas_width = width;
    canvas_height = height;
    this.renderer = renderer;
  }

  void initGame(){
    tree = new QuadTree(0, new Rectangle<int>(0,0,canvas_width, canvas_height), 50, 25);
    canBeCollision = new List();
    microbes = new List();
    microbesToAdd = new List();
    microbesToDelete = new List();
    logger = new Log(this);
    renderer.clearCanvas();
    fillBaseNames();
  }

  void run(){
    running = true;
    window.animationFrame.then(tick);
  }

  void stop(){
    running = false;
  }

  void addMicrobes(){
    microbesToAdd.forEach((microbe) => microbes.add(microbe));
    microbesToAdd.clear();
  }

  void deleteMicrobs(){
    microbesToDelete.forEach((microbe) => microbes.remove(microbe));
    microbesToDelete.clear();
  }

  void tick(num delta){
    microbesToAdd.clear();
    microbesToDelete.clear();

    tree.clear();

    microbes.forEach((microbe){
      microbe.move();
      tree.insert(microbe);
    });

    microbes.forEach((microbe){
      canBeCollision.clear();
      canBeCollision = tree.retrieve(canBeCollision, microbe);
      canBeCollision.forEach((victim) => microbe.hasCollision(victim));
    });

    deleteMicrobs();
    addMicrobes();

    renderer.clearCanvas();

    microbes.forEach((microbe) => renderer.renderMicrobe(microbe));

    if(microbes.length > maxReachedCountOfMicrobes){
      maxReachedCountOfMicrobes = microbes.length;
      querySelector(".control__info__microbes_max_count").text = maxReachedCountOfMicrobes.toString();
    }

    if(microbes.length == 0) {
      stop();
    }

    if(running){
      window.animationFrame.then(tick);
    }

    time++;

    querySelector(".control__info__microbes_count").text = '${((microbes.length / 100).round()*100).toString()} (${microbes.length.toString()})';
    querySelector(".control__info__time").text = time.toString();
  }

  void addMicrobe(Microbe microbe, [Microbe parent]){
    microbesToAdd.add(microbe);

    String messageParent = parent != null ? sprintf(" %s gave birth to him.",[parent.name]) : "";
    String message = sprintf("Mikrobe %s was born.%s",[microbe.name, messageParent]);

    logger.add(message, Log.LOG_TYPE_BORN);
  }

  void removeMicrobe(Microbe microbe){
    microbesToDelete.add(microbe);
  }

  String generateMicrobeName(){
    int position = random.nextInt(baseNames.length);
    String name = baseNames[position]+"-"+time.toString()+"-";
    String surname = StringUtils.randomString(10);
    name += surname;
    return name;
  }

  void fillBaseNames(){
    baseNames.add("Benjamin");
    baseNames.add("Ian");
    baseNames.add("Antonio");
    baseNames.add("Emily");
    baseNames.add("Mallory");
    baseNames.add("Garry");
    baseNames.add("Judy");
    baseNames.add("Rebeca");
    baseNames.add("Jim");
  }
}