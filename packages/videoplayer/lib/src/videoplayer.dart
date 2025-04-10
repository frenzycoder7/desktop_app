import 'package:flutter/material.dart';
import 'package:videoplayer/src/exo_player/exo_video_player.dart';
import 'package:videoplayer/src/vdo_cipher/vdo_cipher_player.dart';
import 'package:videoplayer/videoplayer.dart';

/// Video-Player to play video using [url] of type m3u8, mpd etc.
class VisionVideoPlayer extends StatefulWidget {
  /// vdo-cipher video info
  final EmbedInfo? videoInfo;

  /// exo-player video url
  final String? videoUrl;

  /// Builds the widget below this [builder].
  final Widget Function(BuildContext, Widget) builder;

  /// on controller change callback
  final Function(dynamic)? onControllerChange;

  const VisionVideoPlayer({
    super.key,
    this.videoInfo,
    this.videoUrl,
    this.onControllerChange,
    required this.builder,
  }) : assert(videoUrl != null || videoInfo != null);

  @override
  State<StatefulWidget> createState() => VisionVideoPlayerState();
}

class VisionVideoPlayerState extends State<VisionVideoPlayer> {
  late bool _isAutoPlay;
  final ValueNotifier<bool> _fullScreenNotifier = ValueNotifier(false);
  dynamic _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _isAutoPlay = true;
    if (widget.videoUrl != null) initializeController();
  }

  Future<void> initializeController() async {
    _videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(widget.videoUrl!),
      videoPlayerOptions: VideoPlayerOptions(
        mixWithOthers: true,
      ),
    );

    await _videoPlayerController!.initialize();
    widget.onControllerChange?.call(_videoPlayerController);
  }

  /// Note vdo-Cipher handles full screen itself.
  /// So, we don't update fullScreenNotifier for it.
  @override
  Widget build(BuildContext context) {
    final player = _getPlayer();

    return VisibilityDetector(
      key: const Key("visibility_key"),
      onVisibilityChanged: (VisibilityInfo info) {
        if (info.visibleFraction == 0) {
          _videoPlayerController?.pause();
        } else if (_isAutoPlay) {
          _videoPlayerController?.play();
          setState(() => _isAutoPlay = false);
        }
      },
      child: ValueListenableBuilder(
          valueListenable: _fullScreenNotifier,
          builder: (context, value, child) {
            return !_fullScreenNotifier.value
                ? widget.builder(context, player)
                : player;
          }),
    );
  }

  // gives video player as per input video value
  Widget _getPlayer() {
    return widget.videoInfo != null
        ? VdoCipherPlayer(
            videoInfo: widget.videoInfo!,
            fullScreenNotifier: _fullScreenNotifier,
            onControllerChange: _updateController,
          )
        : ExoVideoPlayer(
            videoPlayerController: _videoPlayerController,
            fullScreenNotifier: _fullScreenNotifier,
            onControllerChange: _updateController,
          );
  }

  // update video controller and send back callback
  void _updateController(dynamic controller) {
    setState(() => _videoPlayerController = controller);
    widget.onControllerChange?.call(_videoPlayerController);
  }

  @override
  void dispose() {
    _fullScreenNotifier.dispose();
    _videoPlayerController?.dispose();
    _videoPlayerController = null;
    super.dispose();
  }
}
