
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/chat/regular_chat/domain/entities/grou_message_entity.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/chat/regular_chat/domain/entities/message_entity.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/chat/regular_chat/dtos/chat_participant_dto.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/chat/regular_chat/dtos/regular_chatroom_dto.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/chatroom_content_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/message_bubble_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/read_message_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/scrolling_and_refreshing_format.dart';
import 'package:flutter/cupertino.dart';

import '../../../../screens/chat/regular_chat/immutable/formats/chat_tile_format.dart';
import '../../../common/dto.dart';
import '../dtos/group_chatroom_dto.dart';
import 'ChatService.dart';

extension ChatServiceGraphicsClass on ChatService{
  int _compare(ChatTileFormat a, ChatTileFormat b) {
    DateTime otherTimestamp = b.lastMessage!.timestamp!;
    DateTime thisTimestamp = a.lastMessage!.timestamp!;
    return otherTimestamp.compareTo(thisTimestamp);
  }


  ScrollingAndRefreshingFormat addChatTilesToEnclosingSpace(List<ChatTileFormat> chatTiles,Future<void> Function()? onRefresh){
    chatTiles.sort(_compare);
    return chatGraphicsClass.scrollingAndRefreshingFormat.copyWith(chatTiles:chatTiles,onRefresh: onRefresh );
  }

  List<MessageBubbleFormat> _getGroupBubbles(GroupChatroomDTO chatroom){
    final List<dynamic> messages = chatroom.messages;
    final List<ChatParticipantDTO> friends = chatroom.participants;
    List<MessageBubbleFormat> bubbles  = [];
    messages.forEach((e) {
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

    });
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

  ChatroomContentFormat convertChatroomToGraphics(String chatroomId){
    ChatroomDTO chatroom = startingMessages![chatroomId]!;
    if(chatroom is RegularChatroomDTO) {

     List<MessageBubbleFormat> bubbles =  _getRegularChatBubbles(chatroom);

     final ChatParticipantDTO friend = chatroom.chatParticipant;
     final String friendProfilePic = friend.profilePic;
     final String friendName = chatGraphicsClass.userNameInsteadOfName?friend.username:friend.name!;

    return  chatGraphicsClass.chatroomContentFormat.copyWith(
            header: friendName,
            pic: chatGraphicsClass.picWidgetFormat.copyWith([friendProfilePic]),
            messages: bubbles,
            sendMessage: (mess,replyFor) async {
            sendMessage(friend.uid, mess,replyFor: replyFor);
            },);
    }
    else{
      List<MessageBubbleFormat> bubbles =  _getGroupBubbles(chatroom as GroupChatroomDTO);

      return chatGraphicsClass
          .chatroomContentFormat.copyWith(
          header: (chatroom).groupChatName,
          pic: chatGraphicsClass.picWidgetFormat.copyWith(
              (chatroom).participants.map((e) => e.profilePic).toList()
          ),
          messages: bubbles,
          sendMessage:  (mess,replyFor) async {
            sendGroupMessage([],mess,chatroom.chatroomId);
          });
    }
  }
  int countUnreadMessages(List<dynamic> chatroomComponents,{int index=0,int count=0}){
    try {

        if (chatroomComponents[index].read == false &&
            chatroomComponents[index].senderUid !=
                currentUserOp.currentUser.uid) {
          return countUnreadMessages(
              chatroomComponents, index: index + 1, count: count + 1);
        }
        else {
          return count;
        }

    }catch(e){
      return count;
    }
  }
  ChatTileFormat? convertChatroomDTOtoChatTile(ChatroomDTO? chatroom,Function(String) onChatroomPressed){


    if(chatroom is RegularChatroomDTO) {
      final chatParticipant = chatroom.chatParticipant;
      final unreadCount = countUnreadMessages(chatroom.chatroomComponents.reversed.toList());
      print('unreadCount %$unreadCount  ${chatroom.chatroomId}');

      final lastMessage = chatroom.chatroomComponents.isNotEmpty
          ? chatroom.chatroomComponents.last
          : null;
      final mine = lastMessage.senderUid == currentUserOp.currentUser.uid;
      final lastMessageSender =mine? chatGraphicsClass.userNameInsteadOfName?chatParticipant.username:chatParticipant.name!:
      chatGraphicsClass.userNameInsteadOfName?currentUserOp.currentUser.username:currentUserOp.currentUser.name!;
      final header =  chatGraphicsClass.userNameInsteadOfName?chatParticipant.username:chatParticipant.name!;
      final chatTile = chatGraphicsClass.regularChatTileFormat.copyWith(


          lastMessage: chatGraphicsClass.chatTileLastMessageFormat.copyWith
            (timestamp: DateTime.fromMillisecondsSinceEpoch(
              lastMessage.timestamp),
              content: lastMessage.message,
              read: lastMessage.read ?? false,
              mine: mine,
              senderName: lastMessageSender),
          header: header,
          pic: chatGraphicsClass.picWidgetFormat.copyWith(
              [chatParticipant.profilePic]),

          onChatroomPressed: () =>
              onChatroomPressed(chatroom.chatroomId)
      );
      return chatTile;
    }
    else if(chatroom is GroupChatroomDTO){
      final lastMessage = chatroom.messages.lastOrNull;
      final List<ChatParticipantDTO> friends = chatroom.participants;
      final lastMessageFriend =  friends.where((element) =>element.uid==lastMessage?.senderUid).firstOrNull;
      final chatTile = chatGraphicsClass.regularChatTileFormat.copyWith(
        lastMessage:chatGraphicsClass.chatTileLastMessageFormat.copyWith(
          timestamp: lastMessage!=null?DateTime.fromMillisecondsSinceEpoch(lastMessage.timestamp):DateTime.now(),
          read: true,
          mine: lastMessage!=null?currentUserOp.currentUser.uid==lastMessage.senderUid:true,
          senderName: lastMessageFriend?.name??'',
        ),
        header: chatroom.groupChatName,
        pic: chatGraphicsClass.picWidgetFormat.copyWith(
            friends.map((e) => e.profilePic).toList()), onChatroomPressed:()=> onChatroomPressed(chatroom.chatroomId),

      );


      return chatTile;

    }
    return null;
  }


}