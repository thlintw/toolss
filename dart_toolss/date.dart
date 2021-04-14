#!/usr/bin/env dart

import 'dart:io';

import 'package:args/args.dart';

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

  printPrompt('* datetime now');
  print(datetimeToString(now));
  print(now.toUtc().millisecondsSinceEpoch);
}

void parseDate(String dateString) {
  try {
    DateTime dt = DateTime.parse(dateString);
    printPrompt('* dateString: $dateString');
    print(datetimeToString(dt));
    print(dt.toUtc().millisecondsSinceEpoch);
  } catch (e) {
    errorExit('date format error');
  }
}

void compareTimestamp(String timestamp) {
  try {
    int st = int.parse(timestamp);
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(st);
    int nowStamp = DateTime.now().millisecondsSinceEpoch;    
    printPrompt('* timestamp: $timestamp');
    printPrompt('* timestamp in datetime: ${dt.toString()}');
    if (st > nowStamp) {
      printPrompt('$timestamp is greater than now $nowStamp');
    } else {
      printPrompt('$timestamp is smaller than now $nowStamp');
    }
  } catch (_) {
    errorExit('timestamp format error');
  }
}

void dateMain(ArgResults argResults, List<String>? dates) {
  if (argResults['compare'] && dates != null) {
    dates.forEach((s) {
      compareTimestamp(s);
    });

  } else if (dates != null && dates.isNotEmpty){
    printNow();
    dates.forEach((st) {
      parseDate(st);
    });
  } else {
    printNow();
  }
}