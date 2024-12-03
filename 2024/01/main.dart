import 'dart:io';

void main(List<String> arguments) {
  String inputFile;

  if (arguments.length == 1) {
    inputFile = arguments[0];
  } else {
    inputFile = 'example.txt';
  }

  // Open the file.
  List<String> lines = File(inputFile).readAsLinesSync();

  // Store each list separately.
  List<int> left = [];
  List<int> right = [];
  for (final line in lines) {
    String leftVal, rightVal;
    [leftVal, rightVal] = line.split('   ');
    left.add(int.parse(leftVal));
    right.add(int.parse(rightVal));
  }

  // Sort each list.
  left.sort();
  right.sort();

  assert(left.length == right.length);

  // Iterate through lines summing distance.
  int totalDistance = 0;
  for (int i = 0; i < lines.length; i++) {
    // Compare and calculate distance.
    int distance = (left[i] - right[i]).abs();

    // Sum total distance.
    totalDistance += distance;
    print("${left[i]} ${right[i]}: $distance");
  }

  // Output total distance sum.
  print('Total distance: $totalDistance');
}
