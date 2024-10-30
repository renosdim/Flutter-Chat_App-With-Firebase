
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/chat_tile_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/scrolling_and_refreshing_format.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/framework.dart';

class RegularRefreshScroll extends ScrollingAndRefreshingFormat{
  const RegularRefreshScroll({super.key,super.chatTiles,super.onRefresh});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return CustomScrollView(
      physics: const BouncingScrollPhysics(
        parent: AlwaysScrollableScrollPhysics(),
      ),
      slivers: [
        CupertinoSliverRefreshControl(
            onRefresh: () async { print('starting refresh');await onRefresh!();}),
        SliverList(
          delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
              return chatTiles![index];
            },
            childCount: chatTiles!.length,
          ),
        ),
      ],
    );
  }

  @override
  ScrollingAndRefreshingFormat copyWith({List<ChatTileFormat>? chatTiles, Future<void> Function()? onRefresh}) {
    // TODO: implement copyWith
    return RegularRefreshScroll(chatTiles: chatTiles,onRefresh: onRefresh,);
  }




}