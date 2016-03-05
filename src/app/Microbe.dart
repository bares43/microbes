import "package:sprintf/sprintf.dart";
import "package:vector_math/vector_math.dart";
import "../utils/Log.dart";
import "Game.dart";
import "DNA.dart";

class Microbe {

  final int MAX_SIZE = 50;
  final double MIN_SPEED = 2.0;
  final double MAX_SPEED = 50.0;

  Game game;
  DNA dna;
  String name;
  Vector2 position;
  Vector2 direction;
  bool alive = true;
  int born;
  int childrenCount = 0;

  double _speed;

  double get speed => _speed;

  void set speed(double value){
    if(value > MAX_SPEED){
      _speed = MAX_SPEED;
    }else if(value < MIN_SPEED){
      _speed = MIN_SPEED;
    }else{
      _speed = value;
    }
  }

  int _size;

  int get size {
    int s;
    if(dna.size_copy_energy){
      s = energy.toInt();
    }else{
      s = _size;
    }
    if(s > MAX_SIZE) s = MAX_SIZE;
    return s;
  }

  void set size(int value){
    if(value > MAX_SIZE){
      _size = MAX_SIZE;
    }else if(value < 1){
      _size = 1;
    }else{
      _size = value;
    }

    if(_size % dna.speed_change_by_size == 0){
      speed += dna.speed_change_by_size_value;
    }
  }


  double _energy;

  double get energy => _energy;

  void set energy(double value) {
    _energy = value;
    if(_energy <= 0){
      game.logger.add(sprintf("Microbe %s died at the age of %i.",[name, game.time - born]), Log.LOG_TYPE_DEATH);
      die();
    }
  }

  Microbe(Game game, Vector2 position, DNA dna){
    born = game.time;
    this.game = game;
    this.position = position;
    this.dna = dna;
    this.direction = new Vector2(1.0,1.0);
    if(game.random.nextBool()) this.direction.x *= -1;
    if(game.random.nextBool()) this.direction.y *= -1;
    speed = dna.base_speed;
    size = dna.base_size;
    energy = dna.base_energy;
    name = game.generateMicrobeName();
  }

  void multiply(){
    if(game.microbes.length + game.microbesToAdd.length - game.microbesToDelete.length < game.MAX_COUNT_OF_MICROBES && childrenCount < dna.max_childs && energy >= dna.min_energy_for_multiplying){
      Vector2 newPosition;
      if(dna.multiplying_random_position){
        newPosition = new Vector2(game.random.nextInt(game.canvas_width).toDouble(), game.random.nextInt(game.canvas_height).toDouble());
      }else{
        newPosition = new Vector2.copy(position);
        if(newPosition.x > game.canvas_width / 2 ){
          newPosition.x -= size + dna.base_size;
        }else{
          newPosition.x += size + dna.base_size;
        }
        if(newPosition.y > game.canvas_height / 2 ){
          newPosition.y -= size + dna.base_size;
        }else{
          newPosition.y += size + dna.base_size;
        }
      }

      Microbe child = new Microbe(game, newPosition, new DNA.clone(dna));

      energy -= dna.energy_cost_for_multiplying;
      childrenCount++;

      game.addMicrobe(child, this);
    }
  }

  void die(){
    alive = false;
    game.removeMicrobe(this);
  }

  void eat(Microbe microbe, [bool forceEating]){
    if(forceEating || isAllowedEatMicrobe(microbe)) {
      energy += microbe.energy;
      size += microbe.size;
      microbe.die();
      game.logger.add(sprintf(
          "Microbe %s ate microbe %s. Now he has energy %.2f",
          [name, microbe.name, energy]), Log.LOG_TYPE_EAT);
    }
  }

  void move(){
    if(energy > 0){

      Vector2 move = new Vector2.copy(direction).scale(speed);

      position.add(move);

      if(position.x + size >= game.canvas_width){
        position.x  = game.canvas_width.toDouble() - size;
        direction.x *= -1;
        direction.y = game.random.nextDouble();
      }

      if(position.x - size < 0){
        position.x = 0.0 + size;
        direction.x *= -1;
        direction.y = game.random.nextDouble();
      }

      if(position.y + size > game.canvas_height){
        position.y  = game.canvas_height.toDouble() - size;
        direction.y *= -1;
        direction.x = game.random.nextDouble();
      }

      if(position.y - size < 0){
        position.y = 0.0 + size;
        direction.y *= -1;
        direction.x = game.random.nextDouble();
      }

      energy -= dna.energy_cost_for_moving;

      if((game.time - born) % dna.multiply_period == 0){
        multiply();
      }

      if((game.time - born) % dna.speed_change_by_period == 0){
        speed += dna.speed_change_by_period_value;
      }

      if(dna.grow_period > -1 && (game.time - born) % dna.grow_period == 0){
        ++size;
      }
    }
  }

  bool isAllowedEatMicrobe(Microbe microbe){

    if(!alive || !microbe.alive) return false;
    if(name == microbe.name) return false;
    if(microbe.energy > energy) return false;

    if(dna.root.name == microbe.dna.root.name){
      if(!dna.can_eat_same_dna) return false;
      if(dna.generation == microbe.dna.generation && !dna.can_eat_same_dna_contemporary) return false;
      if(dna.generation > microbe.dna.generation) {
        var diff = dna.generation - microbe.dna.generation;
        if(diff < dna.can_eat_same_dna_ancestor_min_diff || (diff > dna.can_eat_same_dna_ancestor_max_diff && dna.can_eat_same_dna_ancestor_max_diff > -1)) return false;
      }
      if(dna.generation < microbe.dna.generation) {
        var diff = microbe.dna.generation - dna.generation;
        if(diff < dna.can_eat_same_dna_descendant_min_diff || (diff > dna.can_eat_same_dna_descendant_max_diff && dna.can_eat_same_dna_descendant_max_diff > -1)) return false;
      }
    }
    else{
      if(!dna.can_eat_different_dna) return false;
      if(dna.generation == microbe.dna.generation && !dna.can_eat_different_dna_contemporary) return false;
      if(dna.generation > microbe.dna.generation) {
        var diff = dna.generation - microbe.dna.generation;
        if(diff < dna.can_eat_different_dna_ancestor_min_diff || (diff > dna.can_eat_different_dna_ancestor_max_diff && dna.can_eat_different_dna_ancestor_max_diff > -1)) return false;
      }
      if(dna.generation < microbe.dna.generation) {
        var diff = microbe.dna.generation - dna.generation;
        if(diff < dna.can_eat_different_dna_descendant_min_diff || (diff > dna.can_eat_different_dna_descendant_max_diff && dna.can_eat_different_dna_descendant_max_diff > -1)) return false;
      }  
    }

    return true;
  }

  void hasCollision(Microbe microbe){
    if(isAllowedEatMicrobe(microbe) && checkCollision(microbe)){
      eat(microbe, true);
    }
  }

  bool checkCollision(Microbe microbe){
    int x_delta = position.x.toInt() - microbe.position.x.toInt();
    int y_delta = position.y.toInt() - microbe.position.y.toInt();
    int size_delta = size + microbe.size;

    return x_delta*x_delta + y_delta*y_delta <= size_delta*size_delta;
  }
}