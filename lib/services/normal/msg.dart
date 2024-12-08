class Msg {
  int applicationId;
  int type;
  String applyUserName;
  String applyUserAvatar;
  String applyMsg;
  String? roomName;
  String applyTime;
  int status;

  Msg({
    required this.applicationId,
    required this.applyUserName,
    required this.applyUserAvatar,
    required this.applyMsg,
    required this.applyTime,
    required this.type,
    required this.status,
  });

  Msg.fromjson(Map<String, dynamic> json)
      : applicationId = json['applicationId'],
        applyUserName = json['applyUserName'],
        applyUserAvatar = json['applyUserAvatar'],
        applyMsg = json['applyMsg'],
        applyTime = json['applyTime'],
        status = json['status'],
        type = 0;
}
