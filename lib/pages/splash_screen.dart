// ignore_for_file: use_build_context_synchronously

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:m4m/dataBase/functions/song_access.dart';
import 'package:m4m/pages/home_page.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../widgets/rate_app_init_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SongAccess songAccess = SongAccess();
  final OnAudioQuery _audioQuery = OnAudioQuery();

  @override
  void initState() {
    requestStoragePermissions();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3B1F50),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Connect Music",
                  style: TextStyle(color: Colors.white)),
              const Text("with", style: TextStyle(color: Colors.white)),
              TextLiquidFill(
                text: 'M4MUSIC',
                waveColor: Colors.white,
                boxBackgroundColor: const Color(0xFF3B1F50),
                textStyle: const TextStyle(
                  fontSize: 50.0,
                  fontWeight: FontWeight.bold,
                ),
                boxHeight: 100.0,
                boxWidth: 250,
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<void> requestStoragePermissions() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        bool request = await _audioQuery.permissionsRequest();
        if (request) {
          await songAccess.accessSongs();
          goToSreenHome(context);
        } else {
          await requestStoragePermissions();
        }
      } else {
        await songAccess.accessSongs();
        goToSreenHome(context);
      }
      setState(() {});
    }
  }

  Future<void> goToSreenHome(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 7));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return RateAppInitWidget(
            builder: (rateMyApp) {
              return HomePage(rateMyApp: rateMyApp);
            },
          );
        },
      ),
    );
  }
}
