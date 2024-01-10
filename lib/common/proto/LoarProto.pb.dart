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

class LoarMessage extends $pb.GeneratedMessage {
  factory LoarMessage({
    $core.String? conversationId,
    MsgType? msgType,
    $core.String? sender,
    $core.String? repeater,
    $core.bool? hasDeliverAck,
    $core.String? content,
    $core.String? msgId,
    $core.int? sendCount,
    $core.double? latitude,
    $core.double? longitude,
  }) {
    final $result = create();
    if (conversationId != null) {
      $result.conversationId = conversationId;
    }
    if (msgType != null) {
      $result.msgType = msgType;
    }
    if (sender != null) {
      $result.sender = sender;
    }
    if (repeater != null) {
      $result.repeater = repeater;
    }
    if (hasDeliverAck != null) {
      $result.hasDeliverAck = hasDeliverAck;
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
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    return $result;
  }

  LoarMessage._() : super();

  factory LoarMessage.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);

  factory LoarMessage.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'LoarMessage',
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'conversationId',
        protoName: 'conversationId')
    ..e<MsgType>(2, _omitFieldNames ? '' : 'msgType', $pb.PbFieldType.OE,
        protoName: 'msgType',
        defaultOrMaker: MsgType.CHAT_TEXT,
        valueOf: MsgType.valueOf,
        enumValues: MsgType.values)
    ..aOS(3, _omitFieldNames ? '' : 'sender')
    ..aOS(4, _omitFieldNames ? '' : 'repeater')
    ..aOB(5, _omitFieldNames ? '' : 'hasDeliverAck', protoName: 'hasDeliverAck')
    ..aOS(6, _omitFieldNames ? '' : 'content')
    ..aOS(7, _omitFieldNames ? '' : 'msgId', protoName: 'msgId')
    ..a<$core.int>(8, _omitFieldNames ? '' : 'sendCount', $pb.PbFieldType.O3,
        protoName: 'sendCount')
    ..a<$core.double>(9, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(
        10, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  LoarMessage clone() => LoarMessage()..mergeFromMessage(this);

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  LoarMessage copyWith(void Function(LoarMessage) updates) =>
      super.copyWith((message) => updates(message as LoarMessage))
          as LoarMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoarMessage create() => LoarMessage._();

  LoarMessage createEmptyInstance() => create();

  static $pb.PbList<LoarMessage> createRepeated() => $pb.PbList<LoarMessage>();

  @$core.pragma('dart2js:noInline')
  static LoarMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<LoarMessage>(create);
  static LoarMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get conversationId => $_getSZ(0);

  @$pb.TagNumber(1)
  set conversationId($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasConversationId() => $_has(0);
  @$pb.TagNumber(1)
  void clearConversationId() => clearField(1);

  @$pb.TagNumber(2)
  MsgType get msgType => $_getN(1);

  @$pb.TagNumber(2)
  set msgType(MsgType v) {
    setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMsgType() => $_has(1);

  @$pb.TagNumber(2)
  void clearMsgType() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get sender => $_getSZ(2);
  @$pb.TagNumber(3)
  set sender($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasSender() => $_has(2);
  @$pb.TagNumber(3)
  void clearSender() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get repeater => $_getSZ(3);

  @$pb.TagNumber(4)
  set repeater($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasRepeater() => $_has(3);

  @$pb.TagNumber(4)
  void clearRepeater() => clearField(4);

  @$pb.TagNumber(5)
  $core.bool get hasDeliverAck => $_getBF(4);

  @$pb.TagNumber(5)
  set hasDeliverAck($core.bool v) {
    $_setBool(4, v);
  }

  @$pb.TagNumber(5)
  $core.bool hasHasDeliverAck() => $_has(4);

  @$pb.TagNumber(5)
  void clearHasDeliverAck() => clearField(5);

  @$pb.TagNumber(6)
  $core.String get content => $_getSZ(5);

  @$pb.TagNumber(6)
  set content($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(6)
  $core.bool hasContent() => $_has(5);

  @$pb.TagNumber(6)
  void clearContent() => clearField(6);

  @$pb.TagNumber(7)
  $core.String get msgId => $_getSZ(6);

  @$pb.TagNumber(7)
  set msgId($core.String v) {
    $_setString(6, v);
  }

  @$pb.TagNumber(7)
  $core.bool hasMsgId() => $_has(6);

  @$pb.TagNumber(7)
  void clearMsgId() => clearField(7);

  @$pb.TagNumber(8)
  $core.int get sendCount => $_getIZ(7);

  @$pb.TagNumber(8)
  set sendCount($core.int v) {
    $_setSignedInt32(7, v);
  }

  @$pb.TagNumber(8)
  $core.bool hasSendCount() => $_has(7);

  @$pb.TagNumber(8)
  void clearSendCount() => clearField(8);

  @$pb.TagNumber(9)
  $core.double get latitude => $_getN(8);

  @$pb.TagNumber(9)
  set latitude($core.double v) {
    $_setDouble(8, v);
  }

  @$pb.TagNumber(9)
  $core.bool hasLatitude() => $_has(8);

  @$pb.TagNumber(9)
  void clearLatitude() => clearField(9);

  @$pb.TagNumber(10)
  $core.double get longitude => $_getN(9);

  @$pb.TagNumber(10)
  set longitude($core.double v) {
    $_setDouble(9, v);
  }

  @$pb.TagNumber(10)
  $core.bool hasLongitude() => $_has(9);

  @$pb.TagNumber(10)
  void clearLongitude() => clearField(10);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
