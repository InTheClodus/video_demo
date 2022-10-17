import 'package:flutter/material.dart';
import '../other/temp_value.dart';
import '../video_player_utils.dart';

// ignore: must_be_immutable
class VideoPlayerTop extends StatefulWidget {
  VideoPlayerTop({Key? key, required this.title}) : super(key: key);
  final String title;
  late Function(bool) opacityCallback;
  @override
  State<VideoPlayerTop> createState() => _VideoPlayerTopState();
}

class _VideoPlayerTopState extends State<VideoPlayerTop> {
  double _opacity = TempValue.isLocked ? 0.0 : 1.0; // 不能固定值，横竖屏触发会重置
  bool get _isFullScreen => MediaQuery.of(context).orientation == Orientation.landscape;
  @override
  void initState() {
    super.initState();
    widget.opacityCallback = (appear){
      _opacity = appear ? 1.0 : 0.0;
      if(!mounted) return;
      setState(() {});
    };
  }
  @override //Material
  Widget build(BuildContext context) {
    return Positioned(
        left: 0,
        top: 0,
        right: 0,
        child: Material(
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 250),
        child: Container(
            width: double.maxFinite,
            height: 40,
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromRGBO(0, 0, 0, .7), Color.fromRGBO(0, 0, 0, 0)],
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  onPressed: () {
                    if (_isFullScreen) {
                      VideoPlayerUtils.setPortrait();
                    } else {
                     Navigator.pop(context);
                    }
                  }, // 如果是橫屏模式就切換豎屏，如果是豎屏就退出
                  icon: const Icon(Icons.arrow_back_ios,color: Colors.white,),
                ),
                 Text(widget.title, style: const TextStyle(color: Colors.white, fontSize: 15),),
                const Spacer(),
                // IconButton(
                //   onPressed: (){
                //
                //   },
                //   icon: const Icon(Icons.more_horiz_outlined,color: Colors.white,size: 32,),
                // )
              ],
            )
        ),
      ),
    ));
  }
}
