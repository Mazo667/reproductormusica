import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:reproductormusica/presentation/positionseekwidget.dart';

class SliderSong extends StatelessWidget {
  const SliderSong({super.key,
    required AssetsAudioPlayer assetsAudioPlayer,
  }) : _assetsAudioPlayer = assetsAudioPlayer;

  final AssetsAudioPlayer _assetsAudioPlayer;

  @override
  Widget build(BuildContext context) {
    return _assetsAudioPlayer.builderRealtimePlayingInfos(
        builder: (context, RealtimePlayingInfos? infos) {
          if(infos == null){
            return const SizedBox();
          }
          return Column(
            children: [
              PositionSeekWidget(
                currentPosition: infos.currentPosition,
                duration: infos.duration,
                seekTo: (to) {
                  _assetsAudioPlayer.seek(to);
                },),
            ],
          );
        });
  }
}