import 'dart:async';

import 'package:custom_chat_clean_architecture_with_login_firebase/operations/chat/regular_chat/data/models/regular_chatroom_model.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/chat/regular_chat/data/models/message_model.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/common/entities/chatroom_entity.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../auth/current_user.dart';
import '../../../../common/failures/failure.dart';
import '../../../../common/successes/success.dart';
import '../models/group_chat_model.dart';
import '../models/group_message_model.dart';


class MessageRemoteSource{
  final DatabaseReference _database = FirebaseDatabase.instance.ref();
  final CurrentUserOp _currentUserOp;
  MessageRemoteSource({required CurrentUserOp currentUserOp}):_currentUserOp = currentUserOp;
  Future<Either<Failure, ChatroomEntity>> getChatroomMessages(String chatroomId) async {


    if(chatroomId.startsWith('group')){
      print('group messages get');
      return await getGroupMessages(chatroomId);
    }
    try {
      // Replace this with your actual Realtime Database reference
      DatabaseReference messagesRef = _database.child('chat_rooms').child(
          chatroomId).child('messages');

      // Order the messages by timestamp in descending order
      print('before');

      //DatabaseEvent event = await messagesRef.orderByChild('timestamp').once();
      DataSnapshot snapshot = await messagesRef.orderByChild('timestamp').get() ;
      print('snapshot');
      if (!snapshot.exists) {
        return  Left(ChatroomExistenceFailure());
      }
        RegularChatroomModel chatroomModel = RegularChatroomModel.fromDataSnapshot(snapshot, chatroomId);

        return Right(chatroomModel);
        //startingMessages[chatroomId] = snapshot;


    }
    catch (e) {

      return Left(MessageFailure(message: e));
    }
  }
  Either<Failure, Stream<Either<Failure,ChatroomEntity>>> setUpChatSubscription(String chatroomId) {
    try {
      if (chatroomId.contains('group')) {

        return _setUpGroupChatListener(chatroomId);
      }
      else {
        // Try setting up the stream for a regular chatroom first
        Stream<Either<Failure,ChatroomEntity>> regularChatStream = _database
            .child('chat_rooms')
            .child(chatroomId)
            .child('messages')
            .limitToLast(10)
            .orderByChild('timestamp')
            .onValue
            .map((event) {
          if (event.snapshot.exists) {
            try {
              // Try to create a RegularChatroomModel
              return Right(RegularChatroomModel.fromDataSnapshot(
                  event.snapshot, chatroomId));
            } catch (e) {
              // Catch and throw specific NotRegularChatFailure for later handling
              if (e is NotRegularChatFailure) {
                throw e;
              }
              // For other exceptions, you can choose to return null or rethrow
              throw UnexpectedError(
                  message: 'Unexpected error during chatroom processing.');
            }
          }
          return Left(ChatroomExistenceFailure()); // No data case
        });

        // Listen for errors in the regular chat stream, particularly for NotRegularChatFailure
        return Right(regularChatStream.handleError((error) {
          if (error is NotRegularChatFailure) {
            print('Regular chat not found, setting up group chat listener.');
            // Return a new group chat stream if it's determined to be a group chat
            return _setUpGroupChatListener(chatroomId).fold(
                  (failure) => throw failure,
              // Rethrow failure to be handled outside
                  (
                  groupChatStream) => groupChatStream, // Return the group chat stream
            );
          } else {
            throw error; // Handle other errors by rethrowing them
          }
        }));
      }
      } catch (e) {

      return Left(MessageListenerFailure(
          message: e.toString())); // Return generic failure
    }

  }

  Either<Failure, Stream<Either<Failure, GroupChatModel>>> _setUpGroupChatListener(String chatroomId) {
    try {
      print('Setting up group chat listener for $chatroomId');

      Stream<Either<Failure, GroupChatModel>> groupChatStream = _database
          .child('chat_rooms')
          .child(chatroomId)
          .onValue
          .map((event) {
              try {
                if (event.snapshot.exists) {
                  print('chatroom group $chatroomId exists');
                  return Right(GroupChatModel.fromDataSnapshot(
                      event.snapshot, event.snapshot.key as String));
                } else {
                  return Left(ChatroomExistenceFailure()) ;// The key here is returning an Either type
                }
              }
              catch(e){
                return Left(UnexpectedError(message: ''));
              }

      });  // Make sure the error is handled as an Either<Failure, GroupChatModel?>

      return Right(groupChatStream.handleError((error){
        if(error is FirebaseException && error.code == 'PERMISSION_DENIED'){
          return Left(ChatroomPermissionDeniedFailure());
        }

      }));  // Return the Either<Failure, Stream<Either<Failure, GroupChatModel?>>>
    } catch (e) {
      print('Error setting up group chat listener: $e');
      return Left(UnexpectedError(message: e.toString()));  // Return an Either in the case of error
    }
  }
  Future<Either<Failure, Success>> sendMessage(String receiverUid, String message,{String? replyFor}) async {

    final String currentUserUid = _currentUserOp.currentUser.uid;

    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    List<String> ids = [currentUserUid, receiverUid];
    ids.sort();
    String chatroomId = ids.join('_');

    DatabaseReference messageRef = _database.child('chat_rooms').child(chatroomId).child('messages').push();
    MessageModel newMessage = MessageModel(
      senderUid: currentUserUid,
      receiverUid: receiverUid,
      message: message,
      timestamp: timestamp,
      replyForMessageKey:replyFor ,

      read: false, key: messageRef.key as String,
    );




    Map<String, dynamic> mess = newMessage.toMap();

    try {
      // Replace this with your real-time database reference


      await messageRef.set(mess);
      DatabaseReference latestChatsMine  = _database.child('latest_chats_list').child(currentUserUid).child('chatrooms');
      DatabaseReference latestChatsTheirs  = _database.child('latest_chats_list').child(receiverUid).child('chatrooms');
      //DataSnapshot messageReftwo = await latestChats.child('chatrooms').get();
      //Map<String,dynamic> ex ={};
      // if(messageReftwo.exists){
      //  ex = Map<String,dynamic>.from(messageReftwo.value as Map);
      //
      // }
      //ex[chatroomId] = timestamp;
      
      await latestChatsMine.update({
        chatroomId :timestamp
      });
      await latestChatsTheirs.update({
        chatroomId :timestamp
      });
      return Right(MessageSent());
    } catch (e) {

      // Handle specific Firebase error codes
      if (e.toString().contains('operation-not-allowed')) {
        // Handle operation not allowed error

        return Left(MessageFailure(message: 'Operation not allowed.'));
      } else if (e.toString().contains('user-disabled')) {
        // Handle user disabled error

        return Left(MessageFailure(message: 'userAccountDisabled'));
      } else {
        // Handle other errors

        return Left(MessageFailure(message: 'Unexpected error please try again'));
      }
    }
  }
  Future<void> markGroupMessageAsRead(String messageKey,String chatroomId) async{
    DatabaseReference lastMessage = FirebaseDatabase.instance.ref().child('chat_rooms').child(chatroomId).child('messages').child(messageKey);

    DatabaseEvent event = await lastMessage.once() ;
    //print(snapshot);
    DataSnapshot snapshot = event.snapshot ;
    String currentUserId = _currentUserOp.currentUser.uid;
    dynamic snap = snapshot.value ;

    if (snap['read']==null){
      lastMessage.update({
        'read': {currentUserId:'read'}
      });
    }

    else{
      if(!snap['read'].keys.toList().contains(currentUserId)) {
        snap['read'][currentUserId]='read';
        lastMessage.update({
          'read': snap['read']
        });
      }
    }
  }
  Future<Either<Failure,Success>> sendGroupMessage(List<String> receiverUids, String message, String postId) async {

    final String currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final int timestamp = DateTime.now().millisecondsSinceEpoch;


    try {
      // Replace this with your real-time database reference
      DatabaseReference messageRef = _database.child('chat_rooms').child(postId).child('messages').push();
      GroupMessageModel newMessage = GroupMessageModel(
        key: messageRef.key as String,
        senderUid: currentUserUid,

        receiverUids: receiverUids,
        message: message,
        timestamp: timestamp,
        read: {},
      );

      List<String> ids = [currentUserUid];
      for (var element in receiverUids) {
        ids.add(element);
      }

      Map<String, dynamic> mess = newMessage.toMap();

      await messageRef.set(mess);


      return Right(MessageSent());
    } catch (e) {

      // Handle specific Firebase error codes
      if (e.toString().contains('operation-not-allowed')) {
        // Handle operation not allowed error

        return Left(OperationNotAllowedFailure());
      } else if (e.toString().contains('user-disabled')) {
        // Handle user disabled error

        return Left(AccountDisabedFailure());
      } else {
        // Handle other errors

        return Left(UnexpectedError(message: e));
      }
    }
  }
  Future<Either<Failure,GroupChatModel>> getGroupMessages(String chatroomId) async {
    try{
      DatabaseEvent event = await _database.child('chat_rooms')

          .child(chatroomId)
          .once();

      if(event.snapshot.exists){
        return Right(GroupChatModel.fromDataSnapshot(event.snapshot, chatroomId));
      }
      else{
        return Left(ChatroomExistenceFailure());
      }
    }
    catch(error){
      if(error is FirebaseException && error.code == 'PERMISSION_DENIED'){
        return Left(ChatroomPermissionDeniedFailure());
      }
      return Left(MessagesRetrievedFailure());
    }



  }



  Either<Failure, Stream<RegularChatroomModel?>> setUpStartingChatSubscriptions(){
    return Right(_database.child('chat_rooms').child('').startAt('PMpszToXp9b7E4LHuMM9loSxSoH2_lJrVY153qfgvbUyoq6hZSouFflr1').onValue.map(
            (event) => event.snapshot.exists?RegularChatroomModel.fromDataSnapshot(event.snapshot, event.snapshot.key!):null
    ));

  }
}