import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/playlist_provider.dart';
import '../../ui/widgets/playlist_list_item.dart';

class PlaylistScreen extends StatelessWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  void _createPlaylist(BuildContext context) async {
    final nameController = TextEditingController();
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Create Playlist"),
        content: TextField(controller: nameController),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty) {
                Provider.of<PlaylistProvider>(context, listen: false).createPlaylist(nameController.text);
                Navigator.pop(ctx);
              }
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, playlistProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Playlists"),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _createPlaylist(context),
              )
            ],
          ),
          body: ListView.builder(
            itemCount: playlistProvider.playlists.length,
            itemBuilder: (context, index) {
              final playlist = playlistProvider.playlists[index];
              return PlaylistListItem(
                playlist: playlist,
                onOpen: () {
                  // Open playlist detail screen
                },
                onDelete: () {
                  playlistProvider.deletePlaylist(playlist.id!);
                },
              );
            },
          ),
        );
      },
    );
  }
}
