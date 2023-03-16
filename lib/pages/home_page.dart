import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m4m/pages/search_page.dart';
import 'package:m4m/pages/tabs/all_songs.dart';
import 'package:m4m/pages/tabs/liked_songs_screen.dart';
import 'package:m4m/pages/tabs/recently_played.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../dataBase/models/songdb.dart';
import '../widgets/menu_items.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.rateMyApp,
  });
  final RateMyApp rateMyApp;

  @override
  State<HomePage> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomePage> {
  final audioPlayer = AssetsAudioPlayer.withId('0');

  TextEditingController searchController = TextEditingController();
  List<Songs> audioList = [];
  Box<Songs> songBox = Hive.box<Songs>('Songs');
  List<Songs> foundSongs = [];

  @override
  void initState() {
    final List<int> keys = songBox.keys.toList().cast<int>();
    for (var key in keys) {
      audioList.add(songBox.get(key)!);
    }
    foundSongs = audioList;
    super.initState();
  }

  bool _isGridMode = false;

  void toggleViewMode() {
    setState(() {
      _isGridMode = !_isGridMode;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('isDarkMode');
    final darkMode = box.get('isDarkMode', defaultValue: false);
    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.clear),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                box.put('isDarkMode', !darkMode);
                              });
                            },
                            icon: Icon(
                              darkMode ? Icons.light_mode : Icons.dark_mode,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                buildMenuItems(
                  context: context,
                  rateMyApp: widget.rateMyApp,
                ),
              ],
            ),
          ),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              pinned: true,
              actions: [
                IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate: SearchSongs(
                        audioList: audioList,
                        audioPlayer: audioPlayer,
                      ),
                    );
                  },
                  icon: const Icon(Icons.search),
                ),
                PopupMenuButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: TextButton.icon(
                        onPressed: toggleViewMode,
                        icon: Icon(
                          _isGridMode ? Icons.list : Icons.grid_view,
                        ),
                        label: _isGridMode
                            ? const Text('List View')
                            : const Text('Grid View'),
                      ),
                    ),
                  ],
                ),
              ],
              floating: true,
              bottom: const TabBar(
                labelStyle:
                    TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                unselectedLabelStyle:
                    TextStyle(fontSize: 10, fontWeight: FontWeight.normal),
                isScrollable: true,
                tabs: [
                  Tab(text: "All Songs"),
                  Tab(text: "Favorites"),
                  Tab(text: "Recently Played"),
                ],
              ),
            ),
          ],
          body: TabBarView(
            children: [
              AllSongs(
                foundSongs: foundSongs,
                isGridMode: _isGridMode,
              ),
              FavoriteSongsScreen(isGridMode: _isGridMode),
              RecentlyPlayed(isGridMode: _isGridMode),
            ],
          ),
        ),
      ),
    );
  }

  void rateMyAppAlert() {
    if (widget.rateMyApp.shouldOpenDialog) {
      widget.rateMyApp.showRateDialog(
        context,
        message: 'give five star do nothing',
        noButton: 'NEVER',
        laterButton: 'LATER',
        dialogStyle: const DialogStyle(
            titleStyle: TextStyle(
          color: Colors.orange,
        )),
        onDismissed: () => widget.rateMyApp.callEvent(
          RateMyAppEventType.laterButtonPressed,
        ),
      );
    }
  }
}
