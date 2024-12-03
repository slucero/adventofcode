import 'nonzero_tester.dart';
import 'test_result.dart';

class NonzeroTesterWithDampening extends NonZeroTester {
  NonzeroTesterWithDampening(super.report);

  @override
  TestResult handleFailures(List<TestResult> failures) {
    if (failures.length == 1) {
      return TestResult(true, '', failures[0].invalidIndices);
    }

    return super.handleFailures(failures);
  }
}
