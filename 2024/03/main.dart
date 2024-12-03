import 'dart:io';

const DEBUG = true;

void main(List<String> arguments) {
  String inputFile = '';
  if (arguments.length == 1) {
    inputFile = arguments[0];
  } else {
    inputFile = 'example.txt';
  }

  // Read the file.
  final String input = File(inputFile).readAsStringSync();
  print(input);

  RegExp pattern = RegExp(r'mul\((\d{1,3}),(\d{1,3})\)');

  int sum = 0;
  int numOperations = 0;

  var matches = pattern.allMatches(input);
  if (DEBUG) {
    print('Identified ${matches.length} operations.');
  }

  for (final match in pattern.allMatches(input)) {
    assert(match.groupCount == 2);
    int val1 = int.parse(match.group(1)!);
    int val2 = int.parse(match.group(2)!);
    int product = val1 * val2;

    if (DEBUG) {
      print(
          'Multiplying operation ${match.group(0)}: $val1 * $val2 = $product');
    }

    numOperations++;
    sum += product;
  }

  print('The sum of $numOperations operations was $sum.');
}
