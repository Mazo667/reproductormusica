
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:go_router/go_router.dart';
import 'package:reproductormusica/presentation/screens/screens.dart';
import 'package:reproductormusica/presentation/screens/song/song_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
    routes: [
      GoRoute(path: '/',
          name: HomeScreen.name,
      builder: (context, state) {
        return HomeScreen();
      },
      routes: [
        GoRoute(path: 'song/:id',
        name: SongScreen.name,
        builder: (context, state) {
          final song = state.extra as Audio;
          return SongScreen(song: song);
        },)
      ]
      )
    ]);