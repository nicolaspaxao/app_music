import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rx;

import '../../utils/playlist.dart';
import '../models/position_data.dart';

class AudioController extends GetxController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  AudioPlayer get audioPlayer => _audioPlayer;

  RxBool isPlaying = false.obs;
  RxBool isShuffle = false.obs;
  RxBool isLoopOne = false.obs;

  Stream<PositionData> get positionDataStream {
    return rx.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
      _audioPlayer.positionStream,
      _audioPlayer.bufferedPositionStream,
      _audioPlayer.durationStream,
      (position, bufferedPosition, duration) => PositionData(
        position,
        bufferedPosition,
        duration ?? Duration.zero,
      ),
    );
  }

  setIsPlaying(bool val) {
    isPlaying.value = val;
    update();
  }

  audioDispose() {
    _audioPlayer.dispose();
  }

  playSound(int index) async {
    if (!hasPlaylistToPlay()) {
      await _audioPlayer.setLoopMode(LoopMode.all);
      setIsPlaying(true);
      _audioPlayer.setAudioSource(playlist, initialIndex: index);
      _audioPlayer.play();
    } else {
      _audioPlayer.setAudioSource(playlist, initialIndex: index);
      _audioPlayer.play();
    }
  }

  setShuffle() async {
    isShuffle.value = !isShuffle.value;
    update();
    if (isShuffle.value) {
      await _audioPlayer.shuffle();
    }

    await _audioPlayer.setShuffleModeEnabled(isShuffle.value);
  }

  setLoop() async {
    isLoopOne.value = !isLoopOne.value;
    update();
    if (isLoopOne.value) {
      await _audioPlayer.setLoopMode(LoopMode.one);
    } else {
      await _audioPlayer.setLoopMode(LoopMode.all);
    }
  }

  bool hasPlaylistToPlay() {
    setIsPlaying(_audioPlayer.audioSource != null);
    debugPrint(_audioPlayer.audioSource != null ? "true" : "false");
    return _audioPlayer.audioSource != null;
  }
}
