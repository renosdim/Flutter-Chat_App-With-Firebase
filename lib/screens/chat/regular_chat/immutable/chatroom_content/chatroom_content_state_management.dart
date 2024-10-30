

import 'package:custom_chat_clean_architecture_with_login_firebase/screens/formats.dart';
import 'package:flutter/material.dart';

class ChatroomContentStateManager extends ChangeNotifier{

  MessageBubbleFormat? replyingTo;
  ChatroomContentStateManager(){
    replyingTo=null;
  }
  void replyingToMessage(MessageBubbleFormat messageBubbleFormat){
    replyingTo = messageBubbleFormat;
    notifyListeners();
  }
}