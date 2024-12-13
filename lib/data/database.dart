// lib/data/database.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

Future<Database> initializeDatabase() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'music_player.db');

  // Open the database, creating it if it doesn't exist
  return await openDatabase(
    path,
    version: 1,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE songs(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          artist TEXT NOT NULL,
          album TEXT NOT NULL,
          albumArtPath TEXT NOT NULL,
          lyrics TEXT,
          isFavorite INTEGER NOT NULL
        )
      ''');
    },
  );
}
