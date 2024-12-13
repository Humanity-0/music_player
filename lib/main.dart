import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Import sqflite_common_ffi
import 'dart:io' show Platform; // Import to check the platform
import 'dart:async'; // For runZonedGuarded

import 'providers/audio_provider.dart';
import 'providers/library_provider.dart';
import 'providers/playlist_provider.dart';
import 'providers/theme_provider.dart';
import 'ui/screens/home_screen.dart';
import 'utils/theme_manager.dart';
import 'data/database.dart'; // Ensure this import is present

void main() async {
  // Wrap everything inside runZonedGuarded to ensure consistent zones
  runZonedGuarded(() async {
    // Initialize Flutter bindings within the same zone
    WidgetsFlutterBinding.ensureInitialized();

    // Initialize sqflite_common_ffi for desktop platforms
    if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    // Set up a global Flutter error handler
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
      // Optionally, send the error details to an error reporting service here
    };

    // Initialize your providers
    final libraryProvider = LibraryProvider();
    await libraryProvider.loadLibrary();

    // Run the app
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => libraryProvider),
        ChangeNotifierProvider(create: (_) => PlaylistProvider()..loadPlaylists()),
        ChangeNotifierProvider(create: (_) => AudioProvider()),
      ],
      child: const MyApp(),
    ));
  }, (error, stack) {
    // Handle uncaught errors here
    print('Uncaught error: $error');
    print('Stack trace: $stack');
    // Optionally, log the error to an external service
  });
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
