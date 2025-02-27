
import 'package:custom_chat_clean_architecture_with_login_firebase/flexibleApp/flexible_app_main.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/main.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/chatroom_content/chatroom_content_immut.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/inbox_immut.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



import '../../injection.dart';
import '../../operations/auth/current_user.dart';

import '../../operations/chat/regular_chat/presentation/ChatService.dart';
import '../navigation_animations/slide_animation.dart';

import 'common/typo.dart';

class ChatChooser extends StatefulWidget {
  const ChatChooser({super.key});

  @override
  State<ChatChooser> createState() => _ChatChooserState();
}

class _ChatChooserState extends State<ChatChooser> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final  currentUser = serviceLocator<CurrentUserOp>().currentUser;
  late final  ChatService  chatService ;


  @override
  void initState(){
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    chatService = context.read<ChatService>();

    }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 60,
          ),
          Padding(

            padding: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      'Messages',
                      style:  header
                    ),
                  ],
                ),
                ElevatedButton(onPressed:() async=>await serviceLocator<SignOutUseCase>()(), child: Text('signOut')),
                Padding(
                  padding: const EdgeInsets.only(right:30.0,top:10.0),
                  child: Container(
                      decoration: BoxDecoration(border:Border.all(color:Theme. of (context).colorScheme.primary),color:Colors.white,borderRadius: const BorderRadius.all(Radius.circular(15),)),
                      child: IconButton(onPressed: (){

                      },
                          icon:Icon(Icons.search_rounded,color:Theme. of (context).colorScheme.primary.withAlpha(150) )
                      )
                  ),
                )
              ],
            ),
          ),

          const SizedBox(
            height: 24,
          ),


          Expanded(
            child: SizedBox(

                width: MediaQuery.of(context).size.width,
                height:MediaQuery.of(context).size.height,
                //decoration: const  BoxDecoration(color: Color(0xFF222222),borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50))),
                child:

                      const InboxImmut(),


                )
            ),







        ],
      ),
    );
  }
}


