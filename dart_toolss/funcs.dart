import 'dart:io';

void printPrompt(String prompt) {
  print('TOOLSS: $prompt');
}

void successExit() {
  print('\n * TOOLSS END * \n');
  exit(0);
}

void errorExit(String? error) {
  if (error != null) {
    printPrompt(error);
  }
  printPrompt('exiting...');  
  print('\n * TOOLSS END * \n');
  exit(2);
}

void help() {
  var tab = '    ';
  printPrompt('available commands:\n');
  print('$tab date');
  print('$tab$tab options: compare');
  print('$tab arb');
  print('$tab$tab options: generate, convert');
}