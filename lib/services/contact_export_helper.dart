import 'package:contacts_service/contacts_service.dart';

class ContactExportHelper {
  String getContactName(Contact contact) =>
      '${contact.givenName ?? ''} ${contact.familyName ?? ''}';

  String getPhonesList(List<Item>? phoneList) {
    if (phoneList == null) {
      return '';
    } else {
      String phonesList = '';
      for (var phone in phoneList) {
        phonesList = phonesList + '${phone.value}, \n';
      }
      return phonesList;
    }
  }

  String getEmailList(List<Item>? emailList) {
    if (emailList == null) {
      return '';
    } else {
      String emailsList = '';
      for (var email in emailList) {
        emailsList = emailsList + '${email.value}, \n';
      }
      return emailsList;
    }
  }

  String getAddressList(List<PostalAddress>? addressList) {
    if (addressList == null) {
      return '';
    } else {
      String addresses = '';
      int i = 1;
      for (var address in addressList) {
        addresses = addresses + 'Address $i : ${address.toString()} \n';
      }
      return addresses;
    }
  }
}
