import 'dart:io';
import 'package:blurry_modal_progress_hud/blurry_modal_progress_hud.dart';
import 'package:contacts_to_excel/services/import_helper.dart';
import 'package:contacts_to_excel/services/excel_import_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:contacts_to_excel/custom_widgets/drop_down.dart';

class ImportFromExcel extends StatefulWidget {
  final PlatformFile file;

  const ImportFromExcel({Key? key, required this.file}) : super(key: key);

  @override
  _ImportFromExcelState createState() => _ImportFromExcelState();
}

class _ImportFromExcelState extends State<ImportFromExcel> {
  Map<String, List<Data>> columnNames = {};
  List<String> sheetNames = [];
  String selectedSheet = 'SELECT SHEET',
      selectedNameColumn = 'SELECT',
      selectedPhone1 = 'SELECT',
      selectedPhone2 = 'SELECT',
      selectedAddress = 'SELECT',
      selectedEmail = 'SELECT';
  bool isSheetSelected = false,
      isNameSelected = false,
      isPhone1Selected = false,
      isPhone2Selected = false,
      isAddressSelected = false,
      isEmailSelected = false;
  bool isSpinning = false;
  late final Excel excel;

  Map<String, int> getMap() {
    Map<String, int> relativeMap = {};
    relativeMap.addAll({'name': int.parse(selectedNameColumn)});
    if (isPhone1Selected) {
      relativeMap.addAll({'phone1': int.parse(selectedPhone1)});
    }
    if (isPhone2Selected) {
      relativeMap.addAll({'phone2': int.parse(selectedPhone2)});
    }
    if (isAddressSelected) {
      relativeMap.addAll({'address': int.parse(selectedAddress)});
    }
    if (isEmailSelected) {
      relativeMap.addAll({'email': int.parse(selectedEmail)});
    }
    return relativeMap;
  }

  List<DropdownMenuItem<String>> getColumnList() {
    List<DropdownMenuItem<String>> columnNameList = [];
    columnNameList.add(
      const DropdownMenuItem<String>(
        child: Text('SELECT'),
        value: 'SELECT',
      ),
    );
    if (isSheetSelected) {
      try {
        var row = excel.tables[selectedSheet]!.rows[0];
        for (Data? data in row) {
          // print(data!.value);
          columnNameList.add(
            DropdownMenuItem(
              child: Text(data!.value.toString()),
              value: data.colIndex.toString(),
            ),
          );
        }
      } on Exception catch (e) {
        print(e);
      }
    }
    return columnNameList;
  }

  List<DropdownMenuItem<String>> getSheetList() {
    List<DropdownMenuItem<String>> sheetNameList = [];
    sheetNameList.add(
      const DropdownMenuItem<String>(
        child: Text('SELECT SHEET'),
        value: 'SELECT SHEET',
      ),
    );
    for (var table in excel.tables.keys) {
      sheetNameList.add(
        DropdownMenuItem<String>(
          child: Text(table),
          value: table,
        ),
      );
    }
    return sheetNameList;
  }

  void getExcelFileInfo(BuildContext context) async {
    try {
      var bytes = File(widget.file.path!).readAsBytesSync();
      excel = Excel.decodeBytes(bytes);
      for (var table in excel.tables.keys) {
        sheetNames.add(table);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'An Error Occurred',
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getExcelFileInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: BlurryModalProgressHUD(
      inAsyncCall: isSpinning,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Import Contacts from Excel'),
        ),
        body: ListView(children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'File Name : ${widget.file.name} \n \nFile Path : ${widget.file.path}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              CustomDropDown(
                label: 'Select Sheet : ',
                value: selectedSheet,
                itemsList: getSheetList(),
                onChangedCallback: (String? val) {
                  if (val != null) {
                    setState(() {
                      if (val != 'SELECT SHEET') {
                        isSheetSelected = true;
                      } else {
                        isSheetSelected = false;
                      }
                      selectedSheet = val;
                    });
                  } else {
                    setState(() {
                      selectedSheet = 'SELECT SHEET';
                    });
                  }
                },
              ),
              isSheetSelected
                  ? const Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Text(
                        'Select Respective Values : ',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.w500),
                      ),
                    )
                  : const SizedBox.shrink(),
              isSheetSelected
                  ? CustomDropDown(
                      label: 'Name * : ',
                      value: selectedNameColumn,
                      itemsList: getColumnList(),
                      onChangedCallback: (val) {
                        if (val != null) {
                          setState(() {
                            selectedNameColumn = val;
                            if (val != 'SELECT') {
                              isNameSelected = true;
                            } else {
                              isNameSelected = false;
                            }
                          });
                        } else {
                          setState(() {
                            selectedNameColumn = 'SELECT';
                          });
                        }
                      },
                    )
                  : const SizedBox.shrink(),
              isSheetSelected
                  ? CustomDropDown(
                      label: 'Phone 1 : ',
                      value: selectedPhone1,
                      itemsList: getColumnList(),
                      onChangedCallback: (String? val) {
                        if (val != null) {
                          setState(() {
                            selectedPhone1 = val;
                            if (val != 'SELECT') {
                              isPhone1Selected = true;
                            } else {
                              isPhone1Selected = false;
                            }
                          });
                        } else {
                          setState(() {
                            selectedPhone1 = 'SELECT';
                          });
                        }
                      },
                    )
                  : const SizedBox.shrink(),
              isSheetSelected
                  ? CustomDropDown(
                      label: 'Phone 2 :',
                      value: selectedPhone2,
                      itemsList: getColumnList(),
                      onChangedCallback: (String? val) {
                        if (val != null) {
                          setState(() {
                            selectedPhone2 = val;
                            if (val != 'SELECT') {
                              isPhone2Selected = true;
                            } else {
                              isPhone2Selected = false;
                            }
                          });
                        } else {
                          setState(() {
                            selectedPhone2 = 'SELECT';
                          });
                        }
                      },
                    )
                  : const SizedBox.shrink(),
              isSheetSelected
                  ? CustomDropDown(
                      label: 'Address : ',
                      value: selectedAddress,
                      itemsList: getColumnList(),
                      onChangedCallback: (String? val) {
                        if (val != null) {
                          setState(() {
                            selectedAddress = val;
                            if (val != 'SELECT') {
                              isAddressSelected = true;
                            } else {
                              isAddressSelected = false;
                            }
                          });
                        } else {
                          setState(() {
                            selectedAddress = 'SELECT';
                          });
                        }
                      })
                  : const SizedBox.shrink(),
              if (isSheetSelected)
                CustomDropDown(
                    label: 'Email : ',
                    value: selectedEmail,
                    itemsList: getColumnList(),
                    onChangedCallback: (String? val) {
                      if (val != null) {
                        selectedEmail = val;
                        if (val != "SELECT") {
                          isEmailSelected = true;
                        } else {
                          isEmailSelected = false;
                        }
                      } else {
                        selectedEmail = 'SELECT';
                      }
                    }),
              // : const SizedBox.shrink(),
              if (isSheetSelected)
                OutlinedButton(
                  onPressed: () {
                    if (!isNameSelected) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'ERROR, NAME FIELD IS REQUIRED',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    } else {
                      setState(() {
                        isSpinning = true;
                      });
                      Map<String, int> relativeMap = getMap();
                      ExcelImportHelper excelHelper = ExcelImportHelper(
                          excel: excel,
                          selectedSheet: selectedSheet,
                          relativeMap: relativeMap);
                      ImportHelper.createNewContacts(context, excelHelper);
                      setState(() {
                        isSpinning = false;
                      });
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Contacts Imported Successfully !'),),);
                    }
                  },
                  child: const Text('Import Contacts'),
                ),
            ],
          ),
        ]),
      ),
    ));
  }
}
