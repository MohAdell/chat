import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Contacts/UI/contacts_bar.dart';
import '../HomeMasseges/UI/Main___HomeScreenChat.dart';
import '../Status/UI/Status_ui.dart';

class HomeUi extends StatefulWidget {
  const HomeUi({super.key});

  @override
  State<HomeUi> createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {
  int _selectedIndex = 0; //New
  String email = '', pass = '';
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    // ContactsUi();
    super.initState();
    loadData();
  }
  loadData()async{
    SharedPreferences sp = await SharedPreferences.getInstance();
    email = sp.getString('email') ?? '';
    pass = sp.getString('pass') ?? '';
    setState(() {

    });}

  static final List<Widget> _pages = <Widget>[
    const HomeScreenChat(),
    const StatusUi(),
    const StatusUi(),
    // CallsUi(),
    const ContactsNavigationBarUi(),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        body: _pages.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          selectedFontSize: 15,
          currentIndex: _selectedIndex, //New
          onTap: _onItemTapped, //New
          fixedColor: const Color(0xff3D4A7A),
          selectedIconTheme: const IconThemeData(color: Color(0xff3D4A7A)),
          useLegacyColorScheme: false,
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/chat-bubble.png',
                height: 30,
                width: 30,
              ),
              label: 'Messages',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/status2.png',
                height: 30,
                width: 30,
              ),
              label: 'Status',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/telephone.png',
                height: 30,
                width: 30,
              ),
              label: 'Calls',
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/icons/contact-book.png',
                height: 30,
                width: 30,
              ),
              label: 'Contacts',
            ),
          ],
        ),
      ),
    );
  }
}
