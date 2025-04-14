import 'package:flutter/material.dart';
import 'package:videoplayer/videoplayer.dart';
import 'dart:io';

void main() {
  String dir = Directory.current.path;
  Process.run('powershell', [
    'Add-AppxPackage',
    '-Path',
    '$dir/codec/av1-video-extension-1-3-4-0.appxbundle'
  ]).then((value) {
    if (value.exitCode == 0) {
      debugPrint("installation success");
    } else {
      debugPrint("installation failed");
    }
  });
  runApp(const PlayerView());
}

class PlayerView extends StatefulWidget {
  const PlayerView({super.key});

  @override
  State<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends State<PlayerView> {
  String videoURL = "";

  clearURL() {
    videoURL = "";
    setState(() {});
  }

  bool get shouldShowPlayer => videoURL.isNotEmpty;

  TextEditingController urlController = TextEditingController();

  void setURL(String url) {
    videoURL = url;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Video Player",
      home: Scaffold(
        body: shouldShowPlayer
            ? ViewPlayerView(url: videoURL, clear: clearURL)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "VisionPlayer",
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text("Copy & Paste your video URL to play",
                      style: TextStyle(
                        color: Colors.blueGrey.withOpacity(0.5),
                        fontSize: 15,
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: SizedBox(
                      height: 80,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Enter Video URL",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide:
                                      const BorderSide(color: Colors.blue),
                                ),
                              ),
                              controller: urlController,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              if (urlController.text.isNotEmpty &&
                                  (urlController.text.contains("http") ||
                                      urlController.text.contains("https"))) {
                                clearURL();
                                setURL(urlController.text);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Please enter a URL"),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              margin: const EdgeInsets.only(left: 10),
                              child: const Text(
                                "Play Video",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

class ViewPlayerView extends StatelessWidget {
  const ViewPlayerView({super.key, required this.url, required this.clear});
  final String url;
  final Function clear;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Video Player",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                InkWell(
                  onTap: () {
                    clear();
                  },
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: 500,
            width: double.infinity,
            child: VisionVideoPlayer(
              builder: (context, child) {
                return child;
              },
              onControllerChange: (p0) {},
              videoUrl: url,
            ),
          )
        ],
      ),
    );
  }
}
