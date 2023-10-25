import 'package:assets_audio_player/assets_audio_player.dart';

abstract class AudioDatasource {
  Future<Audio> getAudio(int id);
  Future<Playlist> getPlayList(String playlist);
}