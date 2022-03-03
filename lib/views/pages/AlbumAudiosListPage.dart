// @dart=2.9

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:mutumbu/provider/AudioProvider.dart';
import 'package:mutumbu/utils/colors.dart';
import 'package:mutumbu/views/pages/AudioPlayerPage.dart';
import 'package:provider/provider.dart';

class AlbumAudiosListPage extends StatefulWidget {
  const AlbumAudiosListPage({Key key}) : super(key: key);

  @override
  _AlbumAudiosListPageState createState() => _AlbumAudiosListPageState();
}

class _AlbumAudiosListPageState extends State<AlbumAudiosListPage> {

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  @override
  Widget build(BuildContext context) {
    AudioProvider audioProvider = Provider.of<AudioProvider>(context);
    return Scaffold(
      backgroundColor: black,
      appBar: AppBar(
        backgroundColor: black,
        elevation: 1,
        iconTheme: IconThemeData(color: amber),
      ),
      body: FutureBuilder(
          future: audioProvider.getAlbumSongs(),
          builder: (_, snapshot){
            if(!snapshot.hasData){
              return Center( child: CircularProgressIndicator(color: amber,));
            }else if(snapshot.data == "permission"){
              return Center(
                child: Text("permission réfusée"),
              );
            }else if(snapshot.data == "error"){
              return Center(
                child: Text("Une erreur est survenue"),
              );
            }
            return ListView.builder(
                itemCount: audioProvider.albumSongs.length,
                itemBuilder: (_, index){
                  return ListTile(
                    onTap: (){
                      audioProvider.setCurrentIndex(index);
                      audioProvider.setListIndex(2);
                      audioProvider.setCurrentSong(audioProvider.albumSongs[index]);
                      audioProvider.playSong(2);
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => AudioPlayerPage()));
                    },
                    title: Text(
                      audioProvider.albumSongs[index].title,
                      style: TextStyle(
                          color: (index == audioProvider.currentIndex && audioProvider.listIndex == 2) ? amber : white
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    leading: audioProvider.albumSongs[index].albumArtwork == null ? FutureBuilder<Uint8List>(
                        future: audioQuery.getArtwork(
                            type: ResourceType.SONG,
                            id: audioProvider.albumSongs[index].id,
                            size: Size(100, 100)),
                        builder: (_, snapshot) {
                          if (snapshot.data == null)
                            return CircleAvatar(
                              backgroundColor: black,
                              child: CircularProgressIndicator(
                                //backgroundColor: amber,
                                color: amber,
                              ),
                            );

                          if (snapshot.data.isEmpty)
                            return Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: grey,
                                  borderRadius: BorderRadius.circular(25.0)
                              ),
                            );

                          return CircleAvatar(
                            backgroundColor: Colors.transparent,
                            backgroundImage: MemoryImage(
                              snapshot.data,
                            ),
                            radius: 25.0,
                          );
                        })
                        : null,
                    trailing: (index == audioProvider.currentIndex && audioProvider.listIndex == 2) ? Icon(Icons.music_note_rounded, color: amber,) : null,
                  );
                }
            );
          }
      ),
    );
  }
}
