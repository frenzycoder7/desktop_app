import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Button to play/pause the video.
class PlayPauseButton extends StatelessWidget {

  final VideoPlayerController videoPlayerController;

  const PlayPauseButton({
    super.key,
    required this.videoPlayerController,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ValueListenableBuilder(
        valueListenable: videoPlayerController,
        builder: (context, VideoPlayerValue value, child) {
          return IconButton(
            color: Colors.white,
            iconSize: 56,
            icon: value.isPlaying
                ? const Icon(Icons.pause_rounded)
                : ( value.isBuffering
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Icon(Icons.play_arrow_rounded)),
            onPressed: () {
             value.isPlaying
                 ? videoPlayerController.pause()
                 : videoPlayerController.play();
            },
          );
        },
      ),
    );
  }
}