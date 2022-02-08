import 'package:double_back_to_close/double_back_to_close.dart';
import 'package:flutter/material.dart';
import 'package:mutumbu/utils/colors.dart';
import 'package:mutumbu/views/pages/AlbumsListPage.dart';
import 'package:mutumbu/views/pages/ArtistsListPage.dart';
import 'package:mutumbu/views/pages/AudiosListPage.dart';
import 'package:mutumbu/views/pages/PlaylistsListPage.dart';


class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  PageController pageController = new PageController();
  int currentPageIndex = 0;

  void onTap (int page){
    setState(() {
      currentPageIndex = page;
    });
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {
    return DoubleBack(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: black,
            elevation: 1,
            title: Text(
              "Mutumbu",
              style: TextStyle(
                color: amber,
                shadows: [
                  Shadow(
                      color: amber,
                      blurRadius: 3.0
                  ),
                ],
              ),
            ),
          ),
          body: PageView(
            onPageChanged: (index){
              setState(() {
                currentPageIndex = index;
              });
            },
            controller: pageController,
            children: [
              AudiosListPage(),
              AlbumsListPage(),
              ArtistsListPage(),
              PlaylistsListPage()
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
              onTap: onTap,
              currentIndex: currentPageIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: grey,
              selectedItemColor: black,
              unselectedItemColor: amber,
              iconSize: 24.0,
              selectedFontSize: 10.0,
              unselectedFontSize: 12.0,
              showUnselectedLabels: false,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.music_note_rounded),
                    label: 'Audio'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.album_rounded),
                    label: 'Album'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.account_box_rounded),
                    label: 'Artist'
                ),
                BottomNavigationBarItem(
                    icon: Icon(Icons.playlist_play),
                    label: 'Playlist'
                ),
              ]
          ),
        )
    );
  }
}
