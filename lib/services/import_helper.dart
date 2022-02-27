import 'package:contacts_to_excel/services/excel_import_helper.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart'
    show Contact, ContactsService, Item, PostalAddress;

class ImportHelper {
  static late PermissionStatus permission;

  static Future createNewContacts(
      BuildContext context, ExcelImportHelper excelHelper) async {
    try {
      await Permission.contacts.request();
      permission = await Permission.contacts.status;
      if (permission == PermissionStatus.granted) {
        for (var row in excelHelper
            .excel.tables[excelHelper.selectedSheet]!.rows
            .getRange(
                1,
                excelHelper
                    .excel.tables[excelHelper.selectedSheet]!.rows.length)) {
          if (row ==
              excelHelper.excel.tables[excelHelper.selectedSheet]!.rows.first) {
            continue;
          }
          Contact newContact = Contact();
          newContact.givenName =
              row[excelHelper.relativeMap['name'] ?? 0]?.value.toString();
          List<Item> phonesList = [];
          if (excelHelper.relativeMap.containsKey('phone1')) {
            phonesList.add(
              Item(
                  label: 'Phone',
                  value: row[excelHelper.relativeMap['phone1'] ?? 0]
                      ?.value
                      .toString()),
            );
          }
          if (excelHelper.relativeMap.containsKey('phone2')) {
            phonesList.add(
              Item(
                  label: 'Phone',
                  value: row[excelHelper.relativeMap['phone2'] ?? 0]
                      ?.value
                      .toString()),
            );
          }
          newContact.phones = phonesList;
          if (excelHelper.relativeMap.containsKey('address')) {
            newContact.postalAddresses = [
              PostalAddress(
                region: row[excelHelper.relativeMap['address'] ?? 0]
                    ?.value
                    .toString(),
              ),
            ];
          }
          if (excelHelper.relativeMap.containsKey('email')) {
            newContact.emails = [
              Item(
                label: 'Email',
                value: row[excelHelper.relativeMap['email'] ?? 0]
                    ?.value
                    .toString(),
              )
            ];
          }
          ContactsService.addContact(newContact);
        }
      } else if (permission == PermissionStatus.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Contact Access Permission not granted :/',
              style: TextStyle(color: Colors.red),
            ),
            action: SnackBarAction(
                label: 'Request Again',
                onPressed: () async {
                  await Permission.contacts.request();
                }),
          ),
        );
      }
    } on Error catch (e) {
      print(e);
    }
  }
}
