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
    $core.String? recipientId,
    ConversationType? conversationType,
    $core.String? sender,
    $core.String? content,
    $core.String? sendtime,
  }) {
    final $result = create();
    if (recipientId != null) {
      $result.recipientId = recipientId;
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
    if (sendtime != null) {
      $result.sendtime = sendtime;
    }
    return $result;
  }
  ChatMessage._() : super();
  factory ChatMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ChatMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ChatMessage', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'recipientId', protoName: 'recipientId')
    ..e<ConversationType>(2, _omitFieldNames ? '' : 'conversationType', $pb.PbFieldType.OE, protoName: 'conversationType', defaultOrMaker: ConversationType.CHAT, valueOf: ConversationType.valueOf, enumValues: ConversationType.values)
    ..aOS(3, _omitFieldNames ? '' : 'sender')
    ..aOS(4, _omitFieldNames ? '' : 'content')
    ..aOS(5, _omitFieldNames ? '' : 'sendtime')
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
  $core.String get recipientId => $_getSZ(0);
  @$pb.TagNumber(1)
  set recipientId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasRecipientId() => $_has(0);
  @$pb.TagNumber(1)
  void clearRecipientId() => clearField(1);

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
  $core.String get sendtime => $_getSZ(4);
  @$pb.TagNumber(5)
  set sendtime($core.String v) { $_setString(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasSendtime() => $_has(4);
  @$pb.TagNumber(5)
  void clearSendtime() => clearField(5);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
