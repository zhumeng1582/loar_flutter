//
//  Generated code. Do not modify.
//  source: UserInfo.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class ConversationType extends $pb.ProtobufEnum {
  static const ConversationType PRIVATE = ConversationType._(0, _omitEnumNames ? '' : 'PRIVATE');
  static const ConversationType GROUP = ConversationType._(1, _omitEnumNames ? '' : 'GROUP');

  static const $core.List<ConversationType> values = <ConversationType> [
    PRIVATE,
    GROUP,
  ];

  static final $core.Map<$core.int, ConversationType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static ConversationType? valueOf($core.int value) => _byValue[value];

  const ConversationType._($core.int v, $core.String n) : super(v, n);
}

class MessageType extends $pb.ProtobufEnum {
  static const MessageType TEXT = MessageType._(0, _omitEnumNames ? '' : 'TEXT');
  static const MessageType AUDIO = MessageType._(1, _omitEnumNames ? '' : 'AUDIO');
  static const MessageType IMAGE = MessageType._(2, _omitEnumNames ? '' : 'IMAGE');
  static const MessageType MAP = MessageType._(3, _omitEnumNames ? '' : 'MAP');
  static const MessageType FILE = MessageType._(4, _omitEnumNames ? '' : 'FILE');
  static const MessageType ADD_MEMBER = MessageType._(5, _omitEnumNames ? '' : 'ADD_MEMBER');

  static const $core.List<MessageType> values = <MessageType> [
    TEXT,
    AUDIO,
    IMAGE,
    MAP,
    FILE,
    ADD_MEMBER,
  ];

  static final $core.Map<$core.int, MessageType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MessageType? valueOf($core.int value) => _byValue[value];

  const MessageType._($core.int v, $core.String n) : super(v, n);
}

class LoarMessageType extends $pb.ProtobufEnum {
  static const LoarMessageType ADD_FRIEND = LoarMessageType._(0, _omitEnumNames ? '' : 'ADD_FRIEND');
  static const LoarMessageType ADD_GROUP = LoarMessageType._(1, _omitEnumNames ? '' : 'ADD_GROUP');
  static const LoarMessageType MESSAGE = LoarMessageType._(3, _omitEnumNames ? '' : 'MESSAGE');

  static const $core.List<LoarMessageType> values = <LoarMessageType> [
    ADD_FRIEND,
    ADD_GROUP,
    MESSAGE,
  ];

  static final $core.Map<$core.int, LoarMessageType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static LoarMessageType? valueOf($core.int value) => _byValue[value];

  const LoarMessageType._($core.int v, $core.String n) : super(v, n);
}

class QrCodeType extends $pb.ProtobufEnum {
  static const QrCodeType QR_USER = QrCodeType._(0, _omitEnumNames ? '' : 'QR_USER');
  static const QrCodeType QR_GROUP = QrCodeType._(1, _omitEnumNames ? '' : 'QR_GROUP');

  static const $core.List<QrCodeType> values = <QrCodeType> [
    QR_USER,
    QR_GROUP,
  ];

  static final $core.Map<$core.int, QrCodeType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static QrCodeType? valueOf($core.int value) => _byValue[value];

  const QrCodeType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
