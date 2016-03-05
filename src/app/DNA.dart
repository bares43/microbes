class DNA {

  DNA _root;

  DNA get root {
    if(generation == 0) return this;
    return _root;
  }

  void set root (DNA dna){
    _root = dna;
  }

  String color;
  String name;
  int generation = 0;

  double base_speed = 3.0;
  double base_energy = 10.0;
  int base_size = 5;

  bool multiplying_random_position = false;

  int max_childs = 10;
  double min_energy_for_multiplying = 1.0;
  double energy_cost_for_moving = 0.01;
  double energy_cost_for_multiplying = .5;
  int grow_period = 5;
  int multiply_period = 5;

  bool size_copy_energy = true;

  int speed_change_by_period = 5;
  double speed_change_by_period_value = 0.0;
  int speed_change_by_size = 10;
  double speed_change_by_size_value = 0.0;

  bool can_eat_same_dna = true;
  bool can_eat_same_dna_contemporary = true;
  int can_eat_same_dna_ancestor_min_diff = 2;
  int can_eat_same_dna_ancestor_max_diff = -1;
  int can_eat_same_dna_descendant_min_diff = 2;
  int can_eat_same_dna_descendant_max_diff = -1;

  bool can_eat_different_dna = true;
  bool can_eat_different_dna_contemporary = true;
  int can_eat_different_dna_ancestor_min_diff = 2;
  int can_eat_different_dna_ancestor_max_diff = -1;
  int can_eat_different_dna_descendant_min_diff = 2;
  int can_eat_different_dna_descendant_max_diff = -1;

  Function mutation = (DNA dna, DNA root){};

  DNA.createRoot(String color, String name){
    this.color = color;
    this.name = name;
  }

  DNA.clone(DNA parent){
    this.root = parent.root;
    name = parent.name;
    color = parent.color;
    generation = parent.generation + 1;

    base_speed = parent.base_speed;
    base_energy = parent.base_energy;
    base_size = parent.base_size;

    multiplying_random_position = parent.multiplying_random_position;
    max_childs = parent.max_childs;
    min_energy_for_multiplying = parent.min_energy_for_multiplying;
    energy_cost_for_moving = parent.energy_cost_for_moving;
    energy_cost_for_multiplying = parent.energy_cost_for_multiplying;
    grow_period = parent.grow_period;
    multiply_period = parent.multiply_period;

    size_copy_energy = parent.size_copy_energy;

    speed_change_by_period = parent.speed_change_by_period;
    speed_change_by_period_value = parent.speed_change_by_period_value;
    speed_change_by_size = parent.speed_change_by_size;
    speed_change_by_size_value = parent.speed_change_by_size_value;

    can_eat_same_dna = parent.can_eat_same_dna;
    can_eat_same_dna_contemporary = parent.can_eat_same_dna_contemporary;
    can_eat_same_dna_ancestor_min_diff = parent.can_eat_same_dna_ancestor_min_diff;
    can_eat_same_dna_ancestor_max_diff = parent.can_eat_same_dna_ancestor_max_diff;
    can_eat_same_dna_descendant_min_diff = parent.can_eat_same_dna_descendant_min_diff;
    can_eat_same_dna_descendant_max_diff = parent.can_eat_same_dna_descendant_max_diff;

    can_eat_different_dna = parent.can_eat_different_dna;
    can_eat_different_dna_contemporary = parent.can_eat_different_dna_contemporary;
    can_eat_different_dna_ancestor_min_diff = parent.can_eat_different_dna_ancestor_min_diff;
    can_eat_different_dna_ancestor_max_diff = parent.can_eat_different_dna_ancestor_max_diff;
    can_eat_different_dna_descendant_min_diff = parent.can_eat_different_dna_descendant_min_diff;
    can_eat_different_dna_descendant_max_diff = parent.can_eat_different_dna_descendant_max_diff;

    mutation = parent.mutation;

    mutate();
  }

  void mutate(){
    mutation(this, root);
  }

}