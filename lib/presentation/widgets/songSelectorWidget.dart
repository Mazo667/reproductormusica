import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:reproductormusica/presentation/songs_selector.dart';

class SongSelectorWidget extends StatelessWidget {
  const SongSelectorWidget({
    super.key,
    required AssetsAudioPlayer assetsAudioPlayer,
    required this.audios,
  }) : _assetsAudioPlayer = assetsAudioPlayer;

  final AssetsAudioPlayer _assetsAudioPlayer;
  final List<Audio> audios;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(2),
      child: _assetsAudioPlayer.builderCurrent(
        builder: (context, Playing? playing) {
          return SongsSelectorWidget(
            audios: audios,
            onPlaylistSelected: (myAudios) {
              _assetsAudioPlayer.open(Playlist(audios: myAudios),
                  showNotification: true,
                  headPhoneStrategy:HeadPhoneStrategy.pauseOnUnplugPlayOnPlug,
                  audioFocusStrategy: const AudioFocusStrategy.request(resumeAfterInterruption: true));
            },
            onSelected: (myAudio) async {
              try{
                await _assetsAudioPlayer.open(
                  myAudio,
                  autoStart: true,
                  showNotification: true,
                  playInBackground: PlayInBackground.enabled,
                  audioFocusStrategy: const AudioFocusStrategy.request(
                      resumeAfterInterruption: true,
                      resumeOthersPlayersAfterDone: true
                  ),
                  headPhoneStrategy: HeadPhoneStrategy.pauseOnUnplug,
                  notificationSettings: const NotificationSettings(
                    //TODO VER OPCIONES
                  ),
                );
              } catch (e) {
                print(e);
              }
            },
            playing: playing,
          );
        },),
    );
  }
}