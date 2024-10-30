
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/chat/regular_chat/presentation/chat_service_extension.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/formats.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


import '../../../../../operations/chat/regular_chat/presentation/ChatService.dart';


class ChatroomContentImmut extends StatelessWidget {
  final String chatroomId;

  const ChatroomContentImmut({super.key, required this.chatroomId});



  @override
  Widget build(BuildContext context) {

    return Selector<ChatService,ChatroomContentFormat>(
      selector: (_,chatService)=>chatService.convertChatroomToGraphics(chatroomId),
      builder: (BuildContext context, ChatroomContentFormat chatroomContent, Widget? child) {
        print('rerun');
        return chatroomContent;
      }
        );
      }


  }
