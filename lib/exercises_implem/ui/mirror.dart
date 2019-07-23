import 'dart:io';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stuttherapy/exercise_library/exercises.dart';
import 'package:stuttherapy/exercise_library/recording_resources.dart';
import 'package:stuttherapy/exercises_implem/ui/exercice_widget.dart';

import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';

class MirrorWidget extends StatefulWidget implements ExerciseWidget{

  final Exercise exercise;

    MirrorWidget({Key key, @required this.exercise}) : super(key: key);

  @override
  _CameraExampleHomeState createState() {
    return _CameraExampleHomeState();
  }
}


void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraExampleHomeState extends State<MirrorWidget>
    with WidgetsBindingObserver {
  CameraController controller;
  String videoPath;
  List<CameraDescription> cameras;
  bool error;

  @override
  void initState() {
    
    initCamera();
    super.initState();
    WidgetsBinding.instance.addObserver(this);

  }

   Future initCamera() async {
    await PermissionHandler().requestPermissions([PermissionGroup.camera, PermissionGroup.storage, PermissionGroup.microphone]);

    try {
      cameras = await availableCameras();
    } on CameraException catch (e) {
      logError(e.code, e.description);
    }

    bool cameraFound = false;
    for(CameraDescription cam in cameras) {
      if(cam.lensDirection == CameraLensDirection.front) {
        await onNewCameraSelected(cam);
        cameraFound = true;
      }
    }
    if(cameraFound) {
      startVideoRecording();
    } else {
      setState(() => error = true);
    }

    widget.exercise.flagEndOfExercise.stream.listen((bool end) {
      if(end)
        stopVideoRecording();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: _cameraPreviewWidget(),
      ),
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(
          color: controller != null && controller.value.isRecordingVideo
              ? Colors.redAccent
              : Colors.grey,
          width: 3.0,
        ),
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Loading...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();


  Future onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        // TODO
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
    }

    if (mounted) {
      setState(() {});
    }
  }

  Future<String> startVideoRecording() async {
    if (!controller.value.isInitialized) {
      return null;
    }

    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/mirror/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.mp4';

    if (controller.value.isRecordingVideo) {
      return null;  // A recording is already started, do nothing.
    }

    try {
      videoPath = filePath;
      await controller.startVideoRecording(filePath);
      widget.exercise.recordingResource = RecordingResource(uri: filePath, type: RecordingType.VIDEO);
    } on CameraException catch (e) {
      // TODO
      return null;
    }
    if (mounted) setState(() {});
    print(mounted);
    return filePath;
  }

  Future<void> stopVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return null;
    }

    try {
      await controller.stopVideoRecording();
      if (mounted) setState(() {});
    } on CameraException catch (e) {
      // TODO
      return null;
    }
  }

}


class VideoResourcePlayer extends StatefulWidget {

  final String uri;

  VideoResourcePlayer({Key key, @required this.uri}): super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoResourcePlayer> {
  VideoPlayerController _controller;
  bool isPause = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.file(File(widget.uri))
    ..initialize().then((_) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return _controller == null || !_controller.value.initialized
      ? Text("Loading video player")
      : Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(40,0,40,0),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton.icon(
                textColor: Colors.black,
                icon: Icon(isPause ? Icons.play_arrow : Icons.pause),
                label: Text(isPause ? "Play" : "Pause"),
                onPressed: isPause ? onPlay : onPause,
              ),
              FlatButton.icon(
                textColor: Colors.black,
                icon: Icon(Icons.replay),
                label: Text("Replay"),
                onPressed: onReplay,
              ),

            ],
          )
      ],);
      
  }

  onReplay() {
    _controller.seekTo(Duration(microseconds: 0));
    if(isPause)
      onPlay();
  }

  onPause() {
    _controller.pause();
    setState(() {
      isPause = true;
    });
  }

  onPlay() {
    _controller.play();
    setState(() {
      isPause = false;
    });
  }
}