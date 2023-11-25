//
//  Generated code. Do not modify.
//  source: LoarProto.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'LoarProto.pbenum.dart';

export 'LoarProto.pbenum.dart';

class ChatMessage extends $pb.GeneratedMessage {
  factory ChatMessage({
    $core.String? conversationId,
    ConversationType? conversationType,
    $core.String? sender,
    $core.String? content,
    $core.String? msgId,
    $core.int? sendCount,
    MsgType? msgType,
    $core.double? latitude,
    $core.double? longitude,
  }) {
    final $result = create();
    if (conversationId != null) {
      $result.conversationId = conversationId;
    }
    if (conversationType != null) {
      $result.conversationType = conversationType;
    }
    if (sender != null) {
      $result.sender = sender;
    }
    if (content != null) {
      $result.content = content;
    }
    if (msgId != null) {
      $result.msgId = msgId;
    }
    if (sendCount != null) {
      $result.sendCount = sendCount;
    }
    if (msgType != null) {
      $result.msgType = msgType;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    return $result;
  }
  ChatMessage._() : super();
  factory ChatMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChatMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatMessage', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'conversationId', protoName: 'conversationId')
    ..e<ConversationType>(2, _omitFieldNames ? '' : 'conversationType', $pb.PbFieldType.OE, protoName: 'conversationType', defaultOrMaker: ConversationType.CHAT, valueOf: ConversationType.valueOf, enumValues: ConversationType.values)
    ..aOS(3, _omitFieldNames ? '' : 'sender')
    ..aOS(4, _omitFieldNames ? '' : 'content')
    ..aOS(5, _omitFieldNames ? '' : 'msgId', protoName: 'msgId')
    ..a<$core.int>(6, _omitFieldNames ? '' : 'sendCount', $pb.PbFieldType.O3, protoName: 'sendCount')
    ..e<MsgType>(7, _omitFieldNames ? '' : 'msgType', $pb.PbFieldType.OE, protoName: 'msgType', defaultOrMaker: MsgType.TEXT, valueOf: MsgType.valueOf, enumValues: MsgType.values)
    ..a<$core.double>(8, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(9, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ChatMessage clone() => ChatMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ChatMessage copyWith(void Function(ChatMessage) updates) => super.copyWith((message) => updates(message as ChatMessage)) as ChatMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ChatMessage create() => ChatMessage._();
  ChatMessage createEmptyInstance() => create();
  static $pb.PbList<ChatMessage> createRepeated() => $pb.PbList<ChatMessage>();
  @$core.pragma('dart2js:noInline')
  static ChatMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ChatMessage>(create);
  static ChatMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get conversationId => $_getSZ(0);
  @$pb.TagNumber(1)
  set conversationId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasConversationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConversationId() => clearField(1);

  @$pb.TagNumber(2)
  ConversationType get conversationType => $_getN(1);
  @$pb.TagNumber(2)
  set conversationType(ConversationType v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasConversationType() => $_has(1);
  @$pb.TagNumber(2)
  void clearConversationType() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get sender => $_getSZ(2);
  @$pb.TagNumber(3)
  set sender($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSender() => $_has(2);
  @$pb.TagNumber(3)
  void clearSender() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get content => $_getSZ(3);
  @$pb.TagNumber(4)
  set content($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasContent() => $_has(3);
  @$pb.TagNumber(4)
  void clearContent() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get msgId => $_getSZ(4);
  @$pb.TagNumber(5)
  set msgId($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasMsgId() => $_has(4);
  @$pb.TagNumber(5)
  void clearMsgId() => clearField(5);

  @$pb.TagNumber(6)
  $core.int get sendCount => $_getIZ(5);
  @$pb.TagNumber(6)
  set sendCount($core.int v) { $_setSignedInt32(5, v); }
  @$pb.TagNumber(6)
  $core.bool hasSendCount() => $_has(5);
  @$pb.TagNumber(6)
  void clearSendCount() => clearField(6);

  @$pb.TagNumber(7)
  MsgType get msgType => $_getN(6);
  @$pb.TagNumber(7)
  set msgType(MsgType v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasMsgType() => $_has(6);
  @$pb.TagNumber(7)
  void clearMsgType() => clearField(7);

  @$pb.TagNumber(8)
  $core.double get latitude => $_getN(7);
  @$pb.TagNumber(8)
  set latitude($core.double v) { $_setDouble(7, v); }
  @$pb.TagNumber(8)
  $core.bool hasLatitude() => $_has(7);
  @$pb.TagNumber(8)
  void clearLatitude() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get longitude => $_getN(8);
  @$pb.TagNumber(9)
  set longitude($core.double v) { $_setDouble(8, v); }
  @$pb.TagNumber(9)
  $core.bool hasLongitude() => $_has(8);
  @$pb.TagNumber(9)
  void clearLongitude() => clearField(9);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
