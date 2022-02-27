import 'package:contacts_to_excel/services/contact_export_helper.dart';
import 'package:pdf/pdf.dart' show PdfColors, PdfPageFormat;
import 'package:pdf/widgets.dart'
    show
        Widget,
        Context,
        Container,
        Alignment,
        EdgeInsets,
        Text,
        TextStyle,
        Padding,
        TableRow;
import 'package:contacts_service/contacts_service.dart' show Contact;

class PdfHelper {
  ContactExportHelper helper = ContactExportHelper();

  Widget getPdfHeader(Context context) {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
      child: Text(
        'Exported Contacts PDF',
        style: const TextStyle(color: PdfColors.grey),
      ),
    );
  }

  Widget getPdfFooter(Context context) {
    return Container(
      alignment: Alignment.centerRight,
      margin: const EdgeInsets.all(3.0 * PdfPageFormat.mm),
      child: Text(
        '${context.pageNumber} / ${context.pagesCount}',
        style: const TextStyle(color: PdfColors.grey),
      ),
    );
  }

  List<Widget> _getPDFContact(Contact contact) {
    List<Widget> pdfContact = [];
    pdfContact.add(
      Padding(
        padding: const EdgeInsets.all(3.0 * PdfPageFormat.mm),
        child: Text(
          helper.getContactName(contact),
        ),
      ),
    );
    pdfContact.add(
      Padding(
        padding: const EdgeInsets.all(3.0 * PdfPageFormat.mm),
        child: Text(
          helper.getPhonesList(contact.phones),
        ),
      ),
    );
    pdfContact.add(
      Padding(
        padding: const EdgeInsets.all(3.0 * PdfPageFormat.mm),
        child: Text(
          helper.getAddressList(contact.postalAddresses),
        ),
      ),
    );
    pdfContact.add(
      Padding(
        padding: const EdgeInsets.all(3.0 * PdfPageFormat.mm),
        child: Text(
          helper.getEmailList(contact.emails),
        ),
      ),
    );
    return pdfContact;
  }

  List<TableRow> getPDFContactsList(List<Contact> contactsList) {
    List<TableRow> pdfContactsList = [];
    pdfContactsList.add(
      TableRow(
        children: [
          Padding(
            padding: const EdgeInsets.all(3.0 * PdfPageFormat.mm),
            child: Text('Name'),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0 * PdfPageFormat.mm),
            child: Text('Phone No.'),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0 * PdfPageFormat.mm),
            child: Text('Address'),
          ),
          Padding(
            padding: const EdgeInsets.all(3.0 * PdfPageFormat.mm),
            child: Text('Email'),
          ),
        ],
      ),
    );
    for (Contact contact in contactsList) {
      pdfContactsList.add(
        TableRow(
          children: _getPDFContact(contact),
        ),
      );
    }
    return pdfContactsList;
  }
}
