abstract class Success{
  final String message;
  Success({required this.message});
}
class MessageSent implements Success{
  @override
  // TODO: implement message
  String get message => 'Message sent sucessfuly';

}
class PostCreated implements Success{
  @override
  // TODO: implement message
  String get message => 'Post created successfully';

}

class PostUpdated implements Success{
  @override
  // TODO: implement message
  String get message => 'Post updated successfully';

}
class VoteCreated implements Success{
  @override
  // TODO: implement message
  get message => throw 'Vote started successfully';

}
class ReservationCreated implements Success{
  @override
  // TODO: implement message
  String get message => 'Reservation created successfully';

}
class InviteAccepted implements Success{
  @override
  // TODO: implement message
  String get message => 'Invite accepted';

}
