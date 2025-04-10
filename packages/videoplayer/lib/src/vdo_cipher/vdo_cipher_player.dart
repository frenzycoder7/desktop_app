import 'package:flutter/material.dart';
import 'package:vdocipher_flutter/vdocipher_flutter.dart';

/// Vdo-Cipher-Player to play video using [url] of type EmbedInfo.
class VdoCipherPlayer extends StatelessWidget {
  /// video info
  final EmbedInfo videoInfo;

  /// on controller change callback
  final Function(dynamic)? onControllerChange;

  /// full screen notifier
  final ValueNotifier<bool> fullScreenNotifier;

  const VdoCipherPlayer({
    super.key,
    required this.videoInfo,
    required this.fullScreenNotifier,
    this.onControllerChange,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final aspectRatio = fullScreenNotifier.value
        ? (size.longestSide / size.shortestSide)
        : 16 / 9;

    return Card(
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Stack(
          fit: !fullScreenNotifier.value ? StackFit.loose : StackFit.expand,
          children: [],
        ),
      ),
    );
  }
}
