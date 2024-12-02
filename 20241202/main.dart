import 'dart:io';

void main(List<String> arguments) {
  assert(arguments.length == 1);
  final reports = ReportFile(arguments[0]).getReports();

  var numSafe = 0;
  var total = 0;
  reports.forEach((report) {
    total++;
    ReportLine tester = ReportLine(report);

    if (tester.testReport()) {
      print('SAFE: $report');
      numSafe++;
    } else {
      print('UNSAFE: $report');
    }
  });

  print('Of $total reports, $numSafe were found to be safe.');
}

class ReportLine {
  final String _report;

  ReportLine(String this._report);

  bool testReport() {
    var levels = getLevels();

    // Build a list of deltas between each level for later evaluation.
    List<int> deltas = getDeltas(levels);

    // Test that all changes are non-zero.
    bool isNonZero = deltas.every((level) => level != 0);

    if (!isNonZero) {
      print('Unsafe because sequential levels with no change are not allowed.');
      return false;
    }

    // Test that all changes are either all increasing
    // or all decreasing.
    bool isIncreasing = deltas.every((delta) => delta > 0);
    bool isDecreasing = deltas.every((delta) => delta < 0);
    bool isDirectional = isIncreasing || isDecreasing;

    if (!isDirectional) {
      print('Unsafe because all levels must either increase or decrease.');
      return false;
    }

    // Test that all changes are within gradual range.
    bool isGradual = deltas.every((delta) {
      int absolute = delta.abs();

      return absolute >= 1 && absolute <= 3;
    });

    if (!isGradual) {
      print('Unsafe because all changes between levels must be gradual.');
      // print(deltas);
      return false;
    }

    return isNonZero && isDirectional && isGradual;
  }

  List<int> getDeltas(List<int> levels) {
    List<int> deltas = [];
    int? prev = null;
    levels.forEach((current) {
      // Save the first level for comparison and move on.
      if (prev == null) {
        prev = current;
        return;
      }

      // Compare the current level against the previous level and
      // store the difference for later evaluation.
      deltas.add(compareLevels(prev!, current));

      // Capture the current value for the next comparison.
      prev = current;
    });
    return deltas;
  }

  List<int> getLevels() {
    var levels = _report.split(' ');
    assert(levels.length == 5);

    return levels.map((String level) => int.parse(level)).toList();
  }

  int compareLevels(int a, int b) {
    return b - a;
  }
}

class ReportFile {
  final String _path;

  ReportFile(this._path);

  List<String> getReports() {
    return File(_path).readAsLinesSync();
  }
}
