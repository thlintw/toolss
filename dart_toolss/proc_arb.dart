
import 'package:args/args.dart';
import 'package:excel/excel.dart';

import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:collection';

import 'funcs.dart';

const String tab = '    ';

Future<void> arbMain(ArgResults argResults, List<String>? rest) async {
  String? inputPath, locale, outputPath, sourcePath;
  if (rest != null) {
    if (argResults['fill_source']) {
      sourcePath = rest.isNotEmpty ? rest[0] : null;
      inputPath = rest.length >= 2 ? rest[1] : null;
      locale = rest.length >= 3 ? rest[2] : null;
      outputPath = rest.length >= 4 ? rest[3] : null;
    } else {
      inputPath = rest.isNotEmpty ? rest[0] : null;
      locale = rest.length >= 2 ? rest[1] : null;
      outputPath = rest.length >= 3 ? rest[2] : null;
    }
  }

  if (argResults['generate']) {
    await generateEmptyArb(argResults, inputPath: inputPath, locale: locale, outputPath: outputPath);

  } else if (argResults['convert']){
    await convertFromExcel(argResults, inputPath: inputPath, locale: locale, outputPath: outputPath);

  } else if (argResults['fill_source']) {
    await fillArbSourceFromExcel(argResults, sourcePath: sourcePath, inputPath: inputPath, locale: locale, outputPath: outputPath);

  } else {
    printPrompt('no option specified');
    printPrompt('allowed options for arb: generate, convert');
  }
}

Future<void> writeFile(File output, LinkedHashMap outputMap) async {
  try {
    JsonEncoder encoder = JsonEncoder.withIndent(tab);
    var sink = output.openWrite();
    sink.write(encoder.convert(outputMap));
    await sink.close();
    printPrompt('file closed.');

  } catch(e) {
    errorExit('error writing arb file.');
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
    errorExit('no input path');
    
  } else if (locale == null) {
    errorExit('no locale');

  } else {
    printPrompt('processing input file ...');

    final outputPathFinal = outputPath ?? '${Directory.current.path}/intl_$locale.arb';
    printPrompt('output path: $outputPathFinal');

    final input = File(inputPath);

    if (!input.existsSync()) {
      errorExit('input file does not exist');
    }

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
      errorExit('error reading input file');
    }

    await writeFile(output, outputMap);
  }
}

LinkedHashMap loadFromExcel(File input, String locale, ArgResults argResults, {LinkedHashMap? sourceMap}) {
  var bytes = input.readAsBytesSync();
  var excel = Excel.decodeBytes(bytes);

  var sheet = excel['main'];

  if (sheet.maxCols < 1) {
    errorExit('template error: "main" sheet does not exist');
  }

  if (sheet.maxCols > 2) {
    errorExit('template error: too many cols in "main" sheet');
  }

  LinkedHashMap outputMap = LinkedHashMap();

  outputMap['@@locale'] = locale;

  int rc = 1;

  for (var row in sheet.rows) {
    if (rc > 1) {
      if (row.length > 1) {
        String varName = row[0]?.value;
        String className = '${varName[0].toLowerCase()}${varName.substring(1)}';  
        String translation = row[1]?.value;
        if (argResults['name_only']) {
          outputMap[className] = className;          
        } else {
          outputMap[className] = translation;          
        }
        if (argResults['template'] && translation.contains('{')) {
          var placeholders = LinkedHashMap();
          var transplit = translation.split('}');
          transplit.forEach((t) {
            if (t.contains('{')) {
              placeholders[t.split('{')[1]] = {};
            }
          });
          outputMap['@$className'] = {
            'description': className,
            'placeholders': placeholders,
          };
        } else if (sourceMap != null && sourceMap.containsKey('@$className')) {
          outputMap['@$className'] = sourceMap['@$className'];
        } else if (argResults['template']) {
          outputMap['@$className'] = {
            'description': className,
          };
        }
        
      }
    }
    rc += 1;
  }

  return outputMap;  
}

Future<void> convertFromExcel(
  ArgResults argResults, 
  {
    String? inputPath,
    String? locale,
    String? outputPath
  }) async {

  if (inputPath == null) {
    errorExit('no input path');
    
  } else if (locale == null) {
    errorExit('no locale');

  } else {

    printPrompt('processing excel file ...');

    final outputPathFinal = outputPath ?? '${Directory.current.path}/intl_$locale.arb';
    printPrompt('output path: $outputPathFinal');

    final input = File(inputPath);
    File output = File(outputPathFinal);

    if (!input.existsSync()) {
      errorExit('input file does not exist');
    }

    if (output.existsSync()) {
      await output.writeAsString('');
    } else {
      await output.create(recursive: true);
    }
    
    LinkedHashMap outputMap = loadFromExcel(input, locale, argResults);

    await writeFile(output, outputMap);
  }
}


Future<void> fillArbSourceFromExcel(
  ArgResults argResults, 
  {
    String? sourcePath,
    String? inputPath,
    String? locale,
    String? outputPath,
  }) async {

  if (sourcePath == null) {
    errorExit('no source path');
    
  } else if (inputPath == null) {
    errorExit('no input path');

  } else if (locale == null) {
    errorExit('no locale');

  } else {
    printPrompt('loading source file ...');
    final source = File(sourcePath);

    if (!source.existsSync()) {
      errorExit('source file does not exist');
    }    
    var sourceMap;

    Stream<String> read = source.openRead().transform(utf8.decoder);    // Convert stream to individual lines.
    await for(var val in read) {
      sourceMap = json.decode(val);
    }

    printPrompt('processing excel file ...');

    final input = File(inputPath);
    if (!input.existsSync()) {
      errorExit('input file does not exist');
    }

    final outputPathFinal = outputPath ?? '${Directory.current.path}/intl_$locale.arb';
    File output = File(outputPathFinal);
    printPrompt('output path: $outputPathFinal');

    if (output.existsSync()) {
      await output.writeAsString('');
    } else {
      await output.create(recursive: true);
    }

    LinkedHashMap outputMap = loadFromExcel(input, locale, argResults, sourceMap: sourceMap);

    await writeFile(output, outputMap);
  }
}