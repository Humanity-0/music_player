import 'package:flutter/material.dart';

class LyricView extends StatelessWidget {
  final String lyrics;
  const LyricView({Key? key, required this.lyrics}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Text(lyrics, style: const TextStyle(fontSize: 16)),
    );
  }
}
