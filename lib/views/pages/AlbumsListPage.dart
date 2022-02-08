import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mutumbu/provider/AudioProvider.dart';
import 'package:mutumbu/utils/colors.dart';
import 'package:provider/provider.dart';


class AlbumsListPage extends StatefulWidget {
  const AlbumsListPage({Key? key}) : super(key: key);

  @override
  _AlbumsListPageState createState() => _AlbumsListPageState();
}

class _AlbumsListPageState extends State<AlbumsListPage> {
  @override
  Widget build(BuildContext context) {
    AudioProvider audioProvider = Provider.of<AudioProvider>(context);
    return Scaffold(
      backgroundColor: black,
      body: FutureBuilder(
          future: audioProvider.getAllAlbums(),
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
                itemCount: audioProvider.allAlbums.length,
                itemBuilder: (_, index){
                  return ListTile(
                    onTap: (){},
                    leading: Container(
                      height: 20.0,
                      width: 20.0,
                      child: Image.file(
                        File(audioProvider.allAlbums[index].artwork.toString()),
                        height: 20.0,
                        width: 20.0,
                      ),
                    ),
                    title: Text(
                      audioProvider.allAlbums[index].albumName,
                      style: TextStyle(
                          color: white
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      audioProvider.allAlbums[index].artist,
                      style: TextStyle(
                          color: grey
                      ),
                    ),
                  );
                }
            );
          }
      ),
    );
  }
}
