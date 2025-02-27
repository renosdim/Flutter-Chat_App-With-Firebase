
import 'package:custom_chat_clean_architecture_with_login_firebase/flexibleApp/flexible_app_main.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/injection.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/current_user.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/loading_screen_for_messages.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/chatroom_content/chatroom_content_immut.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/formats.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/general_navigation_bloc/general_navigation_cubit.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/graphics_classes/chat_graphics_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../operations/chat/regular_chat/dtos/chat_participant_dto.dart';
import '../../../../operations/chat/regular_chat/dtos/group_chatroom_dto.dart';
import '../../../../operations/chat/regular_chat/dtos/regular_chatroom_dto.dart';
import '../../../../operations/chat/regular_chat/presentation/ChatService.dart';
import '../../../../operations/common/dto.dart';



class InboxImmut extends StatefulWidget {






  const InboxImmut({
    super.key,


  });

  @override
  State<InboxImmut> createState() => _InboxState();
}

class _InboxState extends State<InboxImmut> {
  final ScrollController scrollController = ScrollController();
  late final  ChatGraphicsClass chatGraphicsClass;
  final CurrentUserOp currentUserOp = serviceLocator<CurrentUserOp>();

  @override
  void initState(){
    super.initState();


  }
  @override
  didChangeDependencies(){
    super.didChangeDependencies();
    chatGraphicsClass = ChatGraphicsClass.of(context);

  }
  int _compare(ChatTileFormat a, ChatTileFormat b) {
    DateTime otherTimestamp = b.lastMessage!.timestamp!;
    DateTime thisTimestamp = a.lastMessage!.timestamp!;
    return otherTimestamp.compareTo(thisTimestamp);
  }

  ScrollingAndRefreshingFormat _addChatTilesToEnclosingSpace(List<ChatTileFormat> chatTiles,Future<void> Function()? onRefresh){
    chatTiles.sort(_compare);
    return chatGraphicsClass.scrollingAndRefreshingFormat.copyWith(chatTiles:chatTiles,onRefresh: onRefresh );
  }
  int _countUnreadMessages(List<dynamic> chatroomComponents,{int index=0,int count=0}){
    try {

      if (chatroomComponents[index].read == false &&
          chatroomComponents[index].senderUid !=
              currentUserOp.currentUser.uid) {
        return _countUnreadMessages(
            chatroomComponents, index: index + 1, count: count + 1);
      }
      else {
        return count;
      }

    }catch(e){
      return count;
    }
  }
  ChatTileFormat? _convertChatroomDTOtoChatTile(ChatroomDTO? chatroom,void Function(String chatroomId) onChatroomPressed){


    if(chatroom is RegularChatroomDTO) {
      final chatParticipant = chatroom.chatParticipant;
      final unreadCount = _countUnreadMessages(chatroom.chatroomComponents.reversed.toList());


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
              unreadCount: unreadCount,
              content: lastMessage.message,
              read: lastMessage.read ?? false,
              mine: mine,
              senderName: lastMessageSender),
          header: header,
          pic: chatGraphicsClass.picWidgetFormat.copyWith(profilePics:
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
        pic: chatGraphicsClass.picWidgetFormat.copyWith(profilePics:
        friends.map((e) => e.profilePic).toList()), onChatroomPressed:()=> onChatroomPressed(chatroom.chatroomId),

      );


      return chatTile;

    }
    return null;
  }

  @override
  Widget build(BuildContext context) {


    return Selector<ChatService, MapEntry<bool,List<ChatTileFormat?>>>(
      selector: (_, chatService) => MapEntry(
          chatService.loadedFirstTime,chatService.startingMessages?.values.toList().map((e) => _convertChatroomDTOtoChatTile(e,(id)=>Navigator.push(context,MaterialPageRoute(builder: (context)=>ChatroomContentImmut(chatroomId: id))))).toList()??[]),
      builder: (context,chatService, _) {
        bool loadedOnce = chatService.key;
        List<ChatTileFormat?> tilesWithNull =  chatService.value;
        List<ChatTileFormat> tiles = [];
        tilesWithNull.removeWhere((element) => element==null);
        for (var element in tilesWithNull) {tiles.add(element!);}
        for(int i=0;i<tiles.length;i++){


          tiles[i] = tiles[i].copyWith(lastMessage: null, header: null, pic: tiles[i].pic?.copyWith(onTap:()=>context.read<GeneralNavigationCubit>().navigateToFriendsProfileWithId ), onChatroomPressed: null);
        }
        if(loadedOnce) {

          return _addChatTilesToEnclosingSpace(tiles,context.read<ChatService>().getStartingMessages);
        }
        else{

          return ChatLoadingScreen();
        }
      },
    );
  }
}
