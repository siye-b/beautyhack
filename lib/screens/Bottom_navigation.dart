import 'package:flutter/material.dart';
import 'package:beauty_hack/screens/reset_password.dart';

var color_index = 0;
class BottomNavigation extends StatefulWidget {
  const BottomNavigation({Key? key}) : super(key: key);

  @override
  _BottomNavigationState createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {


  var _current_index = 0;
  
  @override
  Widget build(BuildContext context) {
      return BottomNavigationBar(
        currentIndex: _current_index,
        selectedItemColor: const Color.fromARGB(255, 31, 103, 170),
        items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile'
            ),
        ],
        onTap: (index) {
          setState(() {
            _current_index = index;
          });
        },
        );
        
  }
}