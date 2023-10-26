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

class UserInfo extends $pb.GeneratedMessage {
  factory UserInfo({
    $core.String? id,
    $core.String? icon,
    $core.String? name,
    $core.String? account,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (icon != null) {
      $result.icon = icon;
    }
    if (name != null) {
      $result.name = name;
    }
    if (account != null) {
      $result.account = account;
    }
    return $result;
  }
  UserInfo._() : super();
  factory UserInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory UserInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'UserInfo', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'icon')
    ..aOS(3, _omitFieldNames ? '' : 'name')
    ..aOS(4, _omitFieldNames ? '' : 'account')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  UserInfo clone() => UserInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  UserInfo copyWith(void Function(UserInfo) updates) => super.copyWith((message) => updates(message as UserInfo)) as UserInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UserInfo create() => UserInfo._();
  UserInfo createEmptyInstance() => create();
  static $pb.PbList<UserInfo> createRepeated() => $pb.PbList<UserInfo>();
  @$core.pragma('dart2js:noInline')
  static UserInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<UserInfo>(create);
  static UserInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get icon => $_getSZ(1);
  @$pb.TagNumber(2)
  set icon($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIcon() => $_has(1);
  @$pb.TagNumber(2)
  void clearIcon() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get name => $_getSZ(2);
  @$pb.TagNumber(3)
  set name($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasName() => $_has(2);
  @$pb.TagNumber(3)
  void clearName() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get account => $_getSZ(3);
  @$pb.TagNumber(4)
  set account($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasAccount() => $_has(3);
  @$pb.TagNumber(4)
  void clearAccount() => clearField(4);
}

class RoomInfo extends $pb.GeneratedMessage {
  factory RoomInfo({
    $core.String? id,
    $core.String? name,
    $core.String? tag,
    $core.String? createtime,
    UserInfo? creator,
    $core.Iterable<UserInfo>? userList,
    $core.Iterable<ChatMessage>? messagelist,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (name != null) {
      $result.name = name;
    }
    if (tag != null) {
      $result.tag = tag;
    }
    if (createtime != null) {
      $result.createtime = createtime;
    }
    if (creator != null) {
      $result.creator = creator;
    }
    if (userList != null) {
      $result.userList.addAll(userList);
    }
    if (messagelist != null) {
      $result.messagelist.addAll(messagelist);
    }
    return $result;
  }
  RoomInfo._() : super();
  factory RoomInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory RoomInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'RoomInfo', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOS(3, _omitFieldNames ? '' : 'tag')
    ..aOS(4, _omitFieldNames ? '' : 'createtime')
    ..aOM<UserInfo>(5, _omitFieldNames ? '' : 'creator', subBuilder: UserInfo.create)
    ..pc<UserInfo>(6, _omitFieldNames ? '' : 'userList', $pb.PbFieldType.PM, protoName: 'userList', subBuilder: UserInfo.create)
    ..pc<ChatMessage>(7, _omitFieldNames ? '' : 'messagelist', $pb.PbFieldType.PM, subBuilder: ChatMessage.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  RoomInfo clone() => RoomInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  RoomInfo copyWith(void Function(RoomInfo) updates) => super.copyWith((message) => updates(message as RoomInfo)) as RoomInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RoomInfo create() => RoomInfo._();
  RoomInfo createEmptyInstance() => create();
  static $pb.PbList<RoomInfo> createRepeated() => $pb.PbList<RoomInfo>();
  @$core.pragma('dart2js:noInline')
  static RoomInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<RoomInfo>(create);
  static RoomInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get tag => $_getSZ(2);
  @$pb.TagNumber(3)
  set tag($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasTag() => $_has(2);
  @$pb.TagNumber(3)
  void clearTag() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get createtime => $_getSZ(3);
  @$pb.TagNumber(4)
  set createtime($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasCreatetime() => $_has(3);
  @$pb.TagNumber(4)
  void clearCreatetime() => clearField(4);

  @$pb.TagNumber(5)
  UserInfo get creator => $_getN(4);
  @$pb.TagNumber(5)
  set creator(UserInfo v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasCreator() => $_has(4);
  @$pb.TagNumber(5)
  void clearCreator() => clearField(5);
  @$pb.TagNumber(5)
  UserInfo ensureCreator() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.List<UserInfo> get userList => $_getList(5);

  @$pb.TagNumber(7)
  $core.List<ChatMessage> get messagelist => $_getList(6);
}

class AllChatInfo extends $pb.GeneratedMessage {
  factory AllChatInfo({
    $core.String? userId,
    $core.Iterable<UserInfo>? userList,
    $core.Iterable<RoomInfo>? roomList,
  }) {
    final $result = create();
    if (userId != null) {
      $result.userId = userId;
    }
    if (userList != null) {
      $result.userList.addAll(userList);
    }
    if (roomList != null) {
      $result.roomList.addAll(roomList);
    }
    return $result;
  }
  AllChatInfo._() : super();
  factory AllChatInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AllChatInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AllChatInfo', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'userId', protoName: 'userId')
    ..pc<UserInfo>(2, _omitFieldNames ? '' : 'userList', $pb.PbFieldType.PM, protoName: 'userList', subBuilder: UserInfo.create)
    ..pc<RoomInfo>(3, _omitFieldNames ? '' : 'roomList', $pb.PbFieldType.PM, protoName: 'roomList', subBuilder: RoomInfo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AllChatInfo clone() => AllChatInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AllChatInfo copyWith(void Function(AllChatInfo) updates) => super.copyWith((message) => updates(message as AllChatInfo)) as AllChatInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AllChatInfo create() => AllChatInfo._();
  AllChatInfo createEmptyInstance() => create();
  static $pb.PbList<AllChatInfo> createRepeated() => $pb.PbList<AllChatInfo>();
  @$core.pragma('dart2js:noInline')
  static AllChatInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AllChatInfo>(create);
  static AllChatInfo? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get userId => $_getSZ(0);
  @$pb.TagNumber(1)
  set userId($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUserId() => $_has(0);
  @$pb.TagNumber(1)
  void clearUserId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<UserInfo> get userList => $_getList(1);

  @$pb.TagNumber(3)
  $core.List<RoomInfo> get roomList => $_getList(2);
}

class LoginUserInfo extends $pb.GeneratedMessage {
  factory LoginUserInfo({
    UserInfo? user,
    $core.String? password,
  }) {
    final $result = create();
    if (user != null) {
      $result.user = user;
    }
    if (password != null) {
      $result.password = password;
    }
    return $result;
  }
  LoginUserInfo._() : super();
  factory LoginUserInfo.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoginUserInfo.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoginUserInfo', createEmptyInstance: create)
    ..aOM<UserInfo>(1, _omitFieldNames ? '' : 'user', subBuilder: UserInfo.create)
    ..aOS(2, _omitFieldNames ? '' : 'password')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoginUserInfo clone() => LoginUserInfo()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoginUserInfo copyWith(void Function(LoginUserInfo) updates) => super.copyWith((message) => updates(message as LoginUserInfo)) as LoginUserInfo;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoginUserInfo create() => LoginUserInfo._();
  LoginUserInfo createEmptyInstance() => create();
  static $pb.PbList<LoginUserInfo> createRepeated() => $pb.PbList<LoginUserInfo>();
  @$core.pragma('dart2js:noInline')
  static LoginUserInfo getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoginUserInfo>(create);
  static LoginUserInfo? _defaultInstance;

  @$pb.TagNumber(1)
  UserInfo get user => $_getN(0);
  @$pb.TagNumber(1)
  set user(UserInfo v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasUser() => $_has(0);
  @$pb.TagNumber(1)
  void clearUser() => clearField(1);
  @$pb.TagNumber(1)
  UserInfo ensureUser() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get password => $_getSZ(1);
  @$pb.TagNumber(2)
  set password($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasPassword() => $_has(1);
  @$pb.TagNumber(2)
  void clearPassword() => clearField(2);
}

class MapMessage extends $pb.GeneratedMessage {
  factory MapMessage({
    $core.String? longitude,
    $core.String? latitude,
  }) {
    final $result = create();
    if (longitude != null) {
      $result.longitude = longitude;
    }
    if (latitude != null) {
      $result.latitude = latitude;
    }
    return $result;
  }
  MapMessage._() : super();
  factory MapMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory MapMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'MapMessage', createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'longitude')
    ..aOS(2, _omitFieldNames ? '' : 'latitude')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  MapMessage clone() => MapMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  MapMessage copyWith(void Function(MapMessage) updates) => super.copyWith((message) => updates(message as MapMessage)) as MapMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static MapMessage create() => MapMessage._();
  MapMessage createEmptyInstance() => create();
  static $pb.PbList<MapMessage> createRepeated() => $pb.PbList<MapMessage>();
  @$core.pragma('dart2js:noInline')
  static MapMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<MapMessage>(create);
  static MapMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get longitude => $_getSZ(0);
  @$pb.TagNumber(1)
  set longitude($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLongitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearLongitude() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get latitude => $_getSZ(1);
  @$pb.TagNumber(2)
  set latitude($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLatitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLatitude() => clearField(2);
}

class ChatMessage extends $pb.GeneratedMessage {
  factory ChatMessage({
    $core.String? recipientId,
    UserInfo? sender,
    MessageType? messageType,
    $core.String? content,
    MapMessage? mapMessage,
    $core.String? sendtime,
  }) {
    final $result = create();
    if (recipientId != null) {
      $result.recipientId = recipientId;
    }
    if (sender != null) {
      $result.sender = sender;
    }
    if (messageType != null) {
      $result.messageType = messageType;
    }
    if (content != null) {
      $result.content = content;
    }
    if (mapMessage != null) {
      $result.mapMessage = mapMessage;
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
    ..aOM<UserInfo>(3, _omitFieldNames ? '' : 'sender', subBuilder: UserInfo.create)
    ..e<MessageType>(4, _omitFieldNames ? '' : 'messageType', $pb.PbFieldType.OE, protoName: 'messageType', defaultOrMaker: MessageType.TEXT, valueOf: MessageType.valueOf, enumValues: MessageType.values)
    ..aOS(5, _omitFieldNames ? '' : 'content')
    ..aOM<MapMessage>(7, _omitFieldNames ? '' : 'mapMessage', protoName: 'mapMessage', subBuilder: MapMessage.create)
    ..aOS(11, _omitFieldNames ? '' : 'sendtime')
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

  /// ConversationType conversationType = 2;//群聊，私聊
  @$pb.TagNumber(3)
  UserInfo get sender => $_getN(1);
  @$pb.TagNumber(3)
  set sender(UserInfo v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSender() => $_has(1);
  @$pb.TagNumber(3)
  void clearSender() => clearField(3);
  @$pb.TagNumber(3)
  UserInfo ensureSender() => $_ensure(1);

  @$pb.TagNumber(4)
  MessageType get messageType => $_getN(2);
  @$pb.TagNumber(4)
  set messageType(MessageType v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasMessageType() => $_has(2);
  @$pb.TagNumber(4)
  void clearMessageType() => clearField(4);

  @$pb.TagNumber(5)
  $core.String get content => $_getSZ(3);
  @$pb.TagNumber(5)
  set content($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(5)
  $core.bool hasContent() => $_has(3);
  @$pb.TagNumber(5)
  void clearContent() => clearField(5);

  /// FileMessage FileMessage = 6;//文件消息
  @$pb.TagNumber(7)
  MapMessage get mapMessage => $_getN(4);
  @$pb.TagNumber(7)
  set mapMessage(MapMessage v) { setField(7, v); }
  @$pb.TagNumber(7)
  $core.bool hasMapMessage() => $_has(4);
  @$pb.TagNumber(7)
  void clearMapMessage() => clearField(7);
  @$pb.TagNumber(7)
  MapMessage ensureMapMessage() => $_ensure(4);

  @$pb.TagNumber(11)
  $core.String get sendtime => $_getSZ(5);
  @$pb.TagNumber(11)
  set sendtime($core.String v) { $_setString(5, v); }
  @$pb.TagNumber(11)
  $core.bool hasSendtime() => $_has(5);
  @$pb.TagNumber(11)
  void clearSendtime() => clearField(11);
}

///
/// message AddFriendMessage{
/// string recipientId = 1;
/// UserInfo sender = 2;
/// }
class AddGroupMessage extends $pb.GeneratedMessage {
  factory AddGroupMessage({
    $core.Iterable<$core.String>? recipientIds,
    RoomInfo? room,
    UserInfo? sender,
  }) {
    final $result = create();
    if (recipientIds != null) {
      $result.recipientIds.addAll(recipientIds);
    }
    if (room != null) {
      $result.room = room;
    }
    if (sender != null) {
      $result.sender = sender;
    }
    return $result;
  }
  AddGroupMessage._() : super();
  factory AddGroupMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory AddGroupMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'AddGroupMessage', createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'recipientIds', protoName: 'recipientIds')
    ..aOM<RoomInfo>(2, _omitFieldNames ? '' : 'room', subBuilder: RoomInfo.create)
    ..aOM<UserInfo>(3, _omitFieldNames ? '' : 'sender', subBuilder: UserInfo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  AddGroupMessage clone() => AddGroupMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  AddGroupMessage copyWith(void Function(AddGroupMessage) updates) => super.copyWith((message) => updates(message as AddGroupMessage)) as AddGroupMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddGroupMessage create() => AddGroupMessage._();
  AddGroupMessage createEmptyInstance() => create();
  static $pb.PbList<AddGroupMessage> createRepeated() => $pb.PbList<AddGroupMessage>();
  @$core.pragma('dart2js:noInline')
  static AddGroupMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<AddGroupMessage>(create);
  static AddGroupMessage? _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get recipientIds => $_getList(0);

  @$pb.TagNumber(2)
  RoomInfo get room => $_getN(1);
  @$pb.TagNumber(2)
  set room(RoomInfo v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasRoom() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoom() => clearField(2);
  @$pb.TagNumber(2)
  RoomInfo ensureRoom() => $_ensure(1);

  @$pb.TagNumber(3)
  UserInfo get sender => $_getN(2);
  @$pb.TagNumber(3)
  set sender(UserInfo v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasSender() => $_has(2);
  @$pb.TagNumber(3)
  void clearSender() => clearField(3);
  @$pb.TagNumber(3)
  UserInfo ensureSender() => $_ensure(2);
}

class LoarMessage extends $pb.GeneratedMessage {
  factory LoarMessage({
    LoarMessageType? loarMessageType,
    ChatMessage? message,
    AddGroupMessage? addGroupMessage,
    $core.int? sendCount,
  }) {
    final $result = create();
    if (loarMessageType != null) {
      $result.loarMessageType = loarMessageType;
    }
    if (message != null) {
      $result.message = message;
    }
    if (addGroupMessage != null) {
      $result.addGroupMessage = addGroupMessage;
    }
    if (sendCount != null) {
      $result.sendCount = sendCount;
    }
    return $result;
  }
  LoarMessage._() : super();
  factory LoarMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory LoarMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'LoarMessage', createEmptyInstance: create)
    ..e<LoarMessageType>(1, _omitFieldNames ? '' : 'loarMessageType', $pb.PbFieldType.OE, protoName: 'loarMessageType', defaultOrMaker: LoarMessageType.CHAT_MESSAGE, valueOf: LoarMessageType.valueOf, enumValues: LoarMessageType.values)
    ..aOM<ChatMessage>(2, _omitFieldNames ? '' : 'message', subBuilder: ChatMessage.create)
    ..aOM<AddGroupMessage>(5, _omitFieldNames ? '' : 'addGroupMessage', protoName: 'addGroupMessage', subBuilder: AddGroupMessage.create)
    ..a<$core.int>(12, _omitFieldNames ? '' : 'sendCount', $pb.PbFieldType.O3, protoName: 'sendCount')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  LoarMessage clone() => LoarMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  LoarMessage copyWith(void Function(LoarMessage) updates) => super.copyWith((message) => updates(message as LoarMessage)) as LoarMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static LoarMessage create() => LoarMessage._();
  LoarMessage createEmptyInstance() => create();
  static $pb.PbList<LoarMessage> createRepeated() => $pb.PbList<LoarMessage>();
  @$core.pragma('dart2js:noInline')
  static LoarMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<LoarMessage>(create);
  static LoarMessage? _defaultInstance;

  @$pb.TagNumber(1)
  LoarMessageType get loarMessageType => $_getN(0);
  @$pb.TagNumber(1)
  set loarMessageType(LoarMessageType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasLoarMessageType() => $_has(0);
  @$pb.TagNumber(1)
  void clearLoarMessageType() => clearField(1);

  @$pb.TagNumber(2)
  ChatMessage get message => $_getN(1);
  @$pb.TagNumber(2)
  set message(ChatMessage v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasMessage() => $_has(1);
  @$pb.TagNumber(2)
  void clearMessage() => clearField(2);
  @$pb.TagNumber(2)
  ChatMessage ensureMessage() => $_ensure(1);

  /// AddFriendMessage addFriendMessage = 3;
  /// AgreenAddFriendMessage agreenAddFriendMessage = 4;
  @$pb.TagNumber(5)
  AddGroupMessage get addGroupMessage => $_getN(2);
  @$pb.TagNumber(5)
  set addGroupMessage(AddGroupMessage v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasAddGroupMessage() => $_has(2);
  @$pb.TagNumber(5)
  void clearAddGroupMessage() => clearField(5);
  @$pb.TagNumber(5)
  AddGroupMessage ensureAddGroupMessage() => $_ensure(2);

  @$pb.TagNumber(12)
  $core.int get sendCount => $_getIZ(3);
  @$pb.TagNumber(12)
  set sendCount($core.int v) { $_setSignedInt32(3, v); }
  @$pb.TagNumber(12)
  $core.bool hasSendCount() => $_has(3);
  @$pb.TagNumber(12)
  void clearSendCount() => clearField(12);
}

class QrCodeData extends $pb.GeneratedMessage {
  factory QrCodeData({
    QrCodeType? qrCodeType,
    UserInfo? user,
    RoomInfo? room,
  }) {
    final $result = create();
    if (qrCodeType != null) {
      $result.qrCodeType = qrCodeType;
    }
    if (user != null) {
      $result.user = user;
    }
    if (room != null) {
      $result.room = room;
    }
    return $result;
  }
  QrCodeData._() : super();
  factory QrCodeData.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory QrCodeData.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'QrCodeData', createEmptyInstance: create)
    ..e<QrCodeType>(1, _omitFieldNames ? '' : 'qrCodeType', $pb.PbFieldType.OE, protoName: 'qrCodeType', defaultOrMaker: QrCodeType.QR_USER, valueOf: QrCodeType.valueOf, enumValues: QrCodeType.values)
    ..aOM<UserInfo>(2, _omitFieldNames ? '' : 'user', subBuilder: UserInfo.create)
    ..aOM<RoomInfo>(3, _omitFieldNames ? '' : 'room', subBuilder: RoomInfo.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  QrCodeData clone() => QrCodeData()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  QrCodeData copyWith(void Function(QrCodeData) updates) => super.copyWith((message) => updates(message as QrCodeData)) as QrCodeData;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static QrCodeData create() => QrCodeData._();
  QrCodeData createEmptyInstance() => create();
  static $pb.PbList<QrCodeData> createRepeated() => $pb.PbList<QrCodeData>();
  @$core.pragma('dart2js:noInline')
  static QrCodeData getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<QrCodeData>(create);
  static QrCodeData? _defaultInstance;

  @$pb.TagNumber(1)
  QrCodeType get qrCodeType => $_getN(0);
  @$pb.TagNumber(1)
  set qrCodeType(QrCodeType v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasQrCodeType() => $_has(0);
  @$pb.TagNumber(1)
  void clearQrCodeType() => clearField(1);

  @$pb.TagNumber(2)
  UserInfo get user => $_getN(1);
  @$pb.TagNumber(2)
  set user(UserInfo v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasUser() => $_has(1);
  @$pb.TagNumber(2)
  void clearUser() => clearField(2);
  @$pb.TagNumber(2)
  UserInfo ensureUser() => $_ensure(1);

  @$pb.TagNumber(3)
  RoomInfo get room => $_getN(2);
  @$pb.TagNumber(3)
  set room(RoomInfo v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasRoom() => $_has(2);
  @$pb.TagNumber(3)
  void clearRoom() => clearField(3);
  @$pb.TagNumber(3)
  RoomInfo ensureRoom() => $_ensure(2);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
