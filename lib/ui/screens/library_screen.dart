import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/library_provider.dart';
import '../../ui/widgets/song_list_item.dart';
import '../../data/models/song.dart';
import '../../providers/audio_provider.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  void _playSong(BuildContext context, Song song) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSong(song);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(
      builder: (context, library, child) {
        return ListView.builder(
          itemCount: library.allSongs.length,
          itemBuilder: (context, index) {
            final song = library.allSongs[index];
            return SongListItem(
              song: song,
              onPlay: () => _playSong(context, song),
              onFavoriteToggle: () {
                library.toggleFavorite(song);
              },
              onEdit: () {
                // open edit dialog
              },
              onDelete: () {
                library.deleteSong(song);
              },
            );
          },
        );
      },
    );
  }
}
