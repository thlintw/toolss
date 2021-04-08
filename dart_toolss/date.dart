#!/usr/bin/env dart

void getNow() {
  print(DateTime.now());
}

void getNowStamp() {
  print(DateTime.now().toUtc().millisecondsSinceEpoch);
}

void parseDate(String dateString) {
  DateTime dt = DateTime.parse(dateString);
  print(dt);
  print(dt.toUtc().millisecondsSinceEpoch);
}
