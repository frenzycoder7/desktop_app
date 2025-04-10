import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:videoplayer/src/controller/playback_speed_sheet.dart';
import 'package:videoplayer/src/controller/play_pause_button.dart';
import 'package:videoplayer/src/controller/video_progress_bar.dart';
import 'package:videoplayer/src/utils/constants.dart';

/// Exo-Player to play video using [url] of type EmbedInfo.
class ExoVideoPlayer extends StatefulWidget {
  /// video info
  final VideoPlayerController videoPlayerController;

  /// on controller change callback
  final Function(dynamic)? onControllerChange;

  /// full screen notifier
  final ValueNotifier<bool> fullScreenNotifier;

  const ExoVideoPlayer({
    super.key,
    required this.videoPlayerController,
    required this.fullScreenNotifier,
    this.onControllerChange,
  });

  @override
  State<StatefulWidget> createState() => ExoVideoPlayerState();
}

class ExoVideoPlayerState extends State<ExoVideoPlayer> {
  late bool _videoControllerVisibility;
  VideoPlayerController? _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoControllerVisibility = false;
    _videoPlayerController = widget.videoPlayerController;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final aspectRatio = widget.fullScreenNotifier.value
        ? (size.longestSide / size.shortestSide)
        : 16 / 9;

    return WillPopScope(
      onWillPop: () async {
        if (widget.fullScreenNotifier.value) {
          await _setOrientation(context);
          await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
              overlays: SystemUiOverlay.values); // to re-show bars
        }
        return false;
      },
      child: Material(
        child: AspectRatio(
          aspectRatio: aspectRatio,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Stack(
              fit: !widget.fullScreenNotifier.value
                  ? StackFit.loose
                  : StackFit.expand,
              children: [
                // watermark and videoView widget
                VideoPlayer(_videoPlayerController!),

                // video view controls
                _videoPlayerController == null
                    ? const Center(child: CircularProgressIndicator())
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 50),
                        reverseDuration: const Duration(milliseconds: 200),
                        child: _videoControllerVisibility
                            ? Container(
                                color: Colors.black26,
                                child: Stack(
                                  alignment: Alignment.bottomCenter,
                                  children: [
                                    // play pause btn and 10 sec seek btns
                                    Align(
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          // seek backward
                                          InkWell(
                                            onTap: () {
                                              if (widget.videoPlayerController
                                                      .value.isInitialized !=
                                                  true) {
                                                return;
                                              }
                                              Duration currDuration = widget
                                                  .videoPlayerController
                                                  .value
                                                  .position;
                                              Duration newDuration =
                                                  currDuration -
                                                      const Duration(
                                                          seconds: 10);
                                              widget.videoPlayerController
                                                  .seekTo(newDuration);
                                            },
                                            child: const Icon(
                                              Icons.replay_10_outlined,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                          ),

                                          // play pause btn
                                          PlayPauseButton(
                                              videoPlayerController:
                                                  _videoPlayerController!),

                                          // seek forward
                                          InkWell(
                                            onTap: () {
                                              if (widget.videoPlayerController
                                                      .value.isInitialized !=
                                                  true) {
                                                return;
                                              }
                                              Duration currDuration = widget
                                                  .videoPlayerController
                                                  .value
                                                  .position;
                                              Duration newDuration =
                                                  currDuration +
                                                      const Duration(
                                                          seconds: 10);
                                              widget.videoPlayerController
                                                  .seekTo(newDuration);
                                            },
                                            child: const Icon(
                                              Icons.forward_10_outlined,
                                              size: 40,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // settings btn
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          // IconButton(
                                          //     onPressed: () {
                                          //
                                          //     },
                                          //     icon: SvgPicture.asset(PlayerIcons.cast)
                                          // ),
                                          // IconButton(
                                          //     onPressed: () {
                                          //
                                          //     },
                                          //     icon: SvgPicture.asset(PlayerIcons.cc)
                                          // ),
                                          // IconButton(
                                          //     onPressed: () {
                                          //       showModalBottomSheet(
                                          //           context: context,
                                          //           builder: (ctx) =>
                                          //               PlaybackSpeedSheet(
                                          //                   videoPlayerController:
                                          //                       _videoPlayerController!));
                                          //     },
                                          //     icon: SvgPicture.asset(
                                          //         PlayerIcons.settings,
                                          //         height: context.isTablet
                                          //             ? 2.5.h
                                          //             : null))
                                        ],
                                      ),
                                    ),

                                    // video duration and full screen btn
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(bottom: 2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            // video duration
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 1),
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(4)),
                                                  color: WidgetColors
                                                      .transparentBlack),
                                              child: ValueListenableBuilder(
                                                valueListenable:
                                                    _videoPlayerController!,
                                                builder: (context, value,
                                                        child) =>
                                                    Text(
                                                        _getVideoDurationFormatted(
                                                            value.position),
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodySmall),
                                              ),
                                            ),

                                            // full screen btn
                                            IconButton(
                                                onPressed: () async {
                                                  if (!widget.fullScreenNotifier
                                                      .value) {
                                                    await SystemChrome
                                                        .setEnabledSystemUIMode(
                                                            SystemUiMode.manual,
                                                            overlays: []);
                                                    await SystemChrome
                                                        .setPreferredOrientations([
                                                      DeviceOrientation
                                                          .landscapeLeft,
                                                      DeviceOrientation
                                                          .landscapeRight,
                                                    ]);
                                                  } else {
                                                    await _setOrientation(
                                                        context);
                                                    await SystemChrome
                                                        .setEnabledSystemUIMode(
                                                            SystemUiMode.manual,
                                                            overlays:
                                                                SystemUiOverlay
                                                                    .values); // to re-show bars
                                                  }

                                                  widget.fullScreenNotifier
                                                          .value =
                                                      !widget.fullScreenNotifier
                                                          .value;
                                                },
                                                icon: Icon(
                                                  !widget.fullScreenNotifier
                                                          .value
                                                      ? Icons.fullscreen
                                                      : Icons.fullscreen_exit,
                                                  color: Colors.white,
                                                )),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // progress bar
                                    VideoProgressBar(
                                      controller: _videoPlayerController!,
                                    ),
                                  ],
                                ),
                              )
                            : null,
                      ),
              ],
            ),
            onTap: () {
              setState(() {
                _videoControllerVisibility = !_videoControllerVisibility;
              });
            },
          ),
        ),
      ),
    );
  }

  Future<void> _setOrientation(BuildContext context) async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  _getVideoDurationFormatted(Duration value) {
    var duration = Duration(milliseconds: value.inMilliseconds.round());
    return [
      if (duration.inHours > 0) duration.inHours,
      duration.inMinutes,
      duration.inSeconds
    ].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':');
  }
}
