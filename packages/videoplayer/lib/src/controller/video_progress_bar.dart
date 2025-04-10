import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoProgressBar extends StatefulWidget {
  final VideoPlayerController controller;
  const VideoProgressBar({super.key, required this.controller});

  @override
  State<VideoProgressBar> createState() => _VideoProgressBarState();
}

class _VideoProgressBarState extends State<VideoProgressBar>{
  int _progress = 0, _totalDuration = 1;
  final _playedColor = const Color(0xFF407BFF),
      _backgroundColor = const Color(0xFF868383);

  @override
  void initState() {
    super.initState();
    int totalDuration = widget.controller.value.duration.inSeconds;
    _totalDuration = totalDuration > 0 ? totalDuration : -1;
    _progress = widget.controller.value.position.inSeconds;
    widget.controller.addListener(_updateProgress);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateProgress);
    super.dispose();
  }

  void _updateProgress() {
    setState(() {
      _progress = widget.controller.value.position.inSeconds;
    });
  }

  void seekToRelativePosition(Offset globalPosition) {
    final RenderBox box = context.findRenderObject()! as RenderBox;
    final Offset tapPos = box.globalToLocal(globalPosition);
    final double relative = tapPos.dx / box.size.width;
    final Duration position = widget.controller.value.duration * relative;
    widget.controller.seekTo(position);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var progress = size.width*(_progress/_totalDuration);

    if(_totalDuration <= 0) {
      return const SizedBox();
    }

    return GestureDetector(
      onHorizontalDragStart: (details) {
        if (!widget.controller.value.isInitialized) {
          return;
        }
        if (widget.controller.value.isPlaying) {
          widget.controller.pause();
        }
      },
      onHorizontalDragUpdate: (details) {
        if (!widget.controller.value.isInitialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
      onHorizontalDragEnd: (details) {
        if (!widget.controller.value.isInitialized) {
          return;
        }
        if (widget.controller.value.position
            != widget.controller.value.duration) {
          widget.controller.play();
        }
      },
      onTapDown: (details) {
        if (!widget.controller.value.isInitialized) {
          return;
        }
        seekToRelativePosition(details.globalPosition);
      },
      child: Container(
        height: 25,
        padding: const EdgeInsets.symmetric(vertical: 5),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10),
              width: size.width,
              height: 5,
              color: _backgroundColor,
            ),
            Container(
              margin: EdgeInsets.only(
                top: 5,
                left: progress > 8 ? progress-5 : progress,
              ),
              child: Icon(
                Icons.circle,
                size: 15,
                color: _playedColor,
              ),
            ),
            Container(
              width: progress,
              height: 5,
              margin: const EdgeInsets.only(top: 10),
              color: _playedColor,
            ),
          ],
        ),
      ),
    );
  }
}
