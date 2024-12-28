import 'dart:io';

import 'package:flutter/material.dart';
import '../../data/models/config/DeviceConfig.dart';
import '../../data/models/config/Global6Config.dart';
import '../../data/models/ws/EntryData.dart';
import '../../utils/FileUtil.dart';
import '../../utils/Preferences.dart';
import 'package:video_player/video_player.dart';

bool isActive = false;
int percentage = 0;

class Mode3 extends StatefulWidget {
  @override
  _Mode3State createState() => _Mode3State();
}

class _Mode3State extends State<Mode3> {
  VideoPlayerController? _controller;
  //FlickManager? flickManager;
  bool _isFullScreen = true;

  @override
  void initState() {
    super.initState();
    /*WebSocketUtil.addListener(
        WebSocketListener('wsMode3', _onMessageRecieved));*/
    /*_controller = VideoPlayerController.asset('assets/video.mp4')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });*/
    _initPlayer();

    // Call _toggleFullScreen() to enter fullscreen mode
    //_toggleFullScreen();
  }

  void _onMessageRecieved(EntryData e) {
    print("MODE 3 executed: override ${e.global6!.mode3Override}");
    if (e.global6 != null) {
      Global6Config.settings!.mode3Override = e.global6!.mode3Override;
      // show mode3 if true
      if (e.global6!.mode3Override == false) {
        Navigator.maybePop(context);
      }
    }
  }

  Future<void> _initPlayer() async {
    String url = 'http://602861c2ccdd.ngrok.app/files/video.mp4';
    String uri = "http://${DeviceConfig.rpi1}/files/video.mp4";
    print("LINK: $uri");
    //final file = await FileUtil.downloadFile('https://602861c2ccdd.ngrok.app/files/video.mp4', 'video.mp4');
    if (await FileUtil.isFileExistsInAppDir('uberDisplayVideo.mp4')) {
      //PermissionStatus permission = await FileUtil.getPermission();
      //print("PERMISSION STATUS: $permission");
      File? file = await FileUtil.getVideoFile('uberDisplayVideo.mp4');
      var isDownloaded = await Preferences.getSharedValue("videoDownloaded");
      print("VIDEO FILE: ${file?.path}");
      if (file != null && isDownloaded == "true") {
        /*_controller = VideoPlayerController.file(file)
          ..initialize().then((_) {
            setState(() {});
            if (_controller != null) {
              _controller?.play();
              _controller?.setLooping(true); // Set video to repeat infinitely
            }
          });*/
        _controller = VideoPlayerController.file(file)
          ..initialize().then((_) {
            print("VIDEO INITIALIZED");
            setState(() {});
            if (_controller != null) {
              //_controller?.play();
              //flickManager?.flickDisplayManager?.hidePlayerControls();
              //_controller?.setLooping(true); // Set video to repeat infinitely
            }
          });

        /*if(_controller != null) {
          flickManager = FlickManager(
              videoPlayerController: _controller!,
              onVideoEnd: () {
                print("Video Ended.......");
                //flickManager?.flickControlManager?.replay();
              }
          );
        }*/
      } else {
        print("[uberDisplayVideo.mp4] FILE DOES NOT EXIST");
      }
    } /*else {
      //var vController = VideoPlayerController.asset('assets/video1.mp4');
      var vController = VideoPlayerController.networkUrl(Uri.parse(uri));
      /*var vController = VideoPlayerController.asset('assets/video.mp4')
        ..initialize().then((_) {
          setState(() {});
          if(_controller != null) {
            _controller?.play();
            _controller?.setLooping(true); // Set video to repeat infinitely
          }
        }).onError((error, stackTrace) {
          print("VIDEO CONTROLLER ERROR@@@@@@@");
        });*/
      flickManager = FlickManager(
        videoPlayerController: vController,
        onVideoEnd: (){
          print("Video Ended.......");
          flickManager?.flickControlManager?.replay();
        }
      );

      /*final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/video.mp4';
      final response = await http.get(Uri.parse(url));
      await File(filePath).writeAsBytes(response.bodyBytes);*/
    }*/
  }

  /*void _toggleFullScreen() {
    setState(() {
      _isFullScreen = !_isFullScreen;
    });
    if (_isFullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, SystemUiOverlay.values);
    }
  }*/

  @override
  void dispose() {
    //if(_controller != null) {
    _controller?.dispose();
    //}
    //if(flickManager != null) {
    //flickManager?.dispose();
    //}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final ProgressIndicatorThemeData defaults = Theme.of(context).useMaterial3 as ProgressIndicatorThemeData;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: _isFullScreen
          ? null
          : AppBar(
              title: Text('Event'),
            ),
      /*body: Container(
        color: Colors.black,
        child: Center(
          child: _controller != null && _controller?.value.isInitialized == true
              ? AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          )
              : CircularProgressIndicator(),
        ),
      )*/
      body: /*flickManager != null ? VisibilityDetector(
        key: ObjectKey(flickManager),
        onVisibilityChanged: (visibility) {
          if (visibility.visibleFraction == 0 && this.mounted) {
            flickManager!.flickControlManager?.autoPause();
          } else if (visibility.visibleFraction == 1) {
            flickManager!.flickControlManager?.autoResume();
          }
        },
        child: Container(
          child: FlickVideoPlayer(
            flickManager: flickManager!,
            preferredDeviceOrientation: [
              DeviceOrientation.landscapeRight,
              DeviceOrientation.landscapeLeft
            ],
            systemUIOverlay: [],
            flickVideoWithControls: FlickVideoWithControls(
              //closedCaptionTextStyle: TextStyle(fontSize: 8),
              videoFit: BoxFit.contain,
              controls: FlickLandscapeControls(),
            ),
            flickVideoWithControlsFullscreen: FlickVideoWithControls(
              controls: FlickLandscapeControls(),
            ),
          ),
        ),
      ) : */
          Center(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            const CircularProgressIndicator(),
            Text("Loading..."),
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        },
        child: Icon(
          _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(_isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen),
              onPressed: () {
                //_toggleFullScreen();
              },
            ),
          ],
        ),
      ),*/
    );
  }
}
