// lib/data/services/song_scanner.dart

import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class SongScanner {
  /// Scans the device for MP3 files.
  Future<List<File>> scanForMp3Files() async {
    List<File> mp3Files = [];
    Directory? musicDir;

    if (Platform.isAndroid) {
      // For Android, use the Music directory
      musicDir = Directory('/storage/emulated/0/Music');
      if (!musicDir.existsSync()) {
        // Fallback to the general external storage directory
        musicDir = await getExternalStorageDirectory();
      }
    } else {
      // For other platforms, use the application's documents directory
      musicDir = await getApplicationDocumentsDirectory();
    }

    if (musicDir != null && musicDir.existsSync()) {
      mp3Files = await _listMp3Files(musicDir);
    }

    return mp3Files;
  }

  /// Recursively lists all MP3 files in the given directory.
  Future<List<File>> _listMp3Files(Directory dir) async {
    List<File> mp3Files = [];
    try {
      await for (var entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is File && p.extension(entity.path).toLowerCase() == '.mp3') {
          mp3Files.add(entity);
        }
      }
    } catch (e) {
      // Handle any errors, such as permission issues or inaccessible directories.
      print('Error scanning directory ${dir.path}: $e');
    }
    return mp3Files;
  }
}
