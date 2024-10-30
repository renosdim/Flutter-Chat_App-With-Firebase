
import 'package:custom_chat_clean_architecture_with_login_firebase/injection.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/chat/regular_chat/domain/usecases/find_friends_to_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../operations/chat/regular_chat/dtos/chat_participant_dto.dart';
import '../../../../widgets/elegant_text_field.dart';
import '../../../../widgets/loading_indicator.dart';
import '../../common/color.dart';
import 'chat_page_notifier.dart';
class SearchUsersToChat extends StatelessWidget {
  final Function(ChatParticipantDTO) function;
  const SearchUsersToChat({super.key,required this.function});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create:(_)=> SearchToChatNotifier(findFriendsToText:serviceLocator<FindFriendsToText>() ),child: _TagsPageContent(nextPage: function,),);
  }
}

class _TagsPageContent extends StatefulWidget {

  final Function(ChatParticipantDTO)nextPage;

  const _TagsPageContent({required this.nextPage});

  @override
  State<_TagsPageContent> createState() => _TagsPageStateContent();
}
class _TagsPageStateContent extends State<_TagsPageContent> {
  List<ChatParticipantDTO> resultList = [];
  ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  late SearchToChatNotifier tagsPageNotifier;

  @override
  void initState() {
    super.initState();
    tagsPageNotifier = Provider.of<SearchToChatNotifier>(context, listen: false);
    _scrollController.addListener(_loadMoreUsers);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      tagsPageNotifier.loadMoreUsers();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_loadMoreUsers);
    _scrollController.dispose();
    super.dispose();
  }

  void _loadMoreUsers() async {
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      tagsPageNotifier.loadMoreUsers();
    }
  }

  void _nextPage() {
    print('taped');
    if(tagsPageNotifier.selectedTag!=null){
      widget.nextPage(tagsPageNotifier.selectedTag!);
    }

  }

  Widget friendContainer(ChatParticipantDTO friend, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (isSelected) {
          setState(() {
            tagsPageNotifier.unselectTag(friend);
          });
        } else {
          tagsPageNotifier.selectTag(friend);
        }
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.deepOrange : Colors.transparent,
                width: 3,
              ),
            ),
            child: CircleAvatar(
              backgroundImage: NetworkImage(friend.profilePic!),
              radius: isSelected ? 32 : 30,
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  Positioned(
                    top: 0,
                    right: 3,
                    child: Icon(
                      isSelected ? Icons.circle : Icons.add_circle_outlined,
                      color: isSelected ? Colors.transparent : Colors.white,
                      size: 22,
                      shadows: [
                        BoxShadow(
                          color: isSelected ? Colors.transparent : Colors.black,
                          spreadRadius: 100,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: 5),

        SizedBox(height: 10),
        elegantTextField('ψάξε φίλους...', Provider.of<SearchToChatNotifier>(context, listen: false).onChanged, null),
        Expanded(
          child: Consumer<SearchToChatNotifier>(
            builder: (context, tagsPageNotifier, _) => Stack(
              children: [
                Positioned.fill(
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: tagsPageNotifier.filteredTags.isEmpty
                        ? tagsPageNotifier.tags.length
                        : tagsPageNotifier.filteredTags.length,
                    itemBuilder: (context, index) {
                      final friend = tagsPageNotifier.filteredTags.isEmpty
                          ? tagsPageNotifier.tags.values.toList()[index]
                          : tagsPageNotifier.filteredTags.toList()[index];

                      bool isSelected = friend.uid==tagsPageNotifier.selectedTag?.uid;

                      return friendContainer(friend, isSelected);
                    },
                  ),
                ),
                tagsPageNotifier.isLoading
                    ? Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 25,
                    width: 25,
                    child: LoadingIndicator(),
                  ),
                )
                    : Container(),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Άκυρο',
                style: TextStyle(color: Colors.black, fontSize: 13.5, fontFamily: 'San Francisco'),
              ),
            ),
            Container(
              width: 130,
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.deepPurple],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: blue,
                ),
                child: IconButton(
                    onPressed: () {
                      _nextPage();
                    },
                    icon: const Icon(Icons.send_outlined)
                ),
              ),
            )
          ],
        )

      ],
    );
  }
}
