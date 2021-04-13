
import 'package:args/args.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:collection';

import 'funcs.dart';

const String tab = '    ';

Future<void> arbMain(ArgResults argResults, List<String> rest) async {
  String? inputPath, locale, outputPath;
  inputPath = rest.length >= 1 ? rest[0] : null;
  locale = rest.length >= 2 ? rest[1] : null;
  outputPath = rest.length >= 3 ? rest[2] : null;

  if (argResults['generate']) {
    await generateEmptyArb(argResults, inputPath: inputPath, locale: locale, outputPath: outputPath);
    
  } else {
    printPrompt('no option specified');
    printPrompt('allowed options for proc_arb: generate, convert');
  }
}

Future<void> generateEmptyArb(
  ArgResults argResults, 
  {
    String? inputPath,
    String? locale,
    String? outputPath
  }) async {

  if (inputPath == null) {
    printPrompt('no input path');
    
  } else if (locale == null) {
    printPrompt('no locale');

  } else {
    printPrompt('processing input file ...');

    final outputPathFinal = outputPath ?? '${Directory.current.path}/intl_$locale.arb';
    printPrompt('output path: $outputPathFinal');

    final input = File(inputPath);
    File output = File(outputPathFinal);

    if (output.existsSync()) {
      await output.writeAsString('');
    } else {
      await output.create(recursive: true);
    }

    LinkedHashMap outputMap = LinkedHashMap();

    outputMap['@@locale'] = locale;

    Stream<String> lines = input.openRead()
      .transform(utf8.decoder)       // Decode bytes to UTF-8.
      .transform(LineSplitter());    // Convert stream to individual lines.

    try {
      await for (var line in lines) {
        String className = '${line[0].toLowerCase()}${line.substring(1)}';
        outputMap[className] = className;
        if (argResults['template']) {
          outputMap['@$className'] = {
            'description': className,
          };
        }
      }
    } catch (e) {
      printPrompt('Error: $e');
    }

    try {
      JsonEncoder encoder = JsonEncoder.withIndent(tab);
      var sink = output.openWrite();
      sink.write(encoder.convert(outputMap));
      await sink.close();
      printPrompt('File is now closed.');

    } catch(e) {
      printPrompt('Error: $e');
    }

  }
}