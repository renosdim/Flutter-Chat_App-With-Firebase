abstract class Failure{
  final message;
  Failure({required this.message});
}

class MessageFailure extends Failure{
  MessageFailure({required super.message});

}
class NotRegularChatFailure implements Failure{
  @override
  // TODO: implement message
  get message => 'this isnt a regular chat message. check with group';

}

class ChatroomPermissionDeniedFailure implements Failure{
  @override
  // TODO: implement message
  get message => 'you dont have access to this chatroom';

}
class ChatroomExistenceFailure implements Failure{
  @override
  // TODO: implement message
  get message => 'Chatroom doesnt exist anymore';

}
class MessagesRetrievedFailure implements Failure{
  @override
  // TODO: implement message
  get message => 'There was an error retriving the messages';

}
class MessageListenerFailure extends Failure{
  MessageListenerFailure({required super.message});

}
class PostCreateFailure extends Failure{
  PostCreateFailure({required super.message});

}
class InternetConnectionFailure implements Failure{
  @override
  // TODO: implement message
  get message => 'Check your internet connection and try again';

}
class PostUpdateFailure extends Failure{
  PostUpdateFailure({required super.message});

}
class PostNotFoundFailure implements Failure{
  @override
  // TODO: implement message
  get message => '';

}
class UnexpectedError extends Failure{
  UnexpectedError({required super.message});



}

class VoteAlreadyInProgressFailure implements Failure{
  @override
  // TODO: implement message
  get message => throw 'Vote is already in progress';

}
class ReservationListenerFailure extends Failure{
  ReservationListenerFailure({required super.message});

}
class ReservationCreateFailure extends Failure{
  ReservationCreateFailure({required super.message});

}
class UserRetrievalFailure extends Failure{
  UserRetrievalFailure({required super.message});

}
class UserNotFoundFailure implements Failure{
  @override
  // TODO: implement message
  get message => 'User was not found';

}

class OperationNotAllowedFailure implements Failure{
  @override
  // TODO: implement message
  get message => 'Not allowed';

}
class NotAuthenticatedFailure implements Failure{
  @override
  // TODO: implement message
  get message => throw 'Not authenticated user';

}

class AccountDisabedFailure implements Failure{
  @override
  // TODO: implement message
  get message => 'Account disabled';

}

class CurrentUserAccountNotFoundFailure implements Failure{
  @override
  // TODO: implement message
  get message => '';

}
class InviteAcceptanceFailure extends Failure{
  InviteAcceptanceFailure({required super.message});

}

