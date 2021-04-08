#!/usr/bin/env dart

void main() {
  int add(int n, int m) {
    return n + m;
  }

  print(add(1, 14));

  var now = DateTime.now();
  print(now);

  var stamp = DateTime.fromMillisecondsSinceEpoch(1698709869123);
  print(stamp);

  // int add(int n, int m) {
  //   return n + m;
  // }

  // print(add(1, 14));

  // var now = DateTime.now();
  // print(now);

  // var stamp = DateTime.fromMillisecondsSinceEpoch(1698709869123);
  // print(stamp);

  // int minMin = 25;
  // int maxMin = 120;
  // print(((maxMin + 5) - minMin) / 5);
  // double len = (maxMin + 5 - minMin) / 5;
  // List<int> minList = List.generate(len.toInt(), (index) {
  //   return minMin + 5 * index;
  // });
  // print(minList);
}
