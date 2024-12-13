// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io' show Platform;
import 'dart:async';
import 'package:audio_service/audio_service.dart';

import 'audio_handler.dart'; // Import the AudioHandler
import 'providers/audio_provider.dart';
import 'providers/library_provider.dart';
import 'providers/playlist_provider.dart';
import 'providers/theme_provider.dart';
import 'ui/screens/home_screen.dart';
import 'utils/theme_manager.dart';
import 'data/database.dart';

void main() async {
  // Initialize sqflite_common_ffi for desktop platforms
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  WidgetsFlutterBinding.ensureInitialized();

  // Initialize your providers
  final libraryProvider = LibraryProvider();
  await libraryProvider.loadLibrary();

  // Start the AudioService
  final audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.music_player.channel.audio',
      androidNotificationChannelName: 'Music Playback',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
      androidNotificationIcon: 'mipmap/ic_launcher', // Ensure you have this icon
    ),
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ChangeNotifierProvider(create: (_) => libraryProvider),
      ChangeNotifierProvider(create: (_) => PlaylistProvider()..loadPlaylists()),
      ChangeNotifierProvider(create: (_) => AudioProvider(audioHandler: audioHandler)),
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
