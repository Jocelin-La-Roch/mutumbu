import 'package:mutumbu/models/serviceResponse.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioServices {

  Future<bool> checkPermission() async{
    var status = await Permission.storage.status;
    if(status.isDenied || status.isPermanentlyDenied){
      var permission = await Permission.storage.request();
      if(permission.isDenied || permission.isPermanentlyDenied){
        return false;
      }else{
        return true;
      }
    }else{
      return true;
    }
  }

  getAllSongs() async{
      final OnAudioQuery _audioQuery = OnAudioQuery();
      List<SongModel> songs = await _audioQuery.querySongs();
      return ServiceResponse<List<SongModel>>(data: songs, errorMessage: "songs list", permissionGranted: true, error: false);
  }
  getAllAlbums() async{
    final OnAudioQuery _audioQuery = OnAudioQuery();
    List<AlbumModel> albums = await _audioQuery.queryAlbums();
    return ServiceResponse<List<AlbumModel>>(data: albums, errorMessage: "albums list", permissionGranted: true, error: false);
  }
}