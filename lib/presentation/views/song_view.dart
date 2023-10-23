import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:reproductormusica/presentation/widgets/widgets.dart';

class SongView extends StatefulWidget {
  const SongView({super.key});

  @override
  State<SongView> createState() => HomeViewState();
}

class HomeViewState extends State<SongView> {
  late AssetsAudioPlayer _assetsAudioPlayer;
  final audios = <Audio>[
    Audio('assets/audios/Titanium.mp3',metas: Metas(title: 'Titanium',artist: 'David Guetta',image: const MetasImage.network('https://i1.sndcdn.com/artworks-000049042222-aeu7k5-t500x500.jpg'))),
    Audio('assets/audios/Me Niego.mp3',metas: Metas(title: 'Me Niego',artist: 'Kuwait',image: const MetasImage.network('https://pbs.twimg.com/media/DrBmvE5XgAAHea8.jpg'))),
  ];
  @override
  void initState() {
    super.initState();
    _assetsAudioPlayer = AssetsAudioPlayer.newPlayer();
    openPlayer();
  }

  void openPlayer() async {
    await _assetsAudioPlayer.open(
      Playlist(audios: audios, startIndex: 0),
      showNotification: true,
      //autoStart: true,
    );
  }

  @override
  void dispose() {
    _assetsAudioPlayer.dispose();
    print('dispose');
    super.dispose();
  }

  Audio find(List<Audio> source, String fromPath) {
    return source.firstWhere((element) => element.path == fromPath);
  }


  @override
  Widget build(BuildContext context) {
  //  final size = MediaQuery.of(context).size;
    final Color colorSheme = Theme.of(context).colorScheme.primary;
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 40,right: 5,left: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black12,
              gradient: LinearGradient(begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [colorSheme,Colors.transparent]),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      StreamBuilder<Playing?>(
                          stream: _assetsAudioPlayer.current,
                          builder: (context, playing) {
                            if(playing.data != null){
                              final myAudio = find(
                                  audios, playing.data!.audio.assetAudioPath);
                              print((playing.data!.audio.assetAudioPath));
                              return Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: myAudio.metas.image?.type == ImageType.network ? Image.network(myAudio.metas.image!.path,height: 180,width: 180,fit: BoxFit.cover)
                                        : Image.asset(myAudio.metas.image!.path,height: 180,width: 180,fit: BoxFit.cover),
                                  ));
                            }
                            return const SizedBox.shrink();
                          }),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SliderSong(assetsAudioPlayer: _assetsAudioPlayer),
                  Botones(assetsAudioPlayer: _assetsAudioPlayer),
                  SongSelectorWidget(assetsAudioPlayer: _assetsAudioPlayer, audios: audios)
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
}
