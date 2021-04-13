#!/usr/bin/env dart

import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';

import 'dart_toolss/date.dart';
import 'dart_toolss/funcs.dart';
import 'dart_toolss/proc_arb.dart';


void main(List<String> arguments) async {
  exitCode = 0; // presume success
  final parser = ArgParser()
    ..addFlag('date', abbr: 'd')
    ..addFlag('proc_arb')
    ..addFlag('generate')
    ..addFlag('convert')
    ..addFlag('template');

  ArgResults argResults = parser.parse(arguments);

  print('\n * TOOLSS OUTPUT * \n');

  final rest = argResults.rest;

  if (argResults['date']) {  
    dateOutput(rest);

  } else if (argResults['proc_arb']) {
    await arbMain(argResults, rest);

  } else {
    printPrompt('no command input.');
  }

  print('\n * TOOLSS END * \n');
}
