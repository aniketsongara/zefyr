// Copyright (c) 2018, the Zefyr project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zefyr/zefyr.dart';
import 'package:path_provider/path_provider.dart';
/// Custom video delegate used by this example to load video from application
/// assets.
class CustomVideoDelegate implements ZefyrVideoDelegate<ImageSource> {
  VideoPlayerController _controller;
  Future<void> _initializeVideoPlayerFuture;

  @override
  ImageSource get cameraSource => ImageSource.camera;

  @override
  ImageSource get gallerySource => ImageSource.gallery;

  @override
  Future<String> pickVideo(ImageSource source) async {
    final file = await ImagePicker.pickVideo(source: source);
    if (file == null) return null;
    return file.uri.toString();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    final myDir =  Directory('${directory.path}/TBB');
   await myDir.exists().then((isThere) {
      if (!isThere) {
         Directory('${directory.path}/TBB').create(recursive: true)
            .then((Directory directory) {
          return directory.path;
        });
      }
    });
    return directory.path+'/TBB';
  }


  @override
  Widget buildVideo(BuildContext context, String key) {
    // We use custom "asset" scheme to distinguish asset video from other files.
    if (key.startsWith('asset://')) {
      _controller =
          VideoPlayerController.asset(key.replaceFirst('asset://', ''));
      _initializeVideoPlayerFuture = _controller.initialize();
      _controller.pause();
      return VideoPlayer(_controller);
      //return File(key.replaceFirst('asset://', ''));
    } else {
      // Otherwise assume this is a file stored locally on user's device.
      final file = File.fromUri(Uri.parse(key));
    /*  final fileName =
          '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}_${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}:${DateTime.now().millisecond}';
      var path = _localPath as String;
    Future<File> newFile =  file.copy(path+'/$fileName');
*/
      //  _controller = VideoPlayerController.file(file);
      //_initializeVideoPlayerFuture = _controller.initialize();
      //_controller.pause();
      //return VideoPlayer(_controller);
      //return file;
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
              child: Icon(
                Icons.video_library,
                size: 25,
              ),
            ),
            Expanded(child: Text('${file.path}'))
          ],
        ),
        color: Color(0xff95975D),
      );
    }
  }
}
