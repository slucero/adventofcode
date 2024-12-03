import 'dart:io';

class ReportFile {
  final String _path;

  ReportFile(this._path);

  List<String> getReports() {
    return File(_path).readAsLinesSync();
  }
}
