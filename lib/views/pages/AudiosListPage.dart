import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mutumbu/provider/AudioProvider.dart';
import 'package:mutumbu/utils/colors.dart';
import 'package:mutumbu/views/pages/AudioPlayerPage.dart';
import 'package:provider/provider.dart';


class AudiosListPage extends StatefulWidget {
  const AudiosListPage({Key? key}) : super(key: key);

  @override
  _AudiosListPageState createState() => _AudiosListPageState();
}

class _AudiosListPageState extends State<AudiosListPage> {
  @override
  Widget build(BuildContext context) {
    AudioProvider audioProvider = Provider.of<AudioProvider>(context);
    return Scaffold(
      backgroundColor: black,
      body: Stack(
        children: [
          FutureBuilder(
              future: audioProvider.getAllSongs(),
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
                    itemCount: audioProvider.allSongs.length,
                    itemBuilder: (_, index){
                      return ListTile(
                        onTap: (){
                          audioProvider.setCurrentIndex(index);
                          audioProvider.playSong();
                          print(audioProvider.allSongs[index]);
                        },
                        title: Text(
                          audioProvider.allSongs[index].title,
                          style: TextStyle(
                              color: index ==audioProvider.currentIndex ? amber : white
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          audioProvider.allSongs[index].artist.toString(),
                          style: TextStyle(
                              color: grey
                          ),
                        ),
                        trailing: index == audioProvider.currentIndex ? Icon(Icons.music_note_rounded, color: amber,) : null,
                      );
                    }
                );
              }
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              color: grey.withOpacity(0.75),
              height: 60.0,
              padding: EdgeInsets.only(bottom: 11.0),
              child: Row(
                children: [
                  /*IconButton(
                    onPressed: (){
                      audioProvider.playPrevious();
                    },
                    icon: Icon(
                      Icons.skip_previous_rounded,
                      size: 48,
                    ),
                    color: amber,
                  ),*/
                  IconButton(
                      onPressed: (){
                        audioProvider.player.playing ? audioProvider.pause() : audioProvider.continuePlay();
                      },
                      icon: Icon(
                        audioProvider.player.playing ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                        size: 48,
                        color: amber,
                      )
                  ),
                  SizedBox(width: 10.0,),
                  IconButton(
                    onPressed: (){
                      audioProvider.playNext();
                    },
                    icon: Icon(
                      Icons.skip_next_rounded,
                      size: 48,
                    ),
                    color: amber,
                  ),
                  SizedBox(width: 10.0,),
                  Expanded(
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, new MaterialPageRoute(builder: (context) => AudioPlayerPage()));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 14),
                          Text(
                            audioProvider.allSongs.isNotEmpty ? audioProvider.allSongs[audioProvider.currentIndex].title : "Recherche...",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: amber,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            audioProvider.allSongs.isNotEmpty ? audioProvider.allSongs[audioProvider.currentIndex].artist.toString() : "Recherche...",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: white,
                              fontSize: 14,
                            ),
                          )
                        ],
                      ),
                    )
                  )
                ],
              ),
            )
          )
        ]
      ),
    );
  }
}
