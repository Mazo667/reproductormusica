
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:reproductormusica/presentation/screens/screens.dart';

final appRouter = GoRouter(
  initialLocation: '/home/0',
    routes: [
      GoRoute(path: '/home/:page',
          name: HomeScreen.name,
      builder: (context, state) {
        final pageIndex = int.parse(state.pathParameters['page'] ?? '0');
        return HomeScreen(pageIndex: pageIndex);
      },
        routes: [

        ]
      ),
      GoRoute(path: '/',redirect: (context, state) => '/home/0'),
      GoRoute(path: '/songCreator',builder: (context, state) {
        return SongFileCreator(paths: state.extra as List<PlatformFile>);
      })
    ]);