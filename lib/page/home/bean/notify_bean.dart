import '../../../common/blue_tooth.dart';
import '../../../common/im_data.dart';

enum NotifyType {
  friendInvite,
  groupInvite,
  joinPublicGroupApproval,
}

class CommunicationStatue {
  bool get available =>
      BlueToothConnect.instance.isConnect() ||
      GlobeDataManager.instance.isEaseMob;
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
