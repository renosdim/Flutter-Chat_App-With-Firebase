import 'package:flutter/cupertino.dart';

import 'chat_tile_format.dart';

abstract class ScrollingAndRefreshingFormat extends StatelessWidget{
  final List<ChatTileFormat>? chatTiles;
  final Future<void> Function()? onRefresh;

  const ScrollingAndRefreshingFormat({super.key, this.chatTiles, this.onRefresh});

  @override
  Widget build(BuildContext context);


  ScrollingAndRefreshingFormat copyWith({List<ChatTileFormat>? chatTiles,Future<void> Function()? onRefresh});

}