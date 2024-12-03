import '../report_line.dart';
import 'level_tester.dart';
import 'test_result.dart';

class NonZeroTester implements LevelTester {
  final String failureMessage =
      'UNSAFE due to unchanging levels between the following numbers: ';

  final ReportLine report;

  NonZeroTester(this.report);

  @override
  TestResult testReport() {
    List<int> deltas = report.getDeltas();

    // Test each entry and record the index and
    // value where it failed.
    List<TestResult> failures = [];
    int index = 0;
    deltas.forEach((value) {
      if (value == 0) {
        failures.add(TestResult.fail(
            failureMessage + describeIndexFailure(index), [index]));
      }
      index++;
    });

    if (failures.isEmpty) {
      return TestResult.pass();
    } else {
      return handleFailures(failures);
    }
  }

  TestResult handleFailures(List<TestResult> failures) {
    // Aggregate the failures into a single message.
    Iterable<String> values = failures.map((TestResult failure) =>
        describeIndexFailure(failure.invalidIndices![0]));
    String message = failureMessage + values.join(', ');

    // Aggregate the failed indices into a single list.
    List<List<int>> indices =
        failures.map((failure) => failure.invalidIndices ?? []).toList();
    List<int> invalidIndices =
        indices.reduce((List<int> value, List<int> element) {
      value.addAll(element);
      return value;
    });

    return TestResult.fail(message, invalidIndices);
  }

  String describeIndexFailure(int index) {
    List<int> levels = report.getLevels();
    int value1 = levels[index];
    int value2 = levels[index + 1];

    return '$value1 and $value2';
  }
}
