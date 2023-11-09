enum NotifyType {
  friend,
  group,
}

class NotifyBean {
  NotifyType type;
  String inviter;
  String? groupId;
  String? name;
  String? reason;
  String time;

  NotifyBean(this.type, this.inviter, this.time,{this.groupId,this.name,this.reason});
}
