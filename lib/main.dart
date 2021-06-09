import 'package:agranee/db/model.dart' as model;

import 'db/db.dart';
import 'phonebook/app_contact.class.dart';
import 'phonebook/const_styles.dart';
import 'phonebook/contacts-list.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'phonebook/const_colors.dart';

void main() => runApp(MyApp());

Map<int, Color> color =
{
  50:Color.fromRGBO(136,14,79, .5),
  100:Color.fromRGBO(136,14,79, .2),
  200:Color.fromRGBO(136,14,79, .3),
  300:Color.fromRGBO(136,14,79, .4),
  400:Color.fromRGBO(136,14,79, .5),
  500:Color.fromRGBO(136,14,79, .6),
  600:Color.fromRGBO(136,14,79, .7),
  700:Color.fromRGBO(136,14,79, .8),
  800:Color.fromRGBO(136,14,79, .9),
  900:Color.fromRGBO(136,14,79, 1),
};

MaterialColor _maroonColor = MaterialColor(0xFF014D96, color);

MaterialColor _primaryColor = MaterialColor(0xFF017EC1, color);
MaterialColor _secondaryColor = MaterialColor(0xFF014286, color);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Contacts',
      theme: ThemeData(
        primarySwatch: _primaryColor,
        accentColor: Colors.white,
        secondaryHeaderColor: _secondaryColor,
        backgroundColor: _maroonColor
      ),
      home: MyHomePage(title: 'Phone Book'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({ Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<AppContact> contacts = [];
  List<AppContact> contactsFiltered = [];
  Map<String, Color> contactsColorMap = new Map();
  TextEditingController searchController = new TextEditingController();
  bool contactsLoaded = false;

  @override
  void initState() {
    super.initState();
    getPermissions();
  }
  getPermissions() async {
    if (await Permission.contacts.request().isGranted) {
      getAllContacts();
      searchController.addListener(() {
        filterContacts();
      });
    }
  }

  String flattenPhoneNumber(String phoneStr) {
    return phoneStr.replaceAllMapped(RegExp(r'^(\+)|\D'), (Match m) {
      return m[0] == "+" ? "+" : "";
    });
  }

  getAllContacts() async {
    List colors = [
      Colors.blue,
      Colors.cyan,
    ];
    int colorIndex = 0;
    List<AppContact> _contacts = (await ContactsService.getContacts(query: "" ,orderByGivenName: true, iOSLocalizedLabels: false, androidLocalizedLabels:false)).map((contact) {
      Color baseColor = colors[colorIndex];
      colorIndex++;
      if (colorIndex == colors.length) {
        colorIndex = 0;
      }
      return new AppContact(info: contact, color: baseColor);
    }).toList();
    setState(() {
      contacts = _contacts;
      contactsLoaded = true;
    });
  }

  filterContacts() {
    List<AppContact> _contacts = [];
    _contacts.addAll(contacts);
    if (searchController.text.isNotEmpty) {
      _contacts.retainWhere((contact) {
        String searchTerm = searchController.text.toLowerCase();
        String searchTermFlatten = flattenPhoneNumber(searchTerm);
        String contactName = contact.info.displayName.toLowerCase();
        bool nameMatches = contactName.contains(searchTerm);
        if (nameMatches == true) {
          return true;
        }

        if (searchTermFlatten.isEmpty) {
          return false;
        }

        var phone = contact.info.phones.firstWhere((phn) {
          String phnFlattened = flattenPhoneNumber(phn.value);
          return phnFlattened.contains(searchTermFlatten);
        }, orElse: () => null);

        return phone != null;
      });
    }
    setState(() {
      contactsFiltered = _contacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSearching = searchController.text.isNotEmpty;
    bool listItemsExist = (
        (isSearching == true && contactsFiltered.length > 0) ||
            (isSearching != true && contacts.length > 0)
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: WHITE_COLOUR, size: 25,),
            onPressed: () async{
              try{
                Contact _contact = await ContactsService.openContactForm();

                if(_contact!= null){
                  getAllContacts();

                  final contact = model.Contact(
                    firstName: _contact.givenName,
                    lastName: _contact.familyName,
                    phone: _contact.phones.map((j) => j.value).toString(),
                  );

                  await DatabaseService.instance.insert(contact);
                }
              } catch (e){
                print(e.toString());
              }
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            Container(
              child: TextField(
                controller: searchController,
                decoration: textBoxInputDecoration()
              ),
            ),
            contactsLoaded == true ?
            listItemsExist == true ?
            ContactsList(
              contacts: isSearching == true ? contactsFiltered : contacts,
            ) : Container(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  isSearching ?'No search results to show' : 'No contacts exist',
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                )
            ) :
            Container(
              padding: EdgeInsets.only(top: 40),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          ],
        ),
      ),
    );
  }

  InputDecoration textBoxInputDecoration(){
    return InputDecoration(
      filled: true,
      hintText: "",
      hintStyle: GREY_TEXT,
      errorBorder: GREY_INPUT_BOX,
      enabledBorder: GREY_INPUT_BOX,
      focusedBorder: GREY_INPUT_BOX,
      focusedErrorBorder: GREY_INPUT_BOX,
      fillColor: LIGHT_GREY_COLOUR,
      suffixIcon: IconButton(
        icon: Icon(
          Icons.search,
          color: MEDIUM_GREY_COLOUR,
          size: 25,
        ),
      ),
    );
  }
}
