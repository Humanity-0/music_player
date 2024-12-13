import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import 'library_screen.dart';
import 'playlist_screen.dart';
import 'player_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    LibraryScreen(),
    PlaylistScreen(),
    PlayerScreen(),
    SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() { _selectedIndex = index; });
  }

  @override
  Widget build(BuildContext context) {
    // If you want to explicitly set colors here, you can do so. 
    // Otherwise, rely on the theme set in theme_manager.dart.
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Player"),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        // If you rely on the theme, you don't need to set these again.
        // But if you want to override, uncomment and choose your colors:
        // backgroundColor: Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        // selectedItemColor: Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        // unselectedItemColor: Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'Library'),
          BottomNavigationBarItem(icon: Icon(Icons.playlist_play), label: 'Playlists'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'Player'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
