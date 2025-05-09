class MessageReact {
  final String messageId;
  final String senderId;
  final String emoji;

  MessageReact({
    required this.messageId,
    required this.senderId,
    required this.emoji,
  });

  factory MessageReact.fromJson(Map<String, dynamic> json) {
    return MessageReact(
      messageId: json['messageId'],
      senderId: json['senderId'],
      emoji: json['emoji'],
    );
  }

  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'senderId': senderId,
        'emoji': emoji,
      };
}
