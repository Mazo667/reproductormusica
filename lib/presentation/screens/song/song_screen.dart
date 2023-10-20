import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';

class SongScreen extends StatelessWidget {
  static const name = "song-screen";
  final Audio song;
  const SongScreen({super.key, required this.song});



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _BodySong(song: song),
    );
  }
}

class _BodySong extends StatelessWidget {
  const _BodySong({
    super.key,
    required this.song,
  });

  final Audio song;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      Image.network(song.metas.image!.path),

      ],
    );
  }
}

