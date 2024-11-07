import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/chat_bubbles/regular_adaptive_chat_bubble_1.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/chat_tiles/regular_chat_tile_1.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/chatroom_contents/regular_chatroom_content_1.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/chat_tile_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/chat_tile_last_message_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/chatroom_content_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/message_bubble_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/pic_widget_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/read_message_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/scrolling_and_refreshing_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/last_chat_message_widgets/last_chat_message_widget_2.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/message_already_read_widgets/message_already_read_1.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/pic_widgets/pic_widget_1.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/regular_refresh_scroll/regular_refresh_scroll_1.dart';
import 'package:flutter/cupertino.dart';

class ChatGraphicsClass extends InheritedWidget{

  final ChatTileFormat regularChatTileFormat;
  final ChatTileLastMessageFormat chatTileLastMessageFormat;
  final ScrollingAndRefreshingFormat scrollingAndRefreshingFormat;
  final MessageBubbleFormat messageBubbleFormat;
  final ChatroomContentFormat chatroomContentFormat;
  final PicWidgetFormat picWidgetFormat;
  final bool userNameInsteadOfName;
  final MessageAlreadyReadFormat messageAlreadyReadFormat;

  const ChatGraphicsClass(  {super.key, this.messageAlreadyReadFormat=const MessageAlreadyRead1(),
    this.userNameInsteadOfName=false,this.picWidgetFormat=const PicWidget1(),
    this.chatTileLastMessageFormat = const SnapchatStyleMessageWidget(),
    this.messageBubbleFormat=const AdaptiveChatBubble(),
    this.chatroomContentFormat = const DarkChatUi(),
    this.regularChatTileFormat = const ChatTile1(),
    this.scrollingAndRefreshingFormat = const RegularRefreshScroll(), required super.child

  });
  static ChatGraphicsClass of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ChatGraphicsClass>()!;
  }

  @override
  bool updateShouldNotify(Widget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }
}