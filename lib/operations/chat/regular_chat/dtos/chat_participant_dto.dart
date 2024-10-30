class ChatParticipantDTO{
  final String uid;
  final String? name;
  final String username;
  final String profilePic;
  const ChatParticipantDTO({required this.username,required this.uid,required this.name,required this.profilePic});
}