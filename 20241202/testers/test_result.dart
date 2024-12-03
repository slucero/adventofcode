class TestResult {
  bool passed;

  String notes = '';

  List<int>? invalidIndices;

  TestResult(this.passed, [this.notes = '', this.invalidIndices]);

  factory TestResult.pass([String notes = '']) {
    return TestResult(true, notes);
  }

  factory TestResult.fail(String notes, List<int> invalidIndices) {
    return TestResult(false, notes, invalidIndices);
  }
}
