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
}
