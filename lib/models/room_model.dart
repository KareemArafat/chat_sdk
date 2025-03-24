class RoomModel {
  final String roomId;
  final String name;
  final String type;
  final String? lastMessage;
  final String? time;
  final List<String> users;

  RoomModel(
      {required this.roomId,
      required this.name,
      required this.type,
      this.lastMessage,
      this.time,
      required this.users});

  factory RoomModel.fromJson(jsonData) {
    return RoomModel(
      roomId: jsonData['_id'],
      name: jsonData['name'],
      type: jsonData['type'],
      users: List<String>.from(jsonData['members']),
  //    lastMessage: jsonData[''],
    //  time: jsonData[''],
    );
  }
}
