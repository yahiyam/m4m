import 'package:flutter/material.dart';
import 'package:m4m/pages/mostly_played.dart';
import 'package:m4m/pages/playlist_pages/playlists_screen.dart';
import 'package:rate_my_app/rate_my_app.dart';

import '../pages/setting_screen.dart';

Widget buildMenuItems({
  required BuildContext context,
  required RateMyApp rateMyApp,
}) {
  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      children: [
        ListTile(
          leading: const Icon(
            Icons.featured_play_list,
          ),
          title: Text(
            "Playlist",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const PlaylistsScreen(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.local_fire_department_outlined,
          ),
          title: Text(
            "Most Played",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const MostPlayed(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(
            Icons.settings_rounded,
          ),
          title: Text(
            "Settings",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          onTap: () {
            Navigator.pop(context);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => SettingScreen(rateMyApp: rateMyApp),
              ),
            );
          },
        ),
      ],
    ),
  );
}
