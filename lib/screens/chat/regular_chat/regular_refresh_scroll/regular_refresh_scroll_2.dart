import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/chat_tile_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/scrolling_and_refreshing_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ElevatedChatListScroll extends ScrollingAndRefreshingFormat {
  const ElevatedChatListScroll({super.key, super.chatTiles, super.onRefresh});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        CupertinoSliverRefreshControl(
          onRefresh: () async => await onRefresh!(),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return Card(
                elevation: 5, // Card effect
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: chatTiles![index],
              );
            },
            childCount: chatTiles?.length ?? 0,
          ),
        ),
      ],
    );
  }

  @override
  ScrollingAndRefreshingFormat copyWith({
    List<ChatTileFormat>? chatTiles,
    Future<void> Function()? onRefresh,
  }) {
    return ElevatedChatListScroll(chatTiles: chatTiles, onRefresh: onRefresh);
  }
}