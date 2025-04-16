import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../utils/constants.dart';

/// Allow user to change the video playback speed.
class PlaybackSpeedSheet extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  const PlaybackSpeedSheet({
    super.key,
    required this.videoPlayerController,
  });

  @override
  State<StatefulWidget> createState() => PlaybackSpeedSheetState();
}

class PlaybackSpeedSheetState extends State<PlaybackSpeedSheet> {
  final speedListTitle = ["0.5x", "0.75x", "Normal", "1.25x", "1.5x"];
  final speedList = [0.5, 0.75, 1.0, 1.25, 1.5];

  @override
  Widget build(BuildContext context) {
    var selectedIndex =
        speedList.indexOf(widget.videoPlayerController.value.playbackSpeed);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 5, top: 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                Strings.playbackSpeed,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w400, fontSize: 12),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.13,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(
                speedListTitle.length,
                (index) {
                  return Expanded(
                    flex: isFirstOrLast(index) ? 2 : 3,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // line
                        if (index != 0)
                          Expanded(
                            child: Container(
                              height: 6,
                              width: double.infinity,
                              color: Theme.of(context)
                                  .disabledColor
                                  .withAlpha(200),
                            ),
                          ),

                        // icon + speed text
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(height: 45),
                            if (selectedIndex == index)
                              // const DotIndicator(
                              //   size: 6,
                              //   color: WidgetColors.darkGray,
                              //   child: Icon(
                              //     Icons.check,
                              //     color: Colors.white,
                              //     size: 3,
                              //   ),
                              // ),
                              if (selectedIndex != index)
                                // IconButton(
                                //   padding: EdgeInsets.zero,
                                //   constraints:
                                //       BoxConstraints.tight(const Size(4, 4)),
                                //   icon: const OutlinedDotIndicator(
                                //     color: WidgetColors.darkGray,
                                //     borderWidth: 1,
                                //   ),
                                //   onPressed: () {
                                //     setState(() {
                                //       widget.videoPlayerController
                                //           .setPlaybackSpeed(speedList[index]);
                                //     });
                                //   },
                                // ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 1),
                                  child: Text(
                                    speedListTitle[index],
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: index == selectedIndex
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: index == selectedIndex
                                          ? Theme.of(context)
                                              .colorScheme
                                              .primary
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurface,
                                    ),
                                  ),
                                )
                          ],
                        ),

                        // line
                        if (index != speedListTitle.length - 1)
                          Expanded(
                            child: Container(
                              height: 6,
                              width: double.infinity,
                              color: Theme.of(context)
                                  .disabledColor
                                  .withAlpha(200),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  bool isFirstOrLast(int index) =>
      (index == 0 || index == speedListTitle.length - 1);
}
