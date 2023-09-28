import 'package:flutter/material.dart';
import 'package:flutter_plugin_record_plus/flutter_plugin_record.dart';

import '../widget/voice_widget.dart';

class WeChatRecordScreen extends StatefulWidget {
  @override
  _WeChatRecordScreenState createState() => _WeChatRecordScreenState();
}

class _WeChatRecordScreenState extends State<WeChatRecordScreen> {
  FlutterPluginRecord recordPlugin = new FlutterPluginRecord();
  String filePath = "";

  @override
  void initState() {
    super.initState();

    ///初始化方法的监听
    recordPlugin.responseFromInit.listen((data) {
      if (data) {
        print("初始化成功");
      } else {
        print("初始化失败");
      }
    });
  }

  startRecord() {
    print("开始录制");
  }

  stopRecord(String path, double audioTimeLength) {
    print("结束束录制");
    print("音频文件位置" + path);
    print("音频录制时长" + audioTimeLength.toString());
    filePath = path;
  }

  ///初始化语音录制的方法
  void _initRecordMp3() async {
    recordPlugin.initRecordMp3();
  }

  ///开始语音录制的方法
  void start() async {
    recordPlugin.start();
  }

  ///根据传递的路径进行语音录制
  void startByWavPath(String wavPath) async {
    recordPlugin.startByWavPath(wavPath);
  }

  ///停止语音录制的方法
  void stop() {
    recordPlugin.stop();
  }

  ///播放语音的方法
  void play() {
    recordPlugin.play();
  }

  ///播放指定路径录音文件  url为iOS播放网络语音，file为播放本地语音文件
  void playByPath(String path, String type) {
    recordPlugin.playByPath(path, type);
  }

  ///暂停|继续播放
  void pause() {
    recordPlugin.pausePlay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("仿微信发送语音"),
      ),
      body: Column(
        children: <Widget>[
          InkWell(
              onTap: () {
                playByPath(filePath, "file");
              },
              child: new Text("播放")),
          VoiceWidget(
            startRecord: startRecord,
            stopRecord: stopRecord,
            // 加入定制化Container的相关属性
            height: 40.0,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    /// 当界面退出的时候是释放录音资源
    recordPlugin.dispose();
    super.dispose();
  }

  void stopPlay() {
    recordPlugin.stopPlay();
  }
}
