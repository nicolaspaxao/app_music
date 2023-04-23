import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/core/controllers/audio_controller.dart';
import 'package:music_app/core/dip/dependency_injection.dart';

import 'widgets/audio_controls_widget.dart';
import 'widgets/media_meta_data_widget.dart';

class AudioPlayerPage extends StatefulWidget {
  const AudioPlayerPage({super.key});

  @override
  State<AudioPlayerPage> createState() => _AudioPlayerPageState();
}

class _AudioPlayerPageState extends State<AudioPlayerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          splashRadius: 22,
          padding: EdgeInsets.zero,
          onPressed: () => Get.back(),
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 18,
          ),
        ),
        title: const Text(
          'Tocando da sua playlist',
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.more_vert,
              size: 18,
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<SequenceState?>(
                stream: audioCtrl.audioPlayer.sequenceStateStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  if (state?.sequence.isEmpty ?? true) {
                    return const SizedBox();
                  }
                  final metadata = state!.currentSource!.tag as MediaItem;
                  return MediaMetaData(
                    imageUrl: metadata.artUri.toString(),
                    title: metadata.title,
                    artist: metadata.artist ?? '',
                  );
                },
              ),
              const SizedBox(height: 20),
              StreamBuilder(
                stream: audioCtrl.positionDataStream,
                builder: (context, snapshot) {
                  final positionData = snapshot.data;
                  return ProgressBar(
                    barHeight: 4,
                    thumbGlowRadius: 20,
                    thumbRadius: 6,
                    thumbColor: Colors.red,
                    progressBarColor: Colors.red,
                    bufferedBarColor: Colors.grey,
                    baseBarColor: Colors.grey[600],
                    timeLabelTextStyle: const TextStyle(color: Colors.white),
                    progress: positionData?.position ?? Duration.zero,
                    buffered: positionData?.bufferedPosition ?? Duration.zero,
                    total: positionData?.duration ?? Duration.zero,
                    onSeek: audioCtrl.audioPlayer.seek,
                  );
                },
              ),
              GetBuilder<AudioController>(
                builder: (_) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => audioCtrl.setShuffle(),
                        icon: Icon(
                          Icons.shuffle_rounded,
                          size: 24,
                          color: audioCtrl.isShuffle.value
                              ? Colors.greenAccent
                              : Colors.white,
                        ),
                      ),
                      ControlsWidget(audioPlayer: audioCtrl.audioPlayer),
                      IconButton(
                        onPressed: () => audioCtrl.setLoop(),
                        icon: Icon(
                          Icons.loop_rounded,
                          size: 24,
                          color: audioCtrl.isLoopOne.value
                              ? Colors.greenAccent
                              : Colors.white,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
