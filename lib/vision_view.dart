import 'package:flutter/material.dart';
import 'package:videoplayer/videoplayer.dart';

class VisionVideo extends StatefulWidget {
  const VisionVideo({super.key, required this.url});

  final String url;

  @override
  State<VisionVideo> createState() => _VisionVideoState();
}

class _VisionVideoState extends State<VisionVideo> {
  late VideoPlayerController controller;

  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.networkUrl(Uri.parse(widget.url));
    controller.initialize().then((value) => setState(() {}));
    controller.setLooping(true);
    controller.setVolume(1.0);
    controller.play();
  }

  @override
  Widget build(BuildContext context) {
    return VideoPlayer(controller);
  }
}
