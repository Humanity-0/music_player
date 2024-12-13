import 'package:flutter/material.dart';
import '../../data/models/playlist.dart';

class PlaylistListItem extends StatelessWidget {
  final Playlist playlist;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  const PlaylistListItem({
    Key? key,
    required this.playlist,
    required this.onOpen,
    required this.onDelete
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(playlist.name),
      onTap: onOpen,
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: onDelete,
      ),
    );
  }
}
