class Song {
  final int? id;
  String title;
  String artist;
  String album;
  String albumArtPath; // Local path to the album art image
  String lyrics;
  bool isFavorite;
  int playCount;
  DateTime dateAdded;
  DateTime lastPlayed;

  Song({
    this.id,
    required this.title,
    required this.artist,
    required this.album,
    required this.albumArtPath,
    required this.lyrics,
    this.isFavorite = false,
    this.playCount = 0,
    DateTime? dateAdded,
    DateTime? lastPlayed,
  })  : dateAdded = dateAdded ?? DateTime.now(),
        lastPlayed = lastPlayed ?? DateTime.fromMillisecondsSinceEpoch(0);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'artist': artist,
      'album': album,
      'albumArtPath': albumArtPath,
      'lyrics': lyrics,
      'isFavorite': isFavorite ? 1 : 0,
      'playCount': playCount,
      'dateAdded': dateAdded.millisecondsSinceEpoch,
      'lastPlayed': lastPlayed.millisecondsSinceEpoch,
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    return Song(
      id: map['id'] as int?,
      title: map['title'] as String,
      artist: map['artist'] as String,
      album: map['album'] as String,
      albumArtPath: map['albumArtPath'] as String,
      lyrics: map['lyrics'] as String,
      isFavorite: (map['isFavorite'] as int) == 1,
      playCount: map['playCount'] as int,
      dateAdded: DateTime.fromMillisecondsSinceEpoch(map['dateAdded'] as int),
      lastPlayed:
          DateTime.fromMillisecondsSinceEpoch(map['lastPlayed'] as int),
    );
  }
}
