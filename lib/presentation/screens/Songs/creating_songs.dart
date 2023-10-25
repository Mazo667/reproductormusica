import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class SongFileCreator extends StatelessWidget {
  final List<PlatformFile> paths;

  // Controladores de texto para los campos de entrada
  final List<TextEditingController> songNameControllers = [];
  final List<TextEditingController> songArtistControllers = [];

  MiPlayList selectedPlayList = MiPlayList.electronica;

  SongFileCreator({Key? key, required this.paths}) {
    // Inicializa los controladores de texto con valores predeterminados
    for (int i = 0; i < paths.length; i++) {
      songNameControllers.add(TextEditingController(text: paths[i].name));
      songArtistControllers.add(TextEditingController());
    }
  }

  // Función de validación que verifica si ambos campos de entrada no están vacíos
  bool _validateFields() {
    for (int i = 0; i < paths.length; i++) {
      if (songNameControllers[i].text.isEmpty || songArtistControllers[i].text.isEmpty) {
        return false; // La validación falla si algún campo está vacío
      }
    }
    return true; // Todos los campos están llenos
  }

  void _createAudio(String name,String artist,String path,{String imagePath = 'assets/images/mp3_icon.png'}){
    Audio(path,metas: Metas(title: name,artist: artist,image: MetasImage.asset(imagePath)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Agregar Canciones"),

      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if(_validateFields()) {
            //TODO IMPLEMENTAR AGREGADO DE LAS CANCIONES
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Por favor complete todos los campos"))
            );
          }
        },
      label: const Text("Finalizar Agregado"),
      ),
      body: ListView.builder(
            itemCount: paths.length,
              padding: const EdgeInsets.only(bottom: 20),
              itemBuilder: (context, index) {
                final textTheme = Theme.of(context).textTheme;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
                  child: ExpansionTile(
                    title: Text(paths[index].name),
                    subtitle: const Text("Especifique nombre y artista de la cancion"),
                    leading: const Icon(Icons.music_note),
                    children: [
                      const SizedBox(height: 5),
                      TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Introduzca el nombre de la cancion'
                        ),
                        controller: songNameControllers[index],
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Artista',
                            hintText: 'Introduzca el nombre del artista de la cancion'
                        ),
                        controller: songArtistControllers[index],
                      ),
                      const SizedBox(height: 5),
                      ExpansionTile(
                          title: const Text("Agregar a una PlayList"),
                      subtitle: const Text("Opcional"),
                      leading: const Icon(Icons.list),
                        children: [
                          RadioListTile(
                            title: const Text("Electronica"),
                              value: MiPlayList.electronica,
                              groupValue: selectedPlayList,
                              onChanged: (value) {
                                //TODO
                              },),
                          RadioListTile(
                            title: const Text("Cumbia"),
                            value: MiPlayList.cumbia,
                            groupValue: selectedPlayList,
                            onChanged: (value) {
                              //TODO
                            },),
                          RadioListTile(
                            title: const Text("Regueton"),
                            value: MiPlayList.reguetton,
                            groupValue: selectedPlayList,
                            onChanged: (value) {
                              //TODO
                            },),
                        ],
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(onPressed: () {
                              //TODO IMPLEMENTAR METODO PARA AGREGAR IMAGEN
                            }, child: const Text("Seleccionar imagen")),
                            const SizedBox(width: 5),
                            Text("Seleccionar una imagen, es opcional",style: textTheme.titleSmall),
                          ]
                      ),
                    ],
                  ),
                );
              }),
    );
  }
}

enum MiPlayList { electronica, cumbia, reguetton}


