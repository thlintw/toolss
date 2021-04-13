#!/usr/bin/env dart

import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';

import 'dart_toolss/date.dart';
import 'dart_toolss/funcs.dart';

// const lineNumber = 'line-number';

ArgResults argResults;

void main(List<String> arguments) {
  exitCode = 0; // presume success
  final parser = ArgParser()..addFlag('date', abbr: 'd');

  argResults = parser.parse(arguments);

  print('\n * TOOLSS OUTPUT * \n');

  if (argResults['date']) {
    final dates = argResults.rest;
    dateOutput(dates);
    exitCode = 1;
  } else {
    printPrompt('no command input.');
  }

  print('\n * TOOLSS END * \n');
}
