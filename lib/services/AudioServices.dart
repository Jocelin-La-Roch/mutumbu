// @dart=2.9

import 'package:flutter_audio_query/flutter_audio_query.dart';
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
      // final OnAudioQuery _audioQuery = OnAudioQuery();
      // List<SongModel> songs = await _audioQuery.querySongs();
      final FlutterAudioQuery audioQuery = FlutterAudioQuery();
      List<SongInfo> songs = await audioQuery.getSongs();
      return ServiceResponse<List<SongInfo>>(data: songs, errorMessage: "songs list", permissionGranted: true, error: false);
  }
  getAllAlbums() async{
    // final OnAudioQuery _audioQuery = OnAudioQuery();
    // List<AlbumInfo> albums = await _audioQuery;
    final FlutterAudioQuery audioQuery = FlutterAudioQuery();
    List<AlbumInfo> albums = await audioQuery.getAlbums();
    return ServiceResponse<List<AlbumInfo>>(data: albums, errorMessage: "albums list", permissionGranted: true, error: false);
  }

  getAllArtists() async{
    // final OnAudioQuery _audioQuery = OnAudioQuery();
    // List<AlbumInfo> albums = await _audioQuery;
    final FlutterAudioQuery audioQuery = FlutterAudioQuery();
    List<ArtistInfo> artists = await audioQuery.getArtists();
    return ServiceResponse<List<ArtistInfo>>(data: artists, errorMessage: "artists list", permissionGranted: true, error: false);
  }

  getAlbumSongs(String albumId) async{
    final FlutterAudioQuery audioQuery = FlutterAudioQuery();
    List<SongInfo> songs = await audioQuery.getSongsFromAlbum(albumId: albumId);
    return ServiceResponse<List<SongInfo>>(data: songs, errorMessage: "album songs list", permissionGranted: true, error: false);
  }

  getArtistSong(String artistId) async{
    final FlutterAudioQuery audioQuery = FlutterAudioQuery();
    List<SongInfo> songs = await audioQuery.getSongsFromArtist(artistId: artistId);
    return ServiceResponse<List<SongInfo>>(data: songs, errorMessage: "artist songs list", permissionGranted: true, error: false);
  }
}