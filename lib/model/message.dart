class Message {
  final bool isMine;
  String text;
  final String id;

  Message({
    required this.id,
    required this.text,
    required this.isMine,
  });
}
