# loar_flutter

Loar 聊天

## [在线通信协议参考环信sdk](https://docs-im-beta.easemob.com/document/flutter/quickstart.html)

## 离线通信采用protobuf，文件为

```protobuf

syntax = "proto3";

enum MsgType{
    CHAT_TEXT = 00;
    CHAT_LOCATION = 01;
    GROUP_TEXT = 10;
    GROUP_LOCATION = 11;
    BROARDCAST_TEXT = 20;
    BROARDCAST_LOCATION = 21;

}
/****
message LoarMessage{
    int32 messageType = 1;//ConversationType,msgType
    int32 sendCount = 2;//sendCount,hasDeliverAck
    string sender = 3;//发送者Id
    string repeater = 4;//转发者
    bool hasDeliverAck = 5;//消息已经送达
    
    string content = 6;//文字聊天内容
    string msgId = 7;//发送Id
    double latitude = 8;
    double longitude = 9;
}
*****/

message LoarMessage{
    bytes conversationId=1;//会话ID,单聊是为用户id,群聊时为群id
    MsgType msgType = 2;//群聊，私聊
    bytes sender = 3;//发送者Id
    bytes repeater = 4;//转发者
    bool hasDeliverAck = 5;//消息已经送达
    
    string content = 6;//文字聊天内容
    bytes msgId = 7;//消息Id
    int32 sendCount = 8;//消息转发计数
    double latitude = 9;
    double longitude = 10;
}

