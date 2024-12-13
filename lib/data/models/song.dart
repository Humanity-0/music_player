// lib/data/models/song.dart

class Song {
  final int? id;
  final String title;
  final String artist;
  final String album;
  final String albumArtPath;
  final String lyrics;
  final bool isFavorite;

  Song({
    this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.albumArtPath,
    required this.lyrics,
    this.isFavorite = false,
  });

  // Convert a Song into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'albumArtPath': albumArtPath,
      'lyrics': lyrics,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  // Extract a Song object from a Map.
  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'],
      title: map['title'],
      artist: map['artist'],
      album: map['album'],
      albumArtPath: map['albumArtPath'],
      lyrics: map['lyrics'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}
