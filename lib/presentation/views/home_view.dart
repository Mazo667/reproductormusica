import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:reproductormusica/domain/entities/song.dart';
import 'package:reproductormusica/presentation/providers/audios/audio_provider.dart';
import 'package:reproductormusica/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView();

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _fileName;
  String? _directoryPath;
  String? _extension;
  List<PlatformFile>? paths;
  bool _userAborted = false;
  bool _isLoading = false;
 
  @override
  void initState() {
    super.initState();
    ref.read(audioPickedProvider.notifier).loadNextPage();
  }


  void _pickFiles() async {
    try{
      _directoryPath = null;
      paths = (await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
        //dialogTitle:
        //initialDirectory:
       //lockParentWindow:
      ))
      ?.files;
    } on PlatformException catch (e) {
      _logException('Unsupported operation' + e.toString());
    } catch (e){
      _logException(e.toString());
    }
    if (!mounted ) return;
    setState(() {
      _isLoading = false;
      _fileName = paths != null ? paths!.map((e) => e.name).toString() : '...';
      _directoryPath = paths != null ? paths!.map((e) => e.path).toString() : '...';
      _userAborted = paths == null;
      context.push('/songCreator',extra: paths);
    });
  }
  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void openDialog(BuildContext context){
    showDialog(
        context: context,
        //barrierDismissible: false, //una vez abierto no se puede cerrar haciendo tap de fondo
        builder: (context) => Dialog(
          child: Column(
            children: [
              Text(_directoryPath!),
              Text(_fileName!),
              Text('${paths!.length}')
            ],
          ),
        ));
  }

  final scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {

    final audiosPicked = ref.watch(audioPickedProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Canciones'),
        actions: [
          IconButton(onPressed: () {
          //TODO BUSQUEDA CANCION
        },
              icon: const Icon(Icons.search)),
        ],
        ),
      drawer: SideMenu(),
      body: SizedBox(
        //height: double.infinity,
        //width: double.infinity,
        child: _SongsList(scrollController: scrollController,songs: audiosPicked) ),
      floatingActionButton: FloatingActionButton(
      child: const Icon(Icons.add_rounded)
      ,onPressed: () {
          _pickFiles();
      },),
    );
  }
}

class _SongsList extends StatelessWidget {
   _SongsList({super.key, required this.scrollController, required this.songs});

  final ScrollController scrollController;
  final List<Audio> songs;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          return _SongItem(song: songs[index]);
        },);
  }
}

enum PopMenuItemsEnum { itemOne, itemTwo }

class _SongItem extends StatelessWidget {
  _SongItem({super.key, required this.song});
  final Audio song;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: () {
        print("Reproduci la cancion");
      },
      child: ListTile(
        title: Text(song.metas.title!,style: textTheme.titleLarge),
        subtitle: Text(song.metas.artist!,style: textTheme.titleMedium),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(10),
            child: Image.asset(song.metas.image!.path ?? 'assets/images/mp3_icon.png')),
        trailing: PopupMenuButton<PopMenuItemsEnum>(itemBuilder: (context) => <PopupMenuEntry<PopMenuItemsEnum>>[
          PopupMenuItem<PopMenuItemsEnum>(
            value: PopMenuItemsEnum.itemOne,
            child: const Text('Agregar a un PlayList'),
            onTap: () {
              print("Agregue a la playlist");
            },
          ),
           PopupMenuItem<PopMenuItemsEnum>(
            value: PopMenuItemsEnum.itemTwo,
            child: const Text('Eliminar Cancion'),
            onTap: () {
              print("Elimine la cancion");
            },
          ),
        ],
        ),
      ),
    );

  }
}

/* Version Antigua
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
 */