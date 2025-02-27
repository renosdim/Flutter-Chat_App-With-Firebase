import 'package:custom_chat_clean_architecture_with_login_firebase/flexibleApp/flexible_app_main.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/injection.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/current_user.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/formats.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/graphics_classes/chat_graphics_class.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../operations/chat/regular_chat/domain/entities/grou_message_entity.dart';
import '../../../../../operations/chat/regular_chat/domain/entities/message_entity.dart';
import '../../../../../operations/chat/regular_chat/dtos/chat_participant_dto.dart';
import '../../../../../operations/chat/regular_chat/dtos/group_chatroom_dto.dart';
import '../../../../../operations/chat/regular_chat/dtos/regular_chatroom_dto.dart';
import '../../../../../operations/chat/regular_chat/presentation/ChatService.dart';
import '../../../../../operations/common/dto.dart';

class ChatroomContentImmut extends StatefulWidget {
  final String chatroomId;

  const ChatroomContentImmut({super.key, required this.chatroomId});


  @override
  State<ChatroomContentImmut> createState() => _ChatroomContentImmutState();
}

class _ChatroomContentImmutState extends State<ChatroomContentImmut> {
  late final  ChatGraphicsClass chatGraphicsClass;
  late final  ChatService chatService;
  final CurrentUserOp currentUserOp = serviceLocator<CurrentUserOp>();

  @override
  void initState(){
    super.initState();


  }
  @override
  didChangeDependencies(){
    super.didChangeDependencies();
    chatService = Provider.of<ChatService>(context,listen: false);
    chatGraphicsClass = ChatGraphicsClass.of(context);

  }
  List<MessageBubbleFormat> _getGroupBubbles(GroupChatroomDTO chatroom){

    final List<dynamic> messages = chatroom.messages;
    final List<ChatParticipantDTO> friends = chatroom.participants;
    List<MessageBubbleFormat> bubbles  = [];
    for (var e in messages) {
      e = e as GroupMessage;
      DateTime? previousDateTime = bubbles.lastOrNull?.timestamp;

      ChatParticipantDTO? friend = friends.where((element) =>element.uid==e.senderUid).first;
      MessageBubbleFormat bubble = chatGraphicsClass.messageBubbleFormat.copyWith(
          key: ValueKey(e.key),
          mine: currentUserOp.currentUser.uid==e.senderUid,
          read: [],
          content: e.message,
          pic:friend.profilePic,
          header: friend.name,
          previousMessageTimestamp: previousDateTime,
          timestamp: DateTime.fromMillisecondsSinceEpoch(e.timestamp)

      );
      bubbles.add(bubble);

    }
    if(bubbles.isNotEmpty){
      bubbles.last = bubbles.last.copyWith(last: true);
    }

    return bubbles;
  }

  List<MessageBubbleFormat> _getRegularChatBubbles(RegularChatroomDTO chatroom){
    List<MessageBubbleFormat> bubbles = [];
    final List<dynamic> messages = chatroom.chatroomComponents;
    final ChatParticipantDTO friend = chatroom.chatParticipant;
    final String friendProfilePic = friend.profilePic;
    final String friendName = chatGraphicsClass.userNameInsteadOfName?friend.username:friend.name!;
    List<MessageBubbleFormat?> nullableBubbles = [];

    messages.forEach((e) {
      if (e is Message) {
        Message message = e;

        DateTime? previousDateTime = nullableBubbles.lastOrNull?.timestamp;
        bool mine = currentUserOp.currentUser.uid ==
            message.senderUid;
        MessageBubbleFormat messageBubble = chatGraphicsClass.messageBubbleFormat.copyWith(
          key: ValueKey(message.key),
          previousMessageTimestamp: previousDateTime,
          header: mine?currentUserOp.currentUser.name:friendName,
          pic: mine?currentUserOp.currentUser.photoURL:friendProfilePic,
          content: message.message,
          mine: mine,
          timestamp: DateTime.fromMillisecondsSinceEpoch(message.timestamp),
          read:message.read==true?[chatGraphicsClass.messageAlreadyReadFormat.copyWith(username: friend.username,name: friend.name,pic: friendProfilePic)]:[],
          last: false,

        );

        nullableBubbles.add(messageBubble);
      }

    });
    nullableBubbles.removeWhere((element) => element == null);

    for (var element in nullableBubbles) {
      bubbles.add(element!);
    }
    bubbles.last = bubbles.last.copyWith(last: true);
    return bubbles;
  }

  ChatroomContentFormat _convertChatroomToGraphics(ChatroomDTO chatroom){

    if(chatroom is RegularChatroomDTO) {

      List<MessageBubbleFormat> bubbles =  _getRegularChatBubbles(chatroom);

      final ChatParticipantDTO friend = chatroom.chatParticipant;
      final String friendProfilePic = friend.profilePic;
      final String friendName = chatGraphicsClass.userNameInsteadOfName?friend.username:friend.name!;

      return  chatGraphicsClass.chatroomContentFormat.copyWith(
        header: friendName,
        pic: chatGraphicsClass.picWidgetFormat.copyWith(profilePics:[friendProfilePic]),
        messages: bubbles,
        sendMessage: (mess,replyFor) async {
          chatService.sendMessage(friend.uid, mess,replyFor: replyFor);
        },);
    }
    else{
      List<MessageBubbleFormat> bubbles =  _getGroupBubbles(chatroom as GroupChatroomDTO);

      return chatGraphicsClass
          .chatroomContentFormat.copyWith(
          header: (chatroom).groupChatName,
          pic: chatGraphicsClass.picWidgetFormat.copyWith(
              profilePics: (chatroom).participants.map((e) => e.profilePic).toList()
          ),
          messages: bubbles,
          sendMessage:  (mess,replyFor) async {
            chatService.sendGroupMessage([],mess,chatroom.chatroomId);
          });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Selector<ChatService,ChatroomContentFormat>(
        selector: (_,chatService)=>_convertChatroomToGraphics(chatService.startingMessages![widget.chatroomId]!),
        builder: (BuildContext context, ChatroomContentFormat chatroomContent, Widget? child) {
          print('rerun');
          return chatroomContent;
        }
    );
  }

}


