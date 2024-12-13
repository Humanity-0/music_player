// lib/ui/screens/library_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/library_provider.dart';
import '../../providers/audio_provider.dart';
import '../../data/models/song.dart';
import '../widgets/song_list_item.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  LibraryScreenState createState() => LibraryScreenState();
}

class LibraryScreenState extends State<LibraryScreen> {
  bool _isScanning = false;

  void _playSong(BuildContext context, Song song) {
    final audioProvider = Provider.of<AudioProvider>(context, listen: false);
    audioProvider.playSong(song);
  }

  Future<void> _scanSongs(BuildContext context) async {
    setState(() { _isScanning = true; });
    final libraryProvider = Provider.of<LibraryProvider>(context, listen: false);
    await libraryProvider.queryAndLoadSongs();
    setState(() { _isScanning = false; });
  }

  @override
  void initState() {
    super.initState();
    // Initiate scanning when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scanSongs(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LibraryProvider>(
      builder: (context, library, child) {
        return Column(
          children: [
            if (_isScanning)
              const LinearProgressIndicator(),
            Expanded(
              child: ListView.builder(
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
                      // Implement song editing functionality
                      // For example, show a dialog to edit song details
                    },
                    onDelete: () {
                      library.deleteSong(song);
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
