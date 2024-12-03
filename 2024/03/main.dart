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

  RegExp pattern =
      RegExp(r"((?<op>mul|do|don't)\(((?<val1>\d{1,3}),(?<val2>\d{1,3}))?\))");
  RegExp mulPattern = RegExp(r'mul\((\d{1,3}),(\d{1,3})\)');

  int sum = 0;
  int numOperations = 0;

  var matches = pattern.allMatches(input);
  if (DEBUG) {
    print('Identified ${matches.length} operations.');
  }

  // Track whether operations should be skipped. Start not skipping.
  bool skip = false;

  for (final match in pattern.allMatches(input)) {
    assert(match.groupCount > 0);
    switch (match.namedGroup('op')) {
      case 'do':
        skip = false;
        break;

      case "don't":
        skip = true;
        break;

      case 'mul':
        if (!skip) {
          int val1 = int.parse(match!.namedGroup('val1')!);
          int val2 = int.parse(match!.namedGroup('val2')!);
          int product = val1 * val2;

          if (DEBUG) {
            print(
                'Multiplying operation ${match.group(1)}: $val1 * $val2 = $product');
          }

          numOperations++;
          sum += product;
        }
        break;

      default:
        print('Unknown operation: ${match.group(1)}');
    }
  }

  print('The sum of $numOperations operations was $sum.');
}
