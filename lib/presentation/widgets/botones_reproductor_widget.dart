import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:reproductormusica/presentation/widgets/playingControls.dart';

class Botones extends StatelessWidget {
  const Botones({
    super.key,
    required AssetsAudioPlayer assetsAudioPlayer,
  }) : _assetsAudioPlayer = assetsAudioPlayer;

  final AssetsAudioPlayer _assetsAudioPlayer;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: _assetsAudioPlayer.builderCurrent(
            builder: (context, Playing? playing) {
              return Column(
                children: [
                  _assetsAudioPlayer.builderLoopMode(
                    builder: (context, loopMode) {
                      return PlayerBuilder.isPlaying(
                        player: _assetsAudioPlayer,
                        builder: (context, isPlaying) {
                          return PlayingControls(
                            loopMode: loopMode,
                            isPlaying: isPlaying,
                            isPlaylist: true,
                            onStop: () {
                              _assetsAudioPlayer.stop();
                            },
                            toggleLoop: () {
                              _assetsAudioPlayer.toggleLoop();
                            },
                            onPlay: () {
                              _assetsAudioPlayer.playOrPause();
                            },
                            onNext: () {
                              _assetsAudioPlayer.next(
                                  keepLoopMode: true
                              );
                            },
                            onPrevious: () {
                              _assetsAudioPlayer.previous();
                            },
                          );
                        },);
                    },),
                ],
              );
            })
    );
  }
}