import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/audio_provider.dart';
import 'providers/library_provider.dart';
import 'providers/playlist_provider.dart';
import 'providers/theme_provider.dart';
import 'ui/screens/home_screen.dart';
import 'utils/theme_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final libraryProvider = LibraryProvider();
  await libraryProvider.loadLibrary();

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => libraryProvider),
      ChangeNotifierProvider(create: (_) => PlaylistProvider()..loadPlaylists()),
      ChangeNotifierProvider(create: (_) => AudioProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Music Player',
          themeMode: themeProvider.themeMode,
          theme: ThemeManager.lightTheme,
          darkTheme: ThemeManager.darkTheme,
          home: const HomeScreen(),
        );
      },
    );
  }
}
