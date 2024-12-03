import '../report_line.dart';
import 'test_result.dart';

abstract class LevelTester {
  final ReportLine report;

  LevelTester(this.report);

  TestResult testReport();
}
