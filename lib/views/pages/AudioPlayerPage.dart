// @dart=2.9

import 'package:flutter/material.dart';
import 'package:mutumbu/provider/AudioProvider.dart';
import 'package:mutumbu/utils/colors.dart';
import 'package:provider/provider.dart';


class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({Key key}) : super(key: key);

  @override
  _AudioPlayerPageState createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Slider(
              value: audioProvider.player.position.inSeconds.toDouble(),
              onChanged: (value){
                audioProvider.listenToDuration(value);
              },
              activeColor: amber,
              inactiveColor: grey,
              min: 0.0,
              max: audioProvider.player.duration == null ? 4.0 : audioProvider.player.duration.inSeconds.toDouble(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: (){},
                icon: Icon(
                    Icons.refresh_rounded
                ),
                color: amber,
              ),
              IconButton(
                onPressed: (){
                  audioProvider.playPrevious();
                },
                icon: Icon(
                  Icons.skip_previous_rounded,
                  size: 48,
                ),
                color: amber,
              ),
              IconButton(
                  onPressed: (){
                    audioProvider.player.playing ? audioProvider.pause() : audioProvider.continuePlay();
                  },
                  icon: Icon(
                    audioProvider.player.playing ? Icons.pause_circle_filled_rounded : Icons.play_circle_filled_rounded,
                    size: 52,
                    color: amber,
                  )
              ),
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
              IconButton(
                onPressed: (){},
                icon: Icon(
                    Icons.playlist_add
                ),
                color: amber,
              ),
           ],
          ),
          SizedBox(height: 15.0,),
        ],
      ),
    );
  }
}
