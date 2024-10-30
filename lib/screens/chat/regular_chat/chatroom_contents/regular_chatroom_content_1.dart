import 'package:flutter/material.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/chatroom_content_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/message_bubble_format.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/formats/pic_widget_format.dart';

class DarkChatUi extends ChatroomContentFormat {
  const DarkChatUi({
    super.key,
    super.replyingTo,
    super.messages,
    super.pic,
    super.header,
    super.sendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return _DarkChatUiContent(
      messages: messages ?? [],
      picWidget: pic!,
      header: header!,
      sendMessage: sendMessage!,
      replyingTo: replyingTo,
    );
  }

  @override
  ChatroomContentFormat copyWith({
    List<MessageBubbleFormat>? messages,
    PicWidgetFormat? pic,
    String? header,
    MessageBubbleFormat? replyingTo,
    Future<void> Function(String, String?)? sendMessage,
  }) {
    return DarkChatUi(
      replyingTo: replyingTo,
      messages: messages ?? this.messages,
      pic: pic ?? this.pic,
      header: header ?? this.header,
      sendMessage: sendMessage ?? this.sendMessage,
    );
  }
}


class AutoScrollWrapper extends StatefulWidget {
  final Widget child;

  const AutoScrollWrapper({Key? key, required this.child}) : super(key: key);

  @override
  _AutoScrollWrapperState createState() => _AutoScrollWrapperState();
}

class _AutoScrollWrapperState extends State<AutoScrollWrapper> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Initial scroll to the bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void didUpdateWidget(covariant AutoScrollWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Scroll to the bottom on child updates
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: PrimaryScrollController(
        controller: _scrollController,
        child: widget.child,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

class _DarkChatUiContent extends StatefulWidget {
  final List<MessageBubbleFormat> messages;
  final PicWidgetFormat picWidget;
  final String header;
  final Future<void> Function(String, String?) sendMessage;
  final MessageBubbleFormat? replyingTo;

  const _DarkChatUiContent({
    required this.messages,
    required this.picWidget,
    required this.header,
    required this.sendMessage,
    this.replyingTo,
  });

  @override
  State<_DarkChatUiContent> createState() => _DarkChatUiContentState();
}

class _DarkChatUiContentState extends State<_DarkChatUiContent> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late List<MessageBubbleFormat> _messages;

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.messages); // Initialize with messages passed to widget
  }

  @override
  void didUpdateWidget(covariant _DarkChatUiContent oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Check if messages have changed
    if (oldWidget.messages.length < widget.messages.length) {
      // New messages added
      for (int i = oldWidget.messages.length; i < widget.messages.length; i++) {
        _listKey.currentState?.insertItem(i, duration: const Duration(milliseconds: 300));

        // Scroll to the bottom when a new item is inserted

      }
    } else if (oldWidget.messages.length > widget.messages.length) {
      // Messages removed; could handle if you have a specific removal strategy
      for (int i = oldWidget.messages.length; i > widget.messages.length; i--) {
       if(i-1>=0) {
         _listKey.currentState?.removeItem(
          i - 1, // Adjust for list index
              (context, animation) => _buildMessageItem(widget.messages[i - 1], animation),
          duration: const Duration(milliseconds: 300),
        );
       }
      }
    }

    // Update _messages list with new data
    _messages = List.from(widget.messages);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header with friend details and back button
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black87,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                  ),
                  widget.picWidget,
                  const SizedBox(width: 10),
                  Text(
                    widget.header,
                    style: Theme.of(context).textTheme.displayMedium,
                  ),
                ],
              ),
            ),

            // Chat area using AnimatedList
            Expanded(
              child: AutoScrollWrapper(
                child: AnimatedList(
                  key: _listKey,
                  
                  initialItemCount: _messages.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index, animation) {
                    final message = _messages[index];
                    return _buildMessageItem(message, animation);
                  },
                ),
              ),
            ),

            // Replying to message (if applicable)
            if (widget.replyingTo != null) _buildReplyPreview(),

            // Text input and send button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[900],
                        hintText: 'Send a message...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      String mess = _controller.text.trim();
                      if (mess.isNotEmpty) {
                        // Send the message
                        _controller.clear();
                        await widget.sendMessage(mess, (widget.replyingTo?.key as ValueKey<String>?)?.value);
                      }
                    },
                    icon: const Icon(Icons.send, color: Colors.deepPurple),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display the "Replying to" preview
  Widget _buildReplyPreview() {
    return Container(
      color: Colors.deepPurple[300]?.withOpacity(0.2),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.reply, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Replying to: ${widget.replyingTo!.content}', // Display the content of the message being replied to
              style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              // Handle close action
            },
          ),
        ],
      ),
    );
  }

  // Method to build message item with popping animation (ScaleTransition)
  Widget _buildMessageItem(MessageBubbleFormat message, Animation<double> animation) {
    return ScaleTransition(
      scale: animation,
      child: message, // Replace with your message bubble widget
    );
  }
}
