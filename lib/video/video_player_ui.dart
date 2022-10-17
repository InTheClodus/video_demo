import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:video_demo/video/widget/video_player_bottom.dart';
import 'package:video_demo/video/widget/video_player_center.dart';
import 'other/temp_value.dart';
import 'video_player_utils.dart';
import 'widget/video_player_gestures.dart';
import 'widget/video_player_top.dart';

class VideoPlayerUI extends StatefulWidget {
  const VideoPlayerUI(
      {Key? key, required this.videoUrl, required this.videoTitle})
      : super(key: key);
  final String videoUrl;
  final String videoTitle;

  @override
  State<VideoPlayerUI> createState() => _VideoPlayerUIState();
}

class _VideoPlayerUIState extends State<VideoPlayerUI> {
  Widget? _playerUI;

  VideoPlayerTop? _top;
  VideoPlayerBottom? _bottom;
  LockIcon? _lockIcon;

  bool get _isFullScreen =>
      MediaQuery.of(context).orientation == Orientation.landscape;

  Size get _window => MediaQueryData.fromWindow(window).size;

  double get _width => _isFullScreen ? _window.width : _window.width;

  double get _height => _isFullScreen ? _window.height : _window.width * 9 / 16;

  @override
  void initState() {
    super.initState();
    // 播放视频
    VideoPlayerUtils.playerHandle(widget.videoUrl);
    // 播放新视频，初始化监听
    VideoPlayerUtils.initializedListener(
        key: this,
        listener: (initialize, widget) {
          if (initialize) {
            _playerUI = widget;
            if (!mounted) return;
            setState(() {});
          }
        });

    _top = VideoPlayerTop(title: widget.videoTitle);
    _bottom = VideoPlayerBottom();
    _lockIcon = LockIcon(lockCallback: () {
      _top!.opacityCallback(!TempValue.isLocked);
      _bottom!.opacityCallback(!TempValue.isLocked);
    });
  }

  @override
  void dispose() {
    VideoPlayerUtils.setPortrait();
    VideoPlayerUtils.removeInitializedListener(this);
    VideoPlayerUtils.dispose();
    debugPrint("視頻資源被釋放了");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: !_isFullScreen,
      bottom: !_isFullScreen,
      left: !_isFullScreen,
      right: !_isFullScreen,
      child: SizedBox(
          height: _height,
          width: _width,
          child: _playerUI != null
              ? VideoPlayerGestures(
                  appearCallback: (appear) {
                    _top!.opacityCallback(appear);
                    _lockIcon!.opacityCallback(appear);
                    _bottom!.opacityCallback(appear);
                  },
                  children: [
                    Center(
                      child: _playerUI,
                    ),
                    _lockIcon!,
                    _bottom!,
                    _top!,
                  ],
                )
              : Container(
                  alignment: Alignment.center,
                  color: Colors.black26,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                  ),
                )),
    );
  }
}
