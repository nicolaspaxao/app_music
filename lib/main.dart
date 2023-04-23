import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/core/dip/dependency_injection.dart';
import 'package:music_app/features/music/pages/audio_player_page.dart';
import 'package:permission_handler/permission_handler.dart';

import 'features/home/pages/home_page.dart';

Future<void> main() async {
  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );
  await _requestPermissions();
  DepedencyInjection.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Music App',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.transparent,
        ),
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      getPages: pages,
      initialRoute: pages.first.name,
    );
  }
}

abstract class Routes {
  static String home = '/';
  static String audioMusic = '/audio-music';
}

final pages = <GetPage>[
  GetPage(
    name: Routes.home,
    page: () => const HomePage(),
  ),
  GetPage(
    name: Routes.audioMusic,
    page: () => const AudioPlayerPage(),
    transition: Transition.downToUp,
  ),
];

Future<void> _requestPermissions() async {
  if (Platform.isAndroid) {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
    if (await Permission.notification.status.isDenied) {
      await Permission.notification.request();
    }
    if (await Permission.requestInstallPackages.status.isDenied) {
      await Permission.requestInstallPackages.request();
    }
  } else {}
}
