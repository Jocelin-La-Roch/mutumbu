// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mutumbu/models/serviceResponse.dart';
import 'package:mutumbu/services/AudioServices.dart';
//import 'package:on_audio_query/on_audio_query.dart';

class AudioProvider with ChangeNotifier{

  //List<SongModel> allSongs = [];
  List<SongInfo> allSongs = [];
  List<AlbumInfo> allAlbums = [];
  List<SongInfo> albumSongs = [];

  SongInfo currentSong;

  int currentIndex = 0;
  int currentAlbumIndex = 0;
  int listIndex = 1;
  bool loadingSongs = true;
  bool loadingSongFailed = false;
  final player = AudioPlayer();
  bool firstPlay = true;
  double position = 0.0;

  setCurrentSong(SongInfo song){
    currentSong = song;
    notifyListeners();
  }

  setCurrentIndex(int id){
    currentIndex = id;
    notifyListeners();
  }
  setCurrentAlbumIndex(int id){
    currentAlbumIndex = id;
    notifyListeners();
  }
  setListIndex(int index){
   listIndex = index;
    notifyListeners();
  }

  playSong(int listIndex) async{
    if(listIndex == 1){
      await player.setFilePath(allSongs[currentIndex].filePath);
      player.play();
      firstPlay = false;
      notifyListeners();
      player.positionStream.listen((currentPosition) {
        position = currentPosition.inSeconds.toDouble();
        notifyListeners();
        if(currentPosition.inSeconds.toDouble() == player.duration.inSeconds.toDouble()){
          playNext();
        }
      });
    }else if(listIndex == 2) {
      await player.setFilePath(albumSongs[currentAlbumIndex].filePath);
      player.play();
      firstPlay = false;
      notifyListeners();
      player.positionStream.listen((currentPosition) {
        position = currentPosition.inSeconds.toDouble();
        notifyListeners();
        if(currentPosition.inSeconds.toDouble() == player.duration.inSeconds.toDouble()){
          playNext();
        }
      });
    }
  }

  playNext() async{
    if(listIndex == 1){
      var newIndex = currentIndex;
      if(newIndex + 1 == allSongs.length){
        newIndex = 0;
        // await player.setFilePath(allSongs[newIndex].data);
        await player.setFilePath(allSongs[newIndex].filePath);
        player.play();
        currentIndex = newIndex;
        firstPlay = false;
        notifyListeners();
      }else{
        await player.setFilePath(allSongs[newIndex +1].filePath);
        player.play();
        currentIndex = newIndex+1;
        firstPlay = false;
        notifyListeners();
      }
      player.positionStream.listen((currentPosition) {
        position = currentPosition.inSeconds.toDouble();
        notifyListeners();
        if(currentPosition.inSeconds.toDouble() == player.duration.inSeconds.toDouble()){
          playNext();
        }
      });
    }else if(listIndex == 2){
      var newIndex = currentIndex;
      if(newIndex + 1 == albumSongs.length){
        newIndex = 0;
        // await player.setFilePath(allSongs[newIndex].data);
        await player.setFilePath(albumSongs[newIndex].filePath);
        player.play();
        currentIndex = newIndex;
        firstPlay = false;
        notifyListeners();
      }else{
        await player.setFilePath(albumSongs[newIndex +1].filePath);
        player.play();
        currentIndex = newIndex+1;
        firstPlay = false;
        notifyListeners();
      }
      player.positionStream.listen((currentPosition) {
        position = currentPosition.inSeconds.toDouble();
        notifyListeners();
        if(currentPosition.inSeconds.toDouble() == player.duration.inSeconds.toDouble()){
          playNext();
        }
      });
    }
  }

  playPrevious() async{
    if(listIndex == 1){
      var newIndex = currentIndex;
      if(newIndex -1 < 0){
        newIndex = allSongs.length - 1;
        await player.setFilePath(allSongs[newIndex].filePath);
        player.play();
        currentIndex = newIndex;
        firstPlay = false;
        notifyListeners();
      }else{
        await player.setFilePath(allSongs[newIndex - 1].filePath);
        player.play();
        currentIndex = newIndex -1;
        firstPlay = false;
        notifyListeners();
      }
      player.positionStream.listen((currentPosition) {
        position = currentPosition.inSeconds.toDouble();
        notifyListeners();
        if(currentPosition.inSeconds.toDouble() == player.duration.inSeconds.toDouble()){
          playNext();
        }
      });
    }else if(listIndex == 2){
      var newIndex = currentIndex;
      if(newIndex -1 < 0){
        newIndex = albumSongs.length - 1;
        await player.setFilePath(albumSongs[newIndex].filePath);
        player.play();
        currentIndex = newIndex;
        firstPlay = false;
        notifyListeners();
      }else{
        await player.setFilePath(albumSongs[newIndex - 1].filePath);
        player.play();
        currentIndex = newIndex -1;
        firstPlay = false;
        notifyListeners();
      }
      player.positionStream.listen((currentPosition) {
        position = currentPosition.inSeconds.toDouble();
        notifyListeners();
        if(currentPosition.inSeconds.toDouble() == player.duration.inSeconds.toDouble()){
          playNext();
        }
      });
    }
  }

  pause(){
    player.pause();
    notifyListeners();
  }

  continuePlay() async{
    if(listIndex == 1){
      if(firstPlay){
        await player.setFilePath(allSongs[currentIndex].filePath);
        player.play();
        notifyListeners();
      }else{
        player.play();
        notifyListeners();
      }
      player.positionStream.listen((currentPosition) {
        position = currentPosition.inSeconds.toDouble();
        notifyListeners();
        if(currentPosition.inSeconds.toDouble() == player.duration.inSeconds.toDouble()){
          playNext();
        }
      });
    }else if(listIndex == 2){
      if(firstPlay){
        await player.setFilePath(albumSongs[currentIndex].filePath);
        player.play();
        notifyListeners();
      }else{
        player.play();
        notifyListeners();
      }
      player.positionStream.listen((currentPosition) {
        position = currentPosition.inSeconds.toDouble();
        notifyListeners();
        if(currentPosition.inSeconds.toDouble() == player.duration.inSeconds.toDouble()){
          playNext();
        }
      });
    }
  }

  Future getAllSongs() async{
    if(allSongs.length == 0){
      ServiceResponse<List<SongInfo>> _serviceResponse;
      _serviceResponse = await AudioServices().getAllSongs();
      if(_serviceResponse.permissionGranted == false){
        return "permission";
      }else if(_serviceResponse.error == true && _serviceResponse.permissionGranted == true){
        return "error";
      }else{
        allSongs = _serviceResponse.data;
        currentSong = allSongs[0];
        notifyListeners();
        return "ok";
      }
    }else{
      return "ok";
    }
  }

  Future getAllAlbums() async{
    if(allAlbums.length == 0){
      ServiceResponse<List<AlbumInfo>> _serviceResponse;
      _serviceResponse = await AudioServices().getAllAlbums();
      if(_serviceResponse.permissionGranted == false){
        return "permission";
      }else if(_serviceResponse.error == true && _serviceResponse.permissionGranted == true){
        return "error";
      }else{
        allAlbums = _serviceResponse.data;
        notifyListeners();
        print(allAlbums[0]);
        return "ok";
      }
    }else{
      return "ok";
    }
  }

  Future getAlbumSongs() async{
    ServiceResponse<List<SongInfo>> _serviceResponse;
    _serviceResponse = await AudioServices().getAlbumSongs(allAlbums[currentAlbumIndex].id);
    if(_serviceResponse.permissionGranted == false){
      return "permission";
    }else if(_serviceResponse.error == true && _serviceResponse.permissionGranted == true){
      return "error";
    }else{
      albumSongs = _serviceResponse.data;
      notifyListeners();
      return "ok";
    }
  }

  listenToDuration(double value){
    player.seek(Duration(seconds: value.toInt()));
    notifyListeners();
  }
}