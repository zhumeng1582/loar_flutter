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

class MsgType extends $pb.ProtobufEnum {
  static const MsgType CHAT_TEXT =
      MsgType._(0, _omitEnumNames ? '' : 'CHAT_TEXT');
  static const MsgType CHAT_LOCATION =
      MsgType._(1, _omitEnumNames ? '' : 'CHAT_LOCATION');
  static const MsgType GROUP_TEXT =
      MsgType._(10, _omitEnumNames ? '' : 'GROUP_TEXT');
  static const MsgType GROUP_LOCATION =
      MsgType._(11, _omitEnumNames ? '' : 'GROUP_LOCATION');
  static const MsgType BROARDCAST_TEXT =
      MsgType._(20, _omitEnumNames ? '' : 'BROARDCAST_TEXT');
  static const MsgType BROARDCAST_LOCATION =
      MsgType._(21, _omitEnumNames ? '' : 'BROARDCAST_LOCATION');

  static const $core.List<MsgType> values = <MsgType>[
    CHAT_TEXT,
    CHAT_LOCATION,
    GROUP_TEXT,
    GROUP_LOCATION,
    BROARDCAST_TEXT,
    BROARDCAST_LOCATION,
  ];

  static final $core.Map<$core.int, MsgType> _byValue =
      $pb.ProtobufEnum.initByValue(values);

  static MsgType? valueOf($core.int value) => _byValue[value];

  const MsgType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
