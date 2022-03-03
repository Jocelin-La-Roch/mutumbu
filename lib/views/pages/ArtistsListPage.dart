// @dart=2.9
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:mutumbu/provider/AudioProvider.dart';
import 'package:mutumbu/utils/colors.dart';
import 'package:mutumbu/views/pages/AlbumAudiosListPage.dart';
import 'package:mutumbu/views/pages/ArtistAudiosListPage.dart';
import 'package:provider/provider.dart';


class ArtistsListPage extends StatefulWidget {
  const ArtistsListPage({Key key}) : super(key: key);

  @override
  _ArtistsListPageState createState() => _ArtistsListPageState();
}

class _ArtistsListPageState extends State<ArtistsListPage> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  @override
  Widget build(BuildContext context) {
    AudioProvider audioProvider = Provider.of<AudioProvider>(context);
    return Scaffold(
      backgroundColor: black,
      body: FutureBuilder(
          future: audioProvider.getAllArtist(),
          builder: (_, snapshot){
            if(!snapshot.hasData){
              return Center( child: CircularProgressIndicator(color: amber,));
            }else if(snapshot.data == "permission"){
              return Center(
                child: Text("permission réfusée"),
              );
            }else if(snapshot.data == "error"){
              return Center(
                child: Text("Une erreur est survenue", style: TextStyle(color: white),),
              );
            }
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 2 / 2.5,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20
              ),
              itemCount: audioProvider.allAlbums.length,
              itemBuilder: (_, index){
                return InkWell(
                  onTap: (){
                    audioProvider.setCurrentArtistIndex(index);
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => ArtistAudiosListPage()));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                        color: black,
                        borderRadius: BorderRadius.circular(5.0)
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: 10.0,),
                        /*QueryArtworkWidget(
                            id: audioProvider.allAlbums[index].id,
                            type: ArtworkType.ALBUM,
                            artwork: audioProvider.allAlbums[index].artwork,
                            deviceSDK: 30,
                            artworkHeight: MediaQuery.of(context).size.width*0.3,
                            artworkWidth: MediaQuery.of(context).size.width*0.3,
                            artworkBorder: BorderRadius.circular(180),
                            nullArtworkWidget: Container(
                              height: MediaQuery.of(context).size.width*0.3,
                              width: MediaQuery.of(context).size.width*0.3,
                              decoration: BoxDecoration(
                                color: black,
                                borderRadius: BorderRadius.circular(180.0)
                              ),
                              child: Center(
                                child: Text(
                                  audioProvider.allAlbums[index].albumName[0].toUpperCase(),
                                  style: TextStyle(
                                    color: amber,
                                    fontSize: 24
                                  ),
                                ),
                              ),
                            ),
                          ),*/
                        if (audioProvider.allArtists[index].artistArtPath == null) FutureBuilder<Uint8List>(
                          future: audioQuery.getArtwork(
                              type: ResourceType.ARTIST,
                              id: audioProvider.allArtists[index].id,
                              size: Size(100, 100)
                          ),
                          builder: (_, snapshot){
                            if (snapshot.data == null){
                              return Container(
                                height: MediaQuery.of(context).size.width*0.3,
                                width: MediaQuery.of(context).size.width*0.3,
                                decoration: BoxDecoration(
                                    color: grey,
                                    borderRadius: BorderRadius.circular(180)
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    //backgroundColor: amber,
                                    color: amber,
                                  ),
                                ),
                              );
                            }
                            if (snapshot.data.isEmpty){
                              return Container(
                                height: MediaQuery.of(context).size.width*0.3,
                                width: MediaQuery.of(context).size.width*0.3,
                                decoration: BoxDecoration(
                                    color: grey,
                                    borderRadius: BorderRadius.circular(180.0)
                                ),
                                child: Center(
                                  child: Text(
                                    audioProvider.allArtists[index].name[0].toUpperCase(),
                                    style: TextStyle(
                                        color: amber,
                                        fontSize: 24
                                    ),
                                  ),
                                ),
                              );
                            }
                            return CircleAvatar(
                              backgroundColor: Colors.transparent,
                              backgroundImage: MemoryImage(
                                snapshot.data,
                              ),
                              radius: MediaQuery.of(context).size.width*0.15,
                            );
                          },
                        ) else Container(
                          height: MediaQuery.of(context).size.width*0.3,
                          width: MediaQuery.of(context).size.width*0.3,
                          decoration: BoxDecoration(
                              color: grey,
                              borderRadius: BorderRadius.circular(180)
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Text(
                          audioProvider.allArtists[index].name,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16.0,
                              color: amber
                          ),
                        ),
                        SizedBox(height: 5.0,),
                        Text(
                          "Albums : " + audioProvider.allArtists[index].numberOfAlbums.toLowerCase(),
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              color: white
                          ),
                        ),
                        SizedBox(height: 5.0,),
                        Text("Songs : " + audioProvider.allArtists[index].numberOfTracks),
                      ],
                    ),
                  ),
                );
              },
            );
          }
      ),
    );
  }
}
