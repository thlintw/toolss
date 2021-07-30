#!/usr/bin/env dart

import 'dart:convert';
import 'dart:io';
import 'package:args/args.dart';

import 'dart_toolss/date.dart';
import 'dart_toolss/funcs.dart';
import 'dart_toolss/proc_arb.dart';
import 'dart_toolss/crypto.dart';

void main(List<String> arguments) async {
  exitCode = 0;

  final parser = ArgParser()
    ..addCommand('help')
    ..addCommand('date')
    ..addFlag('compare', abbr: 'c')
    ..addOption('timezone', abbr: 'z')
    ..addCommand('arb')
    ..addFlag('fill_source')
    ..addFlag('generate', abbr: 'g')
    ..addFlag('convert')
    ..addFlag('template', abbr: 't')
    ..addFlag('name_only')
    ..addCommand('crypto')
    ..addFlag('ada');

  ArgResults? argResults;

  print('\n * TOOLSS OUTPUT * \n');

  try {
    argResults = parser.parse(arguments);
  } catch (e) {    
    errorExit('flag or option error');
  }

  try {
    argResults!;
    final rest = argResults.command?.rest;

    switch (argResults.command?.name) {
      case 'date':
        dateMain(argResults, rest);
        break;
      case 'arb':
        await arbMain(argResults, rest);
        break;
      case 'help':
        help();
        break;
      case 'crypto':
        await cryptoMain(argResults, rest);
        break;
      default:
        printPrompt('no command input or not valid command.');
        break;
    }
  } catch (e) {
    print(e);
    errorExit('toolss error');
  }

  successExit();
}
