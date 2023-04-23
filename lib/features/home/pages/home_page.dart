import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:music_app/core/dip/dependency_injection.dart';
import 'package:music_app/main.dart';
import 'package:music_app/utils/playlist.dart';

import '../../../core/controllers/audio_controller.dart';
import '../../music/pages/widgets/audio_controls_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    audioCtrl.hasPlaylistToPlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        toolbarHeight: kToolbarHeight + 32,
        title: const Text(
          'Sua playlist',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person),
          ),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: const Icon(
              Icons.search,
            ),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: GetBuilder<AudioController>(
        builder: (_) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                  itemCount: audioList.length,
                  separatorBuilder: (context, index) {
                    return Divider(
                      thickness: 2,
                      color: Colors.white.withOpacity(0.2),
                    );
                  },
                  itemBuilder: (context, index) {
                    final audio = audioList[index];
                    return ListTile(
                      leading: AspectRatio(
                        aspectRatio: 2 / 1.5,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl: audio.artUri,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      title: Text(
                        audio.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Text(
                        audio.artist,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      trailing: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () async => audioCtrl.playSound(index),
                        icon: const Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 90),
              ],
            ),
          );
        },
      ),
      bottomSheet: GetBuilder<AudioController>(
        builder: (_) {
          return AnimatedCrossFade(
            crossFadeState: audioCtrl.isPlaying.value
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 500),
            reverseDuration: const Duration(milliseconds: 500),
            firstChild: const ShortcutAudioControls(),
            secondChild: const SizedBox(
              width: double.infinity,
            ),
          );
        },
      ),
    );
  }
}

class ShortcutAudioControls extends StatelessWidget {
  const ShortcutAudioControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => Get.toNamed(Routes.audioMusic),
          child: Ink(
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      StreamBuilder<SequenceState?>(
                        stream: audioCtrl.audioPlayer.sequenceStateStream,
                        builder: (context, snapshot) {
                          final state = snapshot.data;
                          if (state?.sequence.isEmpty ?? true) {
                            return const SizedBox();
                          }
                          final metadata =
                              state!.currentSource!.tag as MediaItem;
                          return Expanded(
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(6),
                                  child: CachedNetworkImage(
                                    imageUrl: metadata.artUri.toString(),
                                    height: 35,
                                    width: 35,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        metadata.title,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                      Text(
                                        metadata.artist!,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w300,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      ControlsWidget(
                        audioPlayer: audioCtrl.audioPlayer,
                        iconSize: 30,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  StreamBuilder(
                    stream: audioCtrl.positionDataStream,
                    builder: (context, snapshot) {
                      final positionData = snapshot.data;
                      return ProgressBar(
                        timeLabelPadding: 0,
                        timeLabelLocation: TimeLabelLocation.none,
                        barHeight: 2,
                        thumbRadius: 2,
                        thumbColor: Colors.white,
                        thumbGlowRadius: 10,
                        progressBarColor: Colors.white,
                        bufferedBarColor: Colors.grey[60],
                        baseBarColor: Colors.grey,
                        progress: positionData?.position ?? Duration.zero,
                        buffered:
                            positionData?.bufferedPosition ?? Duration.zero,
                        total: positionData?.duration ?? Duration.zero,
                        onSeek: audioCtrl.audioPlayer.seek,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
