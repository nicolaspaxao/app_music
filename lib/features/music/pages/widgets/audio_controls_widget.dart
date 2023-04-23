import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ControlsWidget extends StatelessWidget {
  const ControlsWidget({
    super.key,
    required this.audioPlayer,
    this.iconSize,
    this.color,
  });

  final AudioPlayer audioPlayer;
  final double? iconSize;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: audioPlayer.seekToPrevious,
          icon: Icon(
            Icons.skip_previous_rounded,
            size: iconSize ?? 40,
            color: Colors.white,
          ),
        ),
        StreamBuilder<PlayerState>(
          stream: audioPlayer.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (!(playing ?? false)) {
              return IconButton(
                padding: EdgeInsets.zero,
                onPressed: audioPlayer.play,
                icon: Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: iconSize ?? 50,
                ),
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                padding: EdgeInsets.zero,
                onPressed: audioPlayer.pause,
                icon: Icon(
                  Icons.pause_rounded,
                  color: Colors.white,
                  size: iconSize ?? 50,
                ),
              );
            } else {
              return Icon(
                Icons.play_arrow_rounded,
                color: Colors.white,
                size: iconSize ?? 50,
              );
            }
          },
        ),
        IconButton(
          padding: EdgeInsets.zero,
          onPressed: audioPlayer.seekToNext,
          icon: Icon(
            Icons.skip_next_rounded,
            size: iconSize ?? 40,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
