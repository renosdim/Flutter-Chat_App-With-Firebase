import 'dart:async';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/domain/repositories/auth_repository.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/presentation/screens/sign_in_screen.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/presentation/users_cubit.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/chat_tab_picker.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/graphics_classes/chat_graphics_class.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/regular_chat/immutable/chatroom_content/chatroom_content_immut.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/general_navigation_bloc/general_navigation_cubit.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/general_navigation_bloc/general_navigation_state.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/graphics_classes/user_graphics_class.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/navigation_animations/slide_animation.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/users/immut/profile_screen_immut.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/theme.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/users/search_users_screens/search_user_screen_2.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'firebase_options.dart';
import 'injection.dart';
import 'operations/auth/current_user.dart';
import 'package:provider/provider.dart';
import 'operations/auth/presentation/blocs/auth_process_init/auth_proccess_cubit.dart';
import 'operations/auth/presentation/blocs/auth_process_init/auth_proccess_state.dart';
import 'operations/chat/regular_chat/presentation/ChatService.dart';
import 'operations/common/network_info.dart';


typedef AppBuilder = Future<Widget> Function();

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //WidgetsBinding.instance.addObserver(AppLifecycleListener());
  //FirebaseDatabase.instance.setPersistenceEnabled(true);
  initializeDependencies();


  runApp(await builder());
}

void main() {
  bootstrap(
        () async {




          serviceLocator<NetworkInfo>().initialize();
          //await CloudMessaging().configurePushNotifications();

      return UserGraphicsClass(
              child:ChatGraphicsClass(
                    child:App(
                          regToken:'',
                          currentUserOp: serviceLocator<CurrentUserOp>(),


              )
          )
      );
    },
  );
}

class App extends StatefulWidget {
  const App({
    super.key,

    required this.currentUserOp,

    this.regToken,
  });



  final String? regToken;
  final CurrentUserOp currentUserOp;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {


    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: serviceLocator<AuthRepository>()),

        ChangeNotifierProvider(create: (_) =>
            ChatService(
                currentUserOp:serviceLocator(),
                getGroupMessagesUseCase:serviceLocator(),
                getStartingMessagesUseCase:serviceLocator(),
                sendMessageUseCase:serviceLocator(),
                sendGroupMessageUseCase:serviceLocator(),
                setUpChatListener:serviceLocator(),
                setUpGroupChatListener:serviceLocator(),
                startingChatListeners:serviceLocator(),
               )),

        BlocProvider(
        create: (context) =>
            AuthInitializeProcessesCubit(

                chatService: Provider.of<ChatService>(context,listen: false),
                signOutUseCase: serviceLocator<SignOutUseCase>(),
                currentUserOp: widget.currentUserOp, authRemoteDataSource: serviceLocator(),
                )..enable()),

        BlocProvider(create: (context)=>
            GeneralNavigationCubit()),
        BlocProvider(create: (context)=>
            UserOpCubit(
                currentUserOp: serviceLocator(),
                userDataRepository:serviceLocator(),
                getUsersByPrefix: serviceLocator()))
      ],

        child: MaterialApp(
          title: 'Clean Architecture',
          theme: darkTheme(),
          home: BlocConsumer<AuthInitializeProcessesCubit, AuthProcessState>(
            listener: (context, state) {

            },
            builder: (context, state) {

              if (state.loadingDependencies==true) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              } else if (state.loggedIn==true) {

                return BlocConsumer<GeneralNavigationCubit,GeneralNavigationState>(
                    listener:(context,navigationState){

                        if(navigationState.openedChatroomWithId!=null){

                          navigateWithSlideRight(context,ChatroomContentImmut(chatroomId: navigationState.openedChatroomWithId!));
                        }
                        else if(navigationState.leaveChatroom==true){

                          Navigator.of(context).pop();
                        }
                        else if(navigationState.showUserProfileWithId!=null){
                          navigateWithSlideRight(context, FriendProfileScreen(uid: navigationState.showUserProfileWithId!));
                        }
                    },
                    builder:(context,navigationState){

                      return ChatChooser();
                    });



                // Navigate to the chat chooser if logged in
              } else if(state.loggedIn==false) {
                return const Scaffold(
                  body: Center(child: SignInScreen()),
                );
              }
              else{
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
            },
          ),
        ),

    );
  }
}




