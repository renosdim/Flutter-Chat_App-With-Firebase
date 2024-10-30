
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/chat/regular_chat/presentation/chat_service_extension.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/loading_screen_for_messages.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/formats.dart';
import 'package:flutter/cupertino.dart';

import 'package:provider/provider.dart';

import '../../../../operations/chat/regular_chat/presentation/ChatService.dart';



class ChatsPreviewImmut extends StatefulWidget {

  final Future<void> Function() onRefresh;
  final Function(String) onChatroomPressed;



  const ChatsPreviewImmut({
    super.key,
    required this.onRefresh,
    required this.onChatroomPressed
  });

  @override
  State<ChatsPreviewImmut> createState() => _RegularChatPreviewState();
}

class _RegularChatPreviewState extends State<ChatsPreviewImmut> {
  final ScrollController scrollController = ScrollController();


  @override
  Widget build(BuildContext context) {
    final chatServiceClass= context.read<ChatService>();

    return Selector<ChatService, MapEntry<bool,List<ChatTileFormat?>>>(
      selector: (_, chatService) => MapEntry(
          chatService.loadedFirstTime,chatService.startingMessages?.values.toList().map((e) => chatService.convertChatroomDTOtoChatTile(e, widget.onChatroomPressed)).toList()??[]),
      builder: (context,chatService, _) {

        bool loadedOnce = chatService.key;
        print('loaded once $loadedOnce');
        List<ChatTileFormat?> tilesWithNull =  chatService.value;
        List<ChatTileFormat> tiles = [];
        tilesWithNull.removeWhere((element) => element==null);
        for (var element in tilesWithNull) {tiles.add(element!);}

        if(loadedOnce) {

          return chatServiceClass.addChatTilesToEnclosingSpace(tiles,widget.onRefresh);
        }
        else{

          return ChatLoadingScreen();
        }
      },
    );
  }
}
