import 'package:assets_audio_player/src/playable.dart';
import 'package:reproductormusica/domain/datasources/AudioDatasource.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AudioSQLDatasource extends AudioDatasource {
  late Future<Database> db;

  AudioSQLDatasource(){
    db = getDatabase();
  }

  Future<Database> getDatabase() async{
    if (_database != null) {
      return _database!;
    }
    //si la base de datos es nula, creo la base datos
    _database = await _initDB('player.db');
    return _database!;
    }

  //Creo una instancia de una base de datos
  static Database? _database;


  final String tableAudios = 'audios';


  Future<Database> _initDB(String filePath) async {
    //Obtengo el path la base de datos
    final dbPath = await getDatabasesPath();
    //uno el path con el nombre de la base de datos
    final path = join(dbPath, filePath);
    return await openDatabase(path,
        version: 1,
        onCreate: _onCreateDB); //Creamos la base de datos si no existe
  }

  //metodo para crear la tabla en la base datos
  Future _onCreateDB(Database db, int version) async {
    // utilizo comillas triples para escribir enters
    await db.execute('''
    CREATE TABLE $tableAudios(
    "id"	INTEGER,
	  "name"	TEXT NOT NULL,
	  "artist"	TEXT NOT NULL,
	  "image"	TEXT,
	  "path"	TEXT NOT NULL,
	  "playlist"	TEXT,
	  CONSTRAINT "pk_audios" PRIMARY KEY("id" AUTOINCREMENT)
    )
    ''');
  }


  Future<void> insert(Audio song) async {
    final sql = await db;
    await sql.insert(tableAudios, song.toMapDatabase(),
        //si encuentra un item del mismo id lo reemplaza
        conflictAlgorithm: ConflictAlgorithm.replace);
  }


  @override
  Future<Audio> getAudio(int id) async {
    final sql = await db;
    final List<Map<String, dynamic>> mapSong = await sql.query(
      tableAudios,
      where: 'id = ?',
      whereArgs: [id],
    );

  // Si se encuentra un registro, conviértelo a un objeto de tipo Audio y devuelve
    return Audio.fromMapDatabase(mapSong.first);
  }

  @override
  Future<Playlist> getPlayList(String playlist) async {
    final sql = await db;
    final List<Map<String, dynamic>> mapPlaylist = await sql.query(
      tableAudios,
    where: 'playlist = ?',
    whereArgs: [playlist]);

    return Playlist.fromMapDatabase(mapPlaylist);
  }

}