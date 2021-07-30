import 'package:args/args.dart';
import 'package:http/http.dart' as http;


import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:collection';

import 'funcs.dart';

Future<void> cryptoMain(ArgResults argResults, List<String>? rest) async {
  String? sellingCurrency, buyingCurrency;
  if (rest != null) {
    if (argResults['ada']) {
      sellingCurrency = rest.isNotEmpty ? rest[0] : null;
      buyingCurrency = rest.length >= 2 ? rest[1] : null;
    } else {
      // inputPath = rest.isNotEmpty ? rest[0] : null;
      // locale = rest.length >= 2 ? rest[1] : null;
      // outputPath = rest.length >= 3 ? rest[2] : null;
    }
  }

  if (argResults['ada']) {
    // await generateEmptyArb(argResults, inputPath: inputPath, locale: locale, outputPath: outputPath);
    await getBestAdaPrice();

  } else {
    printPrompt('no option specified');
    printPrompt('allowed options for arb: generate, convert');
  }
}

Map<String, String> cryptoIdFromSymbol = {
  'ADA': '2010'
};

Future<void> getBestAdaPrice() async {
  var headers = {
    'X-CMC_PRO_API_KEY': '8ec96f9e-827b-4f8d-815d-24959a431ec4',
  };
  var apiUrl = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/quotes/latest?symbol=USDT';
  final response = await http.get(Uri.parse(apiUrl), headers: headers);
  printPrompt(response.body);
}

// 38773.56769645294
// 1.0005978962156