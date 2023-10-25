import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../infraestructure/datasources/audioSQLDatasource.dart';
import '../../../infraestructure/repositories/audioRepositoryImplementation.dart';


final audiosRepositoryProvider = Provider((ref) {
  return AudioRepositoryImplementation(AudioSQLDatasource());
});

final audioPickedProvider = StateNotifierProvider<AudiosNotifier,List<Audio>>((ref) {
  final fetchMoreAudios = ref.watch(audiosRepositoryProvider).getAudio;
});

final playlistCatalogedProvider = StateNotifierProvider<AudiosNotifier,List<Audio>>((ref) {
  final fetchMoreAudios = ref.watch(audiosRepositoryProvider).getPlayList;
});

typedef AudiosCallback = Future<List<Audio>> Function({int page});

class AudiosNotifier extends StateNotifier<List<Audio>>{
  int currentPage = 0;
  bool isLoading = false;
  AudiosCallback fethMoreAudios;

  AudiosNotifier({
    required this.fethMoreAudios,
}) : super ([]);

  Future<void> loadNextPage() async{
    if(isLoading) return;
    isLoading = true;
    print("Cargando Canciones");
    currentPage++;
    List<Audio> audios = await fethMoreAudios(page: currentPage);
    state = [...state,...audios];
    isLoading = false;
  }
}