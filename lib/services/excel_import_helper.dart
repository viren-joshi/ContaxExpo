import 'package:excel/excel.dart' show Excel;

class ExcelImportHelper {
  Excel excel;
  String selectedSheet;
  Map<String, int> relativeMap;
  ExcelImportHelper({required this.excel,required this.selectedSheet,required this.relativeMap});
}
