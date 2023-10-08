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

///
/// enum ConversationType{
/// PRIVATE = 0;
/// GROUP = 1;
/// }
class MessageType extends $pb.ProtobufEnum {
  static const MessageType TEXT = MessageType._(0, _omitEnumNames ? '' : 'TEXT');
  static const MessageType AUDIO = MessageType._(1, _omitEnumNames ? '' : 'AUDIO');
  static const MessageType IMAGE = MessageType._(2, _omitEnumNames ? '' : 'IMAGE');
  static const MessageType MAP = MessageType._(3, _omitEnumNames ? '' : 'MAP');
  static const MessageType FILE = MessageType._(4, _omitEnumNames ? '' : 'FILE');

  static const $core.List<MessageType> values = <MessageType> [
    TEXT,
    AUDIO,
    IMAGE,
    MAP,
    FILE,
  ];

  static final $core.Map<$core.int, MessageType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static MessageType? valueOf($core.int value) => _byValue[value];

  const MessageType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
