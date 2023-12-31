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

class ConversationType extends $pb.ProtobufEnum {
  static const ConversationType CHAT =
      ConversationType._(0, _omitEnumNames ? '' : 'CHAT');
  static const ConversationType GROUP =
      ConversationType._(1, _omitEnumNames ? '' : 'GROUP');
  static const ConversationType BROARDCAST =
      ConversationType._(2, _omitEnumNames ? '' : 'BROARDCAST');

  static const $core.List<ConversationType> values = <ConversationType>[
    CHAT,
    GROUP,
    BROARDCAST,
  ];

  static final $core.Map<$core.int, ConversationType> _byValue =
      $pb.ProtobufEnum.initByValue(values);

  static ConversationType? valueOf($core.int value) => _byValue[value];

  const ConversationType._($core.int v, $core.String n) : super(v, n);
}

class MsgType extends $pb.ProtobufEnum {
  static const MsgType TEXT = MsgType._(0, _omitEnumNames ? '' : 'TEXT');
  static const MsgType LOCATION =
      MsgType._(1, _omitEnumNames ? '' : 'LOCATION');

  static const $core.List<MsgType> values = <MsgType>[
    TEXT,
    LOCATION,
  ];

  static final $core.Map<$core.int, MsgType> _byValue =
      $pb.ProtobufEnum.initByValue(values);

  static MsgType? valueOf($core.int value) => _byValue[value];

  const MsgType._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
