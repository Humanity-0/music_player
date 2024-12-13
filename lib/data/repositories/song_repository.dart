// lib/data/repositories/song_repository.dart

import 'package:sqflite/sqflite.dart';
import '../models/song.dart';

class SongRepository {
  final Database db;

  SongRepository({required this.db});

  Future<void> insertSong(Song song) async {
    await db.insert(
      'songs',
      song.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Song>> getAllSongs() async {
    final List<Map<String, dynamic>> maps = await db.query('songs');

    return List.generate(maps.length, (i) {
      return Song.fromMap(maps[i]);
    });
  }

  Future<List<Song>> getFavorites() async {
    final List<Map<String, dynamic>> maps = await db.query(
      'songs',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) {
      return Song.fromMap(maps[i]);
    });
  }

  Future<void> toggleFavorite(int id, bool isFavorite) async {
    await db.update(
      'songs',
      {'isFavorite': isFavorite ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateSong(Song song) async {
    await db.update(
      'songs',
      song.toMap(),
      where: 'id = ?',
      whereArgs: [song.id],
    );
  }

  Future<void> deleteSong(int id) async {
    await db.delete(
      'songs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Implement other methods like getRecentlyPlayed, getRecentlyAdded, etc., as needed
}
