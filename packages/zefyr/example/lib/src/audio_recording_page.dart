import 'package:flutter/material.dart';
import 'dart:io' as io;
import 'dart:async';
import 'package:audio_recorder/audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecordingScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AudioRecordingState();
  }
}

class AudioRecordingState extends State<AudioRecordingScreen> {
  bool _isRecording = false;
  var dir;

    Future<void> createDirectory() async {
    dir = await getExternalStorageDirectory();
    final myDir = io.Directory('${dir.path}/TBB');
    await myDir.exists().then((isThere) {
      if (!isThere) {
        io.Directory('${dir.path}/TBB').create(recursive: true)
            // The created directory is returned as a Future.
            .then((io.Directory directory) {
          print(
              '-------------------${directory.path}--------------------------');
        });
      } else {
        print('_________exists_______________________');
      }
    });
  }

  Future<bool> checkPermission() async {
    print('Checking permissions.....');
    if (!await Permission.microphone.isGranted &&
        !await Permission.storage.isGranted) {
      PermissionStatus statusMicrophone = await Permission.microphone.request();
      PermissionStatus statusStorage = await Permission.storage.request();
      if (statusMicrophone != PermissionStatus.granted &&
          statusStorage != PermissionStatus.granted) {
        return false;
      }
    }
    return true;
  }

  Future<void> _startAudioRecording() async {
    bool hasPermission = await checkPermission();
    try {
      if (hasPermission) {

        await createDirectory();
        var fileName =
            'AUD_${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}_${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}:${DateTime.now().millisecond}';
        await AudioRecorder.start(
            path: dir.path + '/TBB/' + fileName.toString(),
            audioOutputFormat: AudioOutputFormat.AAC);

        print(
            '*********************************custom recording path is : ${dir.path + '/TBB/' + fileName.toString()}*********************************');

        bool isRecording = await AudioRecorder.isRecording;
        setState(() {
          //_recording = new Recording(duration: new Duration(), path: "");
          _isRecording = isRecording;
        });
      } else {
        Scaffold.of(context).showSnackBar(
             SnackBar(content:  Text('You must accept permissions')));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _stopAudioRecording() async {
    var recording = await AudioRecorder.stop();
    print('Stop recording: ${recording.path}');

    Navigator.pop(context,'${recording.path}');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Reacord Audio'),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(child: Container(
            margin: EdgeInsets.all(16.0),
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              color: _isRecording ? Colors.blueAccent : Colors.black38,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.mic_off,
                    size: 50,
                    color: _isRecording ? Colors.red : Colors.black38,
                  )
                ],
              ),
            ),
          ),
          onTap: _isRecording ? _stopAudioRecording : _startAudioRecording,),
          Text(_isRecording ? 'Tap to Start recording.' : 'Recording...')
        ],
      ),
    );
  }
}
