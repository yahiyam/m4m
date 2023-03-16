// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'db_functions.dart';
import '../models/songdb.dart';

class PlaylistFunctions {
  static playlistCreateAlertBox({required context}) {
    final TextEditingController textEditingController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    Box<List> playlistBox = getPlaylistBox();
    Future<void> createNewPlaylist() async {
      List<Songs> songList = [];
      final String playlistName = textEditingController.text.trim();
      String message;
      message = playlistName.length <= 35
          ? 'Added $playlistName'
          : 'Added ${playlistName.substring(0, 35)}';
      if (playlistName.isEmpty) {
        return;
      } else {
        await playlistBox.put(playlistName, songList);
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.success(
            message: message,
          ),
          dismissType: DismissType.onSwipe,
        );
      }
    }

    return showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            title: const Text('Add New Playlist'),
            content: TextFormField(
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: 'Enter playlist name',
                suffix: IconButton(
                  onPressed: () => textEditingController.clear(),
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                ),
              ),
              validator: (value) {
                final keys = getPlaylistBox().keys.toList();
                if (value == null || value.isEmpty) {
                  return 'Please enter a playlist name';
                }
                if (keys.contains(value)) {
                  return '$value already exists in playlist';
                }
                return null;
              },
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel')),
              TextButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    await createNewPlaylist();
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Confirm',
                  style: TextStyle(color: Colors.green),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static playlistDeleteFunction(
      {required context, required String playlistName}) {
    Box<List> playlistBox = getPlaylistBox();
    Future<void> deletePlaylist({required String playlistName}) async {
      playlistBox.delete(playlistName);
      Navigator.pop(context);
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.info(
          backgroundColor: Colors.grey,
          message: 'Deleted $playlistName ',
        ),
        dismissType: DismissType.onSwipe,
      );
    }

    String messege = 'Are you sure you want to delete $playlistName playlist?';
    String bold = playlistName;
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete playlist?'),
          content: RichText(
            text: TextSpan(
              style: DefaultTextStyle.of(context).style,
              children: [
                TextSpan(text: messege.substring(0, messege.indexOf(bold))),
                TextSpan(
                  text: bold,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(
                  text: messege.substring(
                    messege.indexOf(bold) + bold.length,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await deletePlaylist(playlistName: playlistName);
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  static playlistEditFunction({
    required BuildContext context,
    required List<Songs> songs,
    required String playlistName,
  }) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController editcontroller = TextEditingController();
    Box<List> playlistBox = getPlaylistBox();
    Future editPlaylist({
      required String playlistName,
      required List<Songs> playlistSongList,
      required String oldPlaylistName,
    }) async {
      playlistBox.put(playlistName, playlistSongList);
      playlistBox.delete(oldPlaylistName);
      Navigator.pop(context);
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.success(
          message: 'Edited $oldPlaylistName to $playlistName ',
        ),
        dismissType: DismissType.onSwipe,
      );
    }

    return showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            title: const Text('Edit Playlist'),
            content: TextFormField(
              // initialValue: playlistName,
              controller: editcontroller,
              decoration: InputDecoration(
                hintText: playlistName,
                suffix: IconButton(
                  onPressed: () => editcontroller.clear(),
                  icon: const Icon(
                    Icons.clear,
                    color: Colors.red,
                  ),
                ),
              ),
              validator: (value) {
                final keys = getPlaylistBox().keys.toList();
                if (value == null || value.isEmpty) {
                  return 'Please enter a playlist name';
                }
                if (value == playlistName) {
                  return 'Please enter another name';
                }
                if (keys.contains(value)) {
                  return '$value already exists in playlist';
                }
                return null;
              },
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    editPlaylist(
                      playlistName: editcontroller.text.trim(),
                      playlistSongList: songs,
                      oldPlaylistName: playlistName,
                    );
                  }
                },
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
