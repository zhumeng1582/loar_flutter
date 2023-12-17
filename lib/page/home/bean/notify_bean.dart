enum NotifyType {
  friendInvite,
  groupInvite,
  joinPublicGroupApproval,
}

class CommunicationStatue {
  bool available = false;

  CommunicationStatue(this.available);
}

class NotifyBean {
  NotifyType type;
  String? inviter;
  String? applicant;
  String? groupId;
  String? name;
  String? reason;
  String time;

  NotifyBean(this.type, this.time,
      {this.inviter, this.applicant, this.groupId, this.name, this.reason});
}
