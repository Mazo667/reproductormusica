import 'package:assets_audio_player/assets_audio_player.dart';

abstract class AudioRepository {
  Future<Audio> getAudio();
}