import 'app_contact.class.dart';
import 'package:flutter/material.dart';

import 'contact_avatar.dart';

class ContactsList extends StatelessWidget {
  final List<AppContact> contacts;

  ContactsList({Key key, this.contacts}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          AppContact contact = contacts[index];

          return Column(
            children: [
              ListTile(
                  title: Text(contact.info.displayName),
                  subtitle: Text(
                      contact.info.phones.length > 0 ? contact.info.phones.elementAt(0).value : ''
                  ),
                  leading: ContactAvatar(contact, 50)
              ),
              Container(
                height: 1,
                color: Colors.black26,
              )
            ],
          );
        },
      ),
    );
  }
}