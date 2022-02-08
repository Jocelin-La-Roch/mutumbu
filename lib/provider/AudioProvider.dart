import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mutumbu/models/serviceResponse.dart';
import 'package:mutumbu/services/AudioServices.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioProvider with ChangeNotifier{

  List<SongModel> allSongs = [];
  List<AlbumModel> allAlbums = [];
  int currentIndex = 0;
  bool loadingSongs = true;
  bool loadingSongFailed = false;
  final player = AudioPlayer();
  bool firstPlay = true;

  setCurrentIndex(int id){
    currentIndex = id;
    notifyListeners();
  }

  playSong() async{
    await player.setFilePath(allSongs[currentIndex].data);
    player.play();
    firstPlay = false;
    notifyListeners();
  }

  playNext() async{
    var newIndex = currentIndex;
    if(newIndex + 1 == allSongs.length){
      newIndex = 0;
      await player.setFilePath(allSongs[newIndex].data);
      player.play();
      currentIndex = newIndex;
      firstPlay = false;
      notifyListeners();
    }else{
      await player.setFilePath(allSongs[newIndex +1].data);
      player.play();
      currentIndex = newIndex+1;
      firstPlay = false;
      notifyListeners();
    }
  }
  playPrevious() async{
    var newIndex = currentIndex;
    if(newIndex -1 < 0){
      newIndex = allSongs.length - 1;
      await player.setFilePath(allSongs[newIndex].data);
      player.play();
      currentIndex = newIndex;
      firstPlay = false;
      notifyListeners();
    }else{
      await player.setFilePath(allSongs[newIndex - 1].data);
      player.play();
      currentIndex = newIndex -1;
      firstPlay = false;
      notifyListeners();
    }
  }
  pause(){
    player.pause();
  }
  continuePlay() async{
    if(firstPlay){
      await player.setFilePath(allSongs[currentIndex].data);
      player.play();
    }else{
      player.play();
    }
  }

  Future getAllSongs() async{
    ServiceResponse<List<SongModel>> _serviceResponse;
    _serviceResponse = await AudioServices().getAllSongs();
    if(_serviceResponse.permissionGranted == false){
      return "permission";
    }else if(_serviceResponse.error == true && _serviceResponse.permissionGranted == true){
      return "error";
    }else{
      allSongs = _serviceResponse.data;
      notifyListeners();
      return "ok";
    }
  }

  Future getAllAlbums() async{
    ServiceResponse<List<AlbumModel>> _serviceResponse;
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
  }
}