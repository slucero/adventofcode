import 'testers/level_tester.dart';
import 'testers/nonzero_tester.dart';
import 'testers/nonzero_tester_with_dampening.dart';

class ReportLine {
  final String _report;
  List<int>? _levels;
  List<int>? _deltas;

  ReportLine(String this._report) {
    getLevels();
    getDeltas();
  }

  bool testReport() {
    List<LevelTester> testers = [
      NonzeroTesterWithDampening(this),
    ];

    testers.forEach((tester) {
      final result = tester.testReport();
      if (!result.passed) {
        print(result.notes);
      }
    });

    // Build a list of deltas between each level for later evaluation.
    List<int> deltas = getDeltas();

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

  List<int> getDeltas() {
    if (_deltas == null) {
      List<int> deltas = [];
      int? prev = null;
      assert(_levels != null);
      _levels!.forEach((current) {
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

      _deltas = deltas;
    }

    assert(_deltas != null);
    return _deltas!;
  }

  List<int> getLevels() {
    if (_levels == null) {
      var levels = _report.split(' ');
      assert(levels.length == 5);

      _levels = levels.map((String level) => int.parse(level)).toList();
    }

    assert(_levels != null);
    return _levels!;
  }

  int compareLevels(int a, int b) {
    return b - a;
  }
}
