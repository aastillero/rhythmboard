import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../data/models/config/DeviceConfig.dart';
import '../../utils/FileUtil.dart';
import '../../utils/Preferences.dart';
import 'package:video_player/video_player.dart';

int vidNum = 1;

class Mode3Test extends StatefulWidget {
  @override
  _Mode3TestState createState() => _Mode3TestState();
}

class _Mode3TestState extends State<Mode3Test> {
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  @override
  void dispose() {
    //if(_controller != null) {
    _controller?.dispose();
    //}
    super.dispose();
  }

  Future<void> _initPlayer() async {
    String uri = "http://${DeviceConfig.rpi1}/files/video${vidNum}.mp4";
    print("LINK: $uri");
    if (await FileUtil.isFileExistsInAppDir('uberDisplayVideo${vidNum}.mp4')) {
      File? file = await FileUtil.getVideoFile('uberDisplayVideo${vidNum}.mp4');
      var isDownloaded = await Preferences.getSharedInt("videoDownloaded");
      print("VIDEO FILE: ${file?.path}");
      if (file != null && isDownloaded != null) {
        _controller = VideoPlayerController.file(file)
          ..initialize().then((_) {
            print("VIDEO INITIALIZED");
            setState(() {});
            if (_controller != null) {
              _controller?.play();
              //flickManager?.flickDisplayManager?.hidePlayerControls();
              _controller?.setLooping(true); // Set video to repeat infinitely
            }
          });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: null,
      body: Center(
        child: _controller != null && _controller!.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              )
            : const CircularProgressIndicator(),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if(_controller != null) {
              _controller!.value.isPlaying
                  ? _controller!.pause()
                  : _controller!.play();
            }
          });
        },
        child: Icon(
          _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),*/
    );
  }
}
