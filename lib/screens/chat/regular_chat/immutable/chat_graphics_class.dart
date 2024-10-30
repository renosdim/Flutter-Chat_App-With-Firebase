import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/chat_tile_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/chat_tile_last_message_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/chatroom_content_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/message_bubble_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/pic_widget_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/read_message_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/scrolling_and_refreshing_format.dart';

class ChatGraphicsClass{

  final ChatTileFormat regularChatTileFormat;
  final ChatTileLastMessageFormat chatTileLastMessageFormat;
  final ScrollingAndRefreshingFormat scrollingAndRefreshingFormat;
  final MessageBubbleFormat messageBubbleFormat;
  final ChatroomContentFormat chatroomContentFormat;
  final PicWidgetFormat picWidgetFormat;
  final bool userNameInsteadOfName;
  final MessageAlreadyReadFormat messageAlreadyReadFormat;

  const ChatGraphicsClass(  {required this.messageAlreadyReadFormat,required this.userNameInsteadOfName,required this.picWidgetFormat,
    required this.chatTileLastMessageFormat,
    required this.messageBubbleFormat,
    required this.chatroomContentFormat,
    required this.regularChatTileFormat,
    required  this.scrollingAndRefreshingFormat

  });
}