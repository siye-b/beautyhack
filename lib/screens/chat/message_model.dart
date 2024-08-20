class Message {
  final String userID;
  final String text;
  final DateTime date;
  final bool isSentByMe;

  const Message ( {
    required this.userID,
     required this.text,
     required this.date,
     required this.isSentByMe
  });
}

