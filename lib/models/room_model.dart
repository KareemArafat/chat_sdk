class RoomModel {
  final String roomId;
  final String? name;
  final String? type;
  final LastMassage? lastMessage;
  final List<String>? users;

  RoomModel(
      {required this.roomId,
      this.name,
      this.type,
      this.lastMessage,
      this.users});

  factory RoomModel.fromJson(jsonData) {
    return RoomModel(
      roomId: jsonData['id'],
      name: jsonData['name'],
      type: jsonData['type'],
      users: List<String>.from(jsonData['members']),
      lastMessage: jsonData['lastMessage'] != null
          ? LastMassage.fromJson(jsonData['lastMessage'])
          : null,
    );
  }
}

class LastMassage {
  final String messType;
  final String time;
  final String? text;
  final String? fileName;
  final String? fileType;

  LastMassage({
    required this.messType,
    required this.time,
    this.text,
    this.fileName,
    this.fileType,
  });

  factory LastMassage.fromJson(jsonData) {
    return LastMassage(
      messType: jsonData['type'],
      time: jsonData['createdAt'],
      text: jsonData['content'],
      fileName: jsonData['fileName'],
      fileType: jsonData['fileType'],
    );
  }
}
