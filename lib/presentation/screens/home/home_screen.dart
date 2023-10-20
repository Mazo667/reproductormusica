import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reproductormusica/presentation/positionseekwidget.dart';
import 'package:reproductormusica/presentation/songs_selector.dart';
import 'package:reproductormusica/presentation/widgets/playingControls.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const name = 'home-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('REPRODUCTOR MUSICA'),
      ),
      body: const _HomeView(),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView({super.key});

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
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
      autoStart: true,
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black12,
              gradient: const LinearGradient(begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black,Colors.black12]),
              borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 40),
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
              _SliderSong(assetsAudioPlayer: _assetsAudioPlayer),
              _Botones(assetsAudioPlayer: _assetsAudioPlayer),
              _SongSelectorWidget(assetsAudioPlayer: _assetsAudioPlayer, audios: audios)
            ],
          ),
        ),
      ),
    );

  }
}

class _SongSelectorWidget extends StatelessWidget {
  const _SongSelectorWidget({
    super.key,
    required AssetsAudioPlayer assetsAudioPlayer,
    required this.audios,
  }) : _assetsAudioPlayer = assetsAudioPlayer;

  final AssetsAudioPlayer _assetsAudioPlayer;
  final List<Audio> audios;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: _assetsAudioPlayer.builderCurrent(
        builder: (context, Playing? playing) {
          return SongsSelector(
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

class _Botones extends StatelessWidget {
  const _Botones({
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

class _SliderSong extends StatelessWidget {
  const _SliderSong({super.key,
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


class _CustomSongCard extends StatelessWidget {
  final Audio song;
  final Function() onPlayPressed;
  final Function() onPausePressed;
  const _CustomSongCard({super.key, required this.song, required this.onPlayPressed, required this.onPausePressed});

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => context.push('/song/${song.metas.id}',extra: song),
      child: Container(
        width: double.infinity,
        color: Colors.pinkAccent,
        height: 70,
        child: Padding(
          padding: const EdgeInsets.all(2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(song.metas.image!.path),
              ),
              const SizedBox(width: 10),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(song.metas.title!,style: textTheme.titleMedium),
                  Text(song.metas.artist!,style: textTheme.titleSmall),
                ],
              ),
              const Spacer(),
              IconButton(onPressed: () {
                onPlayPressed();
              }, icon: const Icon(Icons.play_arrow)),
              IconButton(onPressed: () {
                onPausePressed;
              }, icon: const Icon(Icons.pause)),
              IconButton(onPressed: () {
              }, icon: const Icon(Icons.favorite)),
            ],
          ),
        ),
      ),
    );
  }
}
