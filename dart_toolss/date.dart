#!/usr/bin/env dart

import 'funcs.dart';

String datetimeToString(DateTime dt) {
  return 
    '${dt.year.toString()}-'
    '${dt.month.toString().padLeft(2,'0')}-'
    '${dt.day.toString().padLeft(2,'0')} '
    '${dt.hour.toString().padLeft(2,'0')}:'
    '${dt.minute.toString().padLeft(2,'0')}:'
    '${dt.second.toString().padLeft(2,'0')}'    
    ;
}

void printNow() {
  DateTime now = DateTime.now();

  print('* datetime now');
  print(datetimeToString(now));
  print(now.toUtc().millisecondsSinceEpoch);
}

void parseDate(String dateString) {
  DateTime dt = DateTime.parse(dateString);

  print('* dateString: $dateString');
  print(datetimeToString(dt));
  print(dt.toUtc().millisecondsSinceEpoch);
}

void dateOutput(List<String> dates) {
  printNow();
  if (dates.isNotEmpty) {
    dates.forEach((d) {
      parseDate(d);
    });
  }
}