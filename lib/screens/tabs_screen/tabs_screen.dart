import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ios_fl_n_mondialstyle_3445/screens/my_wardrobe_screen/my_wardrobe_screen.dart';
import 'package:ios_fl_n_mondialstyle_3445/screens/outfits_screen/favourite_outfits_screen.dart';
import 'package:ios_fl_n_mondialstyle_3445/screens/outfits_screen/outfits_screen.dart';
import 'package:ios_fl_n_mondialstyle_3445/screens/quiz_screen/quiz_screen.dart';
import 'package:ios_fl_n_mondialstyle_3445/screens/settings_screen/settings_screen.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    OutfitsScreen(),
    MyWardrobeScreen(),
    FavouritesOutfitsScreen(),
    QuizScreen(),
    SettingsScreen(),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF00DE1E),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFFB18A00),
          unselectedItemColor: const Color(0xFF00590C),
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: FaIcon(FontAwesomeIcons.houseChimneyUser),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: FaIcon(FontAwesomeIcons.doorClosed),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: FaIcon(FontAwesomeIcons.bookmark),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: FaIcon(FontAwesomeIcons.gamepad),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Padding(
                padding: EdgeInsets.only(top: 16.0),
                child: FaIcon(FontAwesomeIcons.gear),
              ),
              label: '',
            ),
          ],
        ),
      ),
    );
  }
}
