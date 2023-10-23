import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:reproductormusica/domain/entities/song.dart';

class HomeView extends StatelessWidget {
  HomeView({super.key});

  //TODO REMPLAZAR ESTA LISTA DE CANCIONES CON LOS MP3 QUE TENGA EL DISPOSITIVO
  final List<Song> songs = [
    Song(id: 0, name: 'Titanium', author: 'David Guetta', category: 'Electronica', path: 'Descargas',image: 'assets/images/titanium.jpeg'),
    Song(id: 1, name: 'Me niego', author: 'Ozuna', category: 'Reguetton', path: 'Descargas',image: 'assets/images/mp3_icon.png'),
    Song(id: 2, name: 'No se va', author: 'La Konga', category: 'Cumbia', path: 'Descargas',image: 'assets/images/mp3_icon.png'),
    Song(id: 2, name: 'Wake Me Up', author: 'Avicci', category: 'Electronica', path: 'Descargas',image: 'assets/images/wakemeup.jpg'),
  ];

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reproductor de Musica'),
        leading: const Icon(Icons.music_note),
        actions: [
          IconButton(onPressed: () {
          //TODO BUSQUEDA CANCION
        },
              icon: const Icon(Icons.search)),
        ],
        ),
      body: SizedBox(
        //height: double.infinity,
        //width: double.infinity,
        child: _SongsList(scrollController: scrollController,songs: songs) )
    );
  }
}

class _SongsList extends StatelessWidget {
   _SongsList({super.key, required this.scrollController, required this.songs});

  final ScrollController scrollController;
  final List<Song> songs;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,mainAxisSpacing: 10,crossAxisSpacing: 10,childAspectRatio: 0.80),
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return _SongItem(song: songs[index]);
        },);
  }
}

class _SongItem extends StatelessWidget {
  _SongItem({super.key, required this.song});
  final Song song;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(song.image,fit: BoxFit.cover,width: double.maxFinite,)),
          ),
              Text(song.author,style: textTheme.titleLarge),
              Text(song.name,style: textTheme.titleMedium),
        ],
      ),
    );
  }
}
