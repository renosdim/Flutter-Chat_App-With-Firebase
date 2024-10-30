class GroupMessage {

  final List receiverUids;
  final String senderUid;

  final String message;
  final int timestamp;
  final Map read;
  final String key;

  GroupMessage({
    required this.receiverUids,
    required this.senderUid,
    required this.message, required this.timestamp,
    required this.read,
    required this.key});

}