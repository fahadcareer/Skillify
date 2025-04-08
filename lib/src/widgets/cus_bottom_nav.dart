import 'package:Skillify/src/provider/language_provider.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigation extends StatefulWidget {
  final int currentIndex;

  const CustomBottomNavigation({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  _CustomBottomNavigationState createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _navigateToPage(index);
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        context.push('/home');
        break;
      case 1:
        context.push('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<AppLanguage>(context, listen: true);

    return BottomNavigationBar(
      backgroundColor: Colors.white,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey[600],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: _buildDefaultIcon(Icons.home, 0),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: _buildDefaultIcon(Icons.person, 1),
          label: '',
        ),
      ],
    );
  }

  Widget _buildDefaultIcon(IconData iconData, int index) {
    return Icon(
      iconData,
      size: 24,
      color: _selectedIndex == index ? Colors.black : Colors.grey[600],
    );
  }
}
