class MessageReaction {
  final String messageId;
  final String userId;
  final String emoji;

  MessageReaction({
    required this.messageId,
    required this.userId,
    required this.emoji,
  });

  Map<String, dynamic> toJson() => {
    'messageId': messageId,
    'userId': userId,
    'emoji': emoji,
  };

  factory MessageReaction.fromJson(Map<String, dynamic> json) {
    return MessageReaction(
      messageId: json['messageId'],
      userId: json['userId'],
      emoji: json['emoji'],
    );
  }
}