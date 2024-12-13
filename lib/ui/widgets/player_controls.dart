import 'package:flutter/material.dart';

class PlayerControls extends StatelessWidget {
  final bool isPlaying;
  final VoidCallback onPlayPause;
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final VoidCallback onShuffle;

  const PlayerControls({
    Key? key,
    required this.isPlaying,
    required this.onPlayPause,
    required this.onNext,
    required this.onPrevious,
    required this.onShuffle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(icon: const Icon(Icons.skip_previous), onPressed: onPrevious),
        IconButton(icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow), onPressed: onPlayPause),
        IconButton(icon: const Icon(Icons.skip_next), onPressed: onNext),
        IconButton(icon: const Icon(Icons.shuffle), onPressed: onShuffle),
      ],
    );
  }
}
