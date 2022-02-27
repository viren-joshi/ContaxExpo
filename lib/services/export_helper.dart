import 'dart:io' show File;

import 'package:contacts_service/contacts_service.dart';
import 'package:contacts_to_excel/services/contact_export_helper.dart';
import 'package:contacts_to_excel/services/pdf_helper.dart';

//FOR SAVING FILES
import 'package:external_path/external_path.dart' show ExternalPath;

//FOR EXCEL
import 'package:excel/excel.dart' show Excel,CellIndex,Data;

//FOR PDF
import 'package:pdf/pdf.dart' show PdfColors;
import 'package:pdf/widgets.dart'
    show
        Document,
        MultiPage,
        Table,
        TableBorder,
        Font,
        BorderStyle,
        ThemeData,
        TableCellVerticalAlignment;

//FOR DEBUGGING
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart' show rootBundle;

//FOR CSV
import 'package:csv/csv.dart';

class ExportHelper {
  List<Contact> contactsList;
  ContactExportHelper helper = ContactExportHelper();

  ExportHelper({required this.contactsList});

  Future<String> exportContactsToExcel() async {
    Excel excel = Excel.createExcel();
    excel['Sheet1'].insertRow(0);
    Data cellName = excel['Sheet1']
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0));
    cellName.value = 'Name';
    Data cellPhone = excel['Sheet1']
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0));
    cellPhone.value = 'Phones';
    Data cellEmail = excel['Sheet1']
        .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 0));
    cellEmail.value = 'Emails';
    Data cellAddress = excel['Sheet1']
        .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: 0));
    cellAddress.value = 'Addresses';
    int rowIndex = 1;
    for (Contact contact in contactsList) {
      Data cellName = excel['Sheet1']
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex));
      cellName.value = helper.getContactName(contact);
      Data cellPhone = excel['Sheet1']
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex));
      cellPhone.value = helper.getPhonesList(contact.phones);
      Data cellEmail = excel['Sheet1']
          .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex));
      cellEmail.value = helper.getEmailList(contact.emails);
      Data cellAddress = excel['Sheet1']
          .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex));
      cellAddress.value = helper.getAddressList(contact.postalAddresses);
      rowIndex++;
    }
    var bytes = excel.save();
    try {
      String path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      File('$path/Contacts.xlsx')
        ..createSync(recursive: true)
        ..writeAsBytesSync(bytes!);
      return path;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return 'An Error Occurred :(';
    }
  }

  Future<String> exportContactsToPDF() async {
    PdfHelper pdfHelper = PdfHelper();
    try {
      final pdf = Document();
      pdf.addPage(
        MultiPage(
          maxPages: 100,
          theme: ThemeData.withFont(
            base: Font.ttf(await rootBundle.load("fonts/OpenSans-Regular.ttf")),
            bold: Font.ttf(await rootBundle.load("fonts/OpenSans-Regular.ttf")),
            italic:
                Font.ttf(await rootBundle.load("fonts/OpenSans-Regular.ttf")),
            boldItalic:
                Font.ttf(await rootBundle.load("fonts/OpenSans-Regular.ttf")),
          ),
          header: (context) => pdfHelper.getPdfHeader(context),
          footer: (context) => pdfHelper.getPdfFooter(context),
          build: (context) {
            return [
              Table(
                border: TableBorder.all(
                    color: PdfColors.black,
                    width: 1.0,
                    style: BorderStyle.solid),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: pdfHelper.getPDFContactsList(contactsList),
              ),
            ];
          },
        ),
      );

      String path = await ExternalPath.getExternalStoragePublicDirectory(
          ExternalPath.DIRECTORY_DOWNLOADS);
      String filePath = '$path/Contacts.pdf';
      File pdfFile = File(filePath);

      await pdfFile.writeAsBytes(await pdf.save());
      return filePath;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return 'An Error Occurred :(';
    }
  }

  Future<String> exportContactsToCSV() async {
    List<List<dynamic>> rows = [];
    List<dynamic> firstRow = ['Name', 'Phone', 'Address', 'Email'];
    rows.add(firstRow);
    for (Contact contact in contactsList) {
      List<dynamic> cnt = [];
      cnt.add(
        helper.getContactName(contact),
      );
      cnt.add(
        helper.getPhonesList(contact.phones),
      );
      cnt.add(
        helper.getAddressList(contact.postalAddresses),
      );
      cnt.add(
        helper.getEmailList(contact.emails),
      );
      rows.add(cnt);
    }

    try {
      String csv = const ListToCsvConverter().convert(rows);
      String path = await ExternalPath.getExternalStoragePublicDirectory(
        ExternalPath.DIRECTORY_DOWNLOADS,
      );
      String filePath = '$path/Contacts.csv';
      File csvFile = File(filePath);
      csvFile.writeAsString(csv);
      return filePath;
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return 'An Error Occurred :(';
    }
  }
}
