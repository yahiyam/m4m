import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:m4m/pages/splash_screen.dart';

import 'dataBase/models/songdb.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  if (!Hive.isAdapterRegistered(SongsAdapter().typeId)) {
    Hive.registerAdapter(SongsAdapter());
  }
  await Hive.openBox<Songs>('Songs');
  await Hive.openBox<List>('Playlist');
  await Hive.openBox('isdarkmode');
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((value) => runApp(const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('isdarkmode').listenable(),
      builder: (context, box, _) {
        var darkMode = box.get('isDarkMode', defaultValue: false);
        return MaterialApp(
          title: 'Audio Player',
          debugShowCheckedModeBanner: false,
          themeMode: darkMode ? ThemeMode.dark : ThemeMode.light,
          darkTheme: ThemeData.dark(useMaterial3: true),
          theme: ThemeData(useMaterial3: true),
          home: const SplashScreen(),
        );
      },
    );
  }
}
