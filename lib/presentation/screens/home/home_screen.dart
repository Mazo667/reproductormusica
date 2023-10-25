import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reproductormusica/presentation/views/song_view.dart';
import 'package:reproductormusica/presentation/widgets/widgets.dart';
import 'package:reproductormusica/presentation/views/views.dart';

import '../../views/file_picker_view.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key, required this.pageIndex});

  static const name = 'home-screen';
  final int pageIndex;

  final viewRoutes =  <Widget>[
   HomeView(),
   SongView(),
    FilePickerView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: pageIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomNavigation(currentIndex: pageIndex),
    );
  }
}


