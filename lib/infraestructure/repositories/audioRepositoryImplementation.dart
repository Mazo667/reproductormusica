import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:reproductormusica/domain/datasources/AudioDatasource.dart';
import 'package:reproductormusica/domain/repositories/AudioRepository.dart';

class AudioRepositoryImplementation extends AudioRepository{
  final AudioDatasource datasource;

  AudioRepositoryImplementation(this.datasource);

  @override
  Future<Audio> getAudio(int id) {
    return datasource.getAudio(id);
  }

  @override
  Future<Playlist> getPlayList(String playlist) {
    return datasource.getPlayList(playlist);
  }

}