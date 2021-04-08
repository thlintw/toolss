#!/usr/bin/env dart

import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';

import 'dart_toolss/date.dart';

// const lineNumber = 'line-number';

ArgResults argResults;

void main(List<String> arguments) {
  exitCode = 0; // presume success
  final parser = ArgParser()..addFlag('date', abbr: 'd');

  argResults = parser.parse(arguments);
  final paths = argResults.rest;

  if (argResults['date']) {
    final date = argResults.rest;
    getNow();
    getNowStamp();
    if (date.isNotEmpty) {
      date.forEach((d) {
        parseDate(d);
      });
    }
  }
}
