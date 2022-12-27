import 'dart:developer';

import 'package:final_project_new/pages/debug_home.dart';
import 'package:final_project_new/pages/user_profile.dart';
import 'package:final_project_new/pages/user_timeline.dart';
import 'package:final_project_new/widgets/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../crud_operations/create_pins.dart';
import '../pages/home.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  final List _pages = [
    const DebugHome(),
    const CreatePins(),
    const UserTimeline(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: primaryBlack,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 20,
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            backgroundColor: Colors.grey,
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            backgroundColor: Colors.grey,
            label: 'Create Pins',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            backgroundColor: Colors.grey,
            label: 'Timeline',
          ),
        ],
      ),
    );
  }
}
