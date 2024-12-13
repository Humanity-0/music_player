import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/models/song.dart';

class SongListItem extends StatelessWidget {
  final Song song;
  final VoidCallback onPlay;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SongListItem(
      {Key? key,
      required this.song,
      required this.onPlay,
      required this.onFavoriteToggle,
      required this.onEdit,
      required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: song.albumArtPath.isNotEmpty &&
              Uri.parse(song.albumArtPath).isScheme("file")
          ? Image.file(
              File(Uri.parse(song.albumArtPath).toFilePath()),
              errorBuilder: (context, error, stack) =>
                  const Icon(Icons.music_note),
              fit: BoxFit.cover,
            )
          : Image.asset(
              'assets/default_art.png',
              fit: BoxFit.cover,
            ),
      title: Text(song.title),
      subtitle: Text('${song.artist} - ${song.album}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon:
                Icon(song.isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: onFavoriteToggle,
          ),
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: onPlay,
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') onEdit();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'edit', child: Text('Edit')),
              const PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          )
        ],
      ),
    );
  }
}
