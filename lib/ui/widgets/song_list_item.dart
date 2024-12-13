// lib/ui/widgets/song_list_item.dart

import 'package:flutter/material.dart';
import '../../data/models/song.dart';

class SongListItem extends StatelessWidget {
  final Song song;
  final VoidCallback onPlay;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SongListItem({
    Key? key,
    required this.song,
    required this.onPlay,
    required this.onFavoriteToggle,
    required this.onEdit,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: song.albumArtPath.isNotEmpty
          ? Image.network(
              song.albumArtPath,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.music_note),
            )
          : const Icon(Icons.music_note),
      title: Text(song.title),
      subtitle: Text(song.artist),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(song.isFavorite ? Icons.favorite : Icons.favorite_border),
            color: song.isFavorite ? Colors.red : null,
            onPressed: onFavoriteToggle,
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: onPlay,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: onEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}
