import 'dart:io';

import 'report_file.dart';
import 'report_line.dart';

void main(List<String> arguments) {
  List<String> reports = [];
  if (arguments.length == 1) {
    reports = ReportFile(arguments[0]).getReports();
  } else if (arguments.length > 1) {
    reports.add(arguments.join(' '));
  } else {
    exit(1);
  }

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
