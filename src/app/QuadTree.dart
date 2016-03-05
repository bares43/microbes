import "dart:math";
import "Microbe.dart";

class QuadTree {
  int max_objects;
  int max_levels;

  int level;
  List<Microbe> objects;
  Rectangle<int> bounds;
  List<QuadTree> nodes;

  QuadTree(int level, Rectangle<int> bounds, int max_objects, int max_levels) {
    this.level = level;
    this.bounds = bounds;
    this.max_objects = max_objects;
    this.max_levels = max_levels;

    objects = new List();
    nodes = new List<QuadTree>(4);
  }

  void clear() {
    objects.clear();

    for (int i = 0; i < nodes.length; i++) {
      if (nodes[i] != null) {
        nodes[i].clear();
        nodes[i] = null;
      }
    }
  }

  void split() {
    int subWidth = bounds.width ~/ 2;
    int subHeight = bounds.height ~/ 2;
    int x = bounds.left;
    int y = bounds.top;

    nodes[0] = new QuadTree(level+1, new Rectangle<int>(x + subWidth, y, subWidth, subHeight), max_objects, max_levels);
    nodes[1] = new QuadTree(level+1, new Rectangle<int>(x, y, subWidth, subHeight), max_objects, max_levels);
    nodes[2] = new QuadTree(level+1, new Rectangle<int>(x, y + subHeight, subWidth, subHeight), max_objects, max_levels);
    nodes[3] = new QuadTree(level+1, new Rectangle<int>(x + subWidth, y + subHeight, subWidth, subHeight), max_objects, max_levels);
  }

  int getIndex(Microbe microbe) {
    int index = -1;
    double verticalMidpoint = bounds.left + (bounds.width / 2);
    double horizontalMidpoint = bounds.top + (bounds.height / 2);

    bool topQuadrant = (microbe.position.y.toInt() + microbe.size < horizontalMidpoint && microbe.position.y.toInt() - microbe.size < horizontalMidpoint);
    bool bottomQuadrant = (microbe.position.y.toInt() + microbe.size > horizontalMidpoint);

    if (microbe.position.x.toInt() - microbe.size < verticalMidpoint && microbe.position.x.toInt() + microbe.size < verticalMidpoint) {
      if (topQuadrant) {
        index = 1;
      }
      else if (bottomQuadrant) {
        index = 2;
      }
    }
    else if (microbe.position.x.toInt() - microbe.size > verticalMidpoint) {
      if (topQuadrant) {
        index = 0;
      }
      else if (bottomQuadrant) {
        index = 3;
      }
    }

    return index;
  }

  void insert(Microbe microbe) {
    if (nodes[0] != null) {
      int index = getIndex(microbe);

      if (index != -1) {
        nodes[index].insert(microbe);
        return;
      }
    }

    objects.add(microbe);

    if (objects.length > max_objects && level < max_levels) {
      if (nodes[0] == null) {
        split();
      }

      int i = 0;
      while (i < objects.length) {
        int index = getIndex(objects[i]);
        if (index != -1) {
          nodes[index].insert(objects.removeAt(i));
        }
        else {
          i++;
        }
      }
    }
  }

  List retrieve(List returnObjects, Microbe microbe) {
    int index = getIndex(microbe);
    if (index != -1 && nodes[0] != null) {
      nodes[index].retrieve(returnObjects, microbe);
    }

    returnObjects.addAll(objects);
    return returnObjects;
  }
}