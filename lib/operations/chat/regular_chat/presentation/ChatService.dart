import 'dart:async';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/chat/regular_chat/domain/usecases/get_starting_messages_usecase.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/chat/regular_chat/domain/usecases/send_message_usecase.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/chat/regular_chat/domain/usecases/set_up_starting_chat_listeners.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/chat/regular_chat/dtos/regular_chatroom_dto.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import '../../../auth/current_user.dart';
import '../../../common/dto.dart';
import '../../../common/failures/failure.dart';
import '../../../generalOp.dart';
import '../domain/usecases/send_group_message_usecase.dart';
import '../dtos/group_chatroom_dto.dart';
import '../domain/usecases/setup_chat_listener_usecase.dart';


class ChatSubscriptions{
  final String chatroomId;
  final StreamSubscription<Either<Failure,ChatroomDTO>> chatSub;

  const ChatSubscriptions(this.chatroomId, this.chatSub);

  void cancel(){
    chatSub.cancel();

  }
}
class ChatService extends ChangeNotifier {



    Map<String, ChatroomDTO> _startingMessages = {};
  Set<String> _chatIds = {};
  Map<String,ChatSubscriptions> _friendSubscriptions = {};

  final GetStartingMessages getStartingMessagesUseCase;
  final SendMessage sendMessageUseCase;
  final SendGroupMessage sendGroupMessageUseCase;
  final SetUpChatListener setUpChatListener;

  final SetUpStartingChatListeners startingChatListeners;

   bool gotStartingMessages  = false;
   bool loadedFirstTime = false;
  final CurrentUserOp currentUserOp;
  ChatService( {
      required this.currentUserOp,

      required this.startingChatListeners,
      required this.getStartingMessagesUseCase,
      required this.sendMessageUseCase,
      required this.sendGroupMessageUseCase,
      required this.setUpChatListener,
      });
  Map<String,ChatroomDTO>? get startingMessages  => _startingMessages;

  String getChatroomId(List<String> uids){
    uids = getUniqueList(uids);
    uids.sort();
    String chatroomId = uids.join('_');

    return chatroomId;
  }
  String getfriendIdFromChatroomId(String chatroomId){
    if(chatroomId.contains('group')){
      return chatroomId;
    }
    List<String> ids  = chatroomId.split('_');
    String friendId = ids.where((element) => element!=currentUserOp.currentUser.uid).first;
    return friendId;
  }



  // Static private instance

  Future<void> markAsRead(String lastKey,String chatroomId) async{

    FirebaseDatabase.instance.ref().child('chat_rooms').child(chatroomId).child('messages').child(lastKey).update({
      'read':true
    });


  }

  void addChatSubscription(String chatroomId) {
    // Dispose of any existing subscription for the same chat room
    // Set up a new subscription for the specified chat room
    if (_friendSubscriptions[chatroomId] != null) {
      print('chatroom already has a listener');
      return;
    }



      _friendSubscriptions[chatroomId] =chat(chatroomId);
    }



  void logoutCleanup() {
    // Cancel all friend subscriptions
    _friendSubscriptions.forEach((chatroomId, subscription) {
      subscription.cancel(); // Cancel each subscription
    });
    _friendSubscriptions.clear(); // Clear the map



    // Clear out starting messages and group messages
    _startingMessages.clear();


    // Reset loading states and other related flags

    gotStartingMessages = false;
    loadedFirstTime = false;



  }
  // Singleton instance
  void dispose() {
    super.dispose();

    logoutCleanup();
  }

  Future<bool> enable() async {
    try{
      if(loadedFirstTime==false) {


        print('started chat service');
       //await getStartingMessages();
        //bool result2 = await getGroupMessages();
        await _listenToPendingRequestsChanges();
        loadedFirstTime = true;
        print('successfully enabled chatService');
        return true;
      }
      else{
        print('already fetched chat service');

        return true;
      }
    }
    catch(e){
      print('error enabling chat service $e');
      return false;
    }

  }


  void sendGroupMessage(List<String> receiverUids, String message, String postId) async {
    await sendGroupMessageUseCase(receiverUids, message,postId);
  }


 void sendMessage(String receiverUid, String message,{String? replyFor}) async {

    await sendMessageUseCase(receiverUid,message,replyFor: replyFor);

  }




  ChatSubscriptions chat(String chatroomId) {


    // Dispose of any existing subscription for the same chat room

    if(_friendSubscriptions[chatroomId]!=null){
      return _friendSubscriptions[chatroomId]!;
    }
    final Either<Failure,Stream<Either<Failure,ChatroomDTO>>> chatListenerStream = setUpChatListener(chatroomId);
    if(chatListenerStream.isRight){
      StreamSubscription<Either<Failure,ChatroomDTO>> chatroomSub =chatListenerStream.right.listen((chatroom) {
        if(chatroom.isRight){
          _startingMessages[chatroomId] = chatroom.right;
          notifyListeners();
        }
        else{
          if(_startingMessages[chatroomId]!=null) {
            _startingMessages.remove(chatroomId);
            notifyListeners();
          }
        }


      });

      return ChatSubscriptions(chatroomId, chatroomSub);
    }
    else{
      throw MessageFailure(message: 'message');
    }



  }







  Future<bool> _listenToPendingRequestsChanges() async {







      //print('started ${currentUserOp.currentUser.existingChats}');

      currentUserOp.getStartingChats().listen((event){

        event?.forEach((key, value) {
          String chatroomId =key;
          _chatIds.add(key);
          print('chatrromId$chatroomId');
          if(_friendSubscriptions[chatroomId]==null){
            _friendSubscriptions[chatroomId]= chat(chatroomId);

          }
          // Set up subscriptions for each friend's chat room

        });
        if(event==null){
          _startingMessages = {};
          notifyListeners();
        }


      });
      return true;




  }



  Future<bool> getStartingMessages() async {
    print('started loading starting messages');
    print(currentUserOp.currentUser.friends);
    if(_chatIds.isNotEmpty){
      for (String chatroomId in _chatIds){
        Either<Failure,ChatroomDTO?> getStartingMessages = await getStartingMessagesUseCase(chatroomId);
        if(getStartingMessages.isRight) {
          print('got messages for $chatroomId');
          if (getStartingMessages.right != null) {
            ChatroomDTO chatroomDTO = getStartingMessages.right!;
            if (chatroomDTO is RegularChatroomDTO) {
              _startingMessages[chatroomDTO.chatroomId] =
              getStartingMessages.right!;
            }
            else if (chatroomDTO is GroupChatroomDTO) {
              _startingMessages[chatroomDTO.chatroomId] =
              getStartingMessages.right!;
            }
          }
        }
        else{
          print('didnt get for $chatroomId');
          if(_startingMessages[chatroomId]!=null){
            _startingMessages.remove(chatroomId);
            notifyListeners();
          }
        }

      }
      print('starting messages $startingMessages');
      notifyListeners();
    }



    return true;
  }


}