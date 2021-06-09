import 'dart:io';

import 'dart:typed_data';

final String contactsTable = 'contacts_table';

class ContactFields {
  static String contactId = 'id';
  static String contactFirstName = 'firstname';
  static String contactLastName = 'lastname';
  static String contactPhone = 'phone';
}

class Contact {
  final int id;
  final String firstName;
  final String lastName;
  final String phone;

  Contact({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
  });

  Contact copyWith(
      {int id,
      String firstName,
      String lastName,
      String phone}) {
    return Contact(
        id: id ?? this.id,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        phone: phone ?? this.phone,);
  }

  Map<String, Object> toMap() {
    return {
      ContactFields.contactId: id,
      ContactFields.contactFirstName: firstName,
      ContactFields.contactLastName: lastName,
      ContactFields.contactPhone: phone,
    };
  }

  factory Contact.fromMap(Map<String, Object> map) {
    return Contact(
        id: map[ContactFields.contactId] as int,
        firstName: map[ContactFields.contactFirstName] as String,
        lastName: map[ContactFields.contactLastName] as String,
        phone: map[ContactFields.contactPhone] as String);
  }
}
