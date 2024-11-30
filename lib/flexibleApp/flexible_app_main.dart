
import 'package:custom_chat_clean_architecture_with_login_firebase/flexibleApp/flexible_database__service_enum.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/data/data_sources/auth_remote_data_source_firebase.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/domain/entities/auth_user.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/domain/value_objects/email.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/domain/value_objects/password.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/chat/regular_chat/data/data_sources/chat_data_source.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/data/data_sources/user_data_local_source.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/data/data_sources/user_data_remote_source.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/graphics_classes/auth_graphics_class.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/graphics_classes/chat_graphics_class.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/graphics_classes/user_graphics_class.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import '../operations/auth/current_user.dart';
import '../operations/auth/data/data_sources/auth_local_data_source.dart';
import '../operations/auth/data/data_sources/auth_remote_data_source.dart';
import '../operations/auth/data/repositories/auth_repository_impl.dart';
import '../operations/auth/domain/repositories/auth_repository.dart';
import '../operations/auth/domain/use_cases/chech_username_existence.dart';
import '../operations/auth/domain/use_cases/sign_out_use_case.dart';
import '../operations/auth/presentation/blocs/auth_process_init/auth_proccess_cubit.dart';
import '../operations/auth/presentation/blocs/auth_process_init/auth_proccess_state.dart';
import '../operations/chat/regular_chat/data/data_sources/common_chat_data_source.dart';
import '../operations/chat/regular_chat/data/repositories/group_chat_rep_impl.dart';
import '../operations/chat/regular_chat/data/repositories/message_rep_impl.dart';
import '../operations/chat/regular_chat/domain/repositories/group_chat_repository.dart';
import '../operations/chat/regular_chat/domain/repositories/message_repository.dart';
import '../operations/chat/regular_chat/domain/usecases/find_friends_to_text.dart';
import '../operations/chat/regular_chat/domain/usecases/get_group_messages.dart';
import '../operations/chat/regular_chat/domain/usecases/get_starting_messages_usecase.dart';
import '../operations/chat/regular_chat/domain/usecases/group_chat_listener_usecase.dart';
import '../operations/chat/regular_chat/domain/usecases/send_group_message_usecase.dart';
import '../operations/chat/regular_chat/domain/usecases/send_message_usecase.dart';
import '../operations/chat/regular_chat/domain/usecases/set_up_starting_chat_listeners.dart';
import '../operations/chat/regular_chat/domain/usecases/setup_chat_listener_usecase.dart';
import '../operations/chat/regular_chat/dtos/chat_dto_mapper.dart';
import '../operations/chat/regular_chat/presentation/ChatService.dart';
import '../operations/common/network_info.dart';
import '../operations/users/data/repositories/user_data_repository_impl.dart';
import '../operations/users/domain/repositories/user_data_repository.dart';
import '../operations/users/domain/usecases/get_users_by_prefix_usecase.dart';
import '../operations/users/presentation/users_cubit.dart';
import '../screens/general_navigation_bloc/general_navigation_cubit.dart';
class AuthUseCases{
  final SignOutUseCase signOutUseCase;
  final SignInUseCase signInUseCase;
  const AuthUseCases({required this.signInUseCase,required this.signOutUseCase});
}
class UserUseCases{

}
enum FlexibleAuthProvider{
  google,
  email;
}
class FlexibleAppStarter {
  static final FlexibleAppStarter _instance = FlexibleAppStarter._internal();
  late final    CurrentUserOp _currentUserOp;
  late final SignOutUseCase _signOutUseCase;
  late final SignInUseCase _signInUseCase;
  late final GetUsersByPrefix _getUsersByPrefixUseCase;
  late final GetStartingMessages _getStartingMessagesUseCase;
  late final UserDataRepository _userDataRepository;
  late final AuthRemoteDataSource _authRemoteDataSource;
  late final AuthRepository _authRepository;
  late final SendMessage _sendMessage;
  late final bool isInitialized;
  late final ChatService chatService;
  // Private named constructor
  FlexibleAppStarter._internal();

  // Factory constructor to return the singleton instance
  factory FlexibleAppStarter() {
    return _instance;
  }
  CurrentUserOp get currentUserOp=> _currentUserOp;
  // Initialization function
  void init({
    required FlexibleDatabaseService flexibleDatabaseService,
    AuthRemoteDataSource? authRemoteDataSource,
    ChatDataSource? chatDataSource,
    FirebaseOptions? firebaseOptions,
    UserDataRemoteSource? userDataRemoteSource,
    UserDataLocalSource? userDataLocalSource,

  }) {
      // assert(flexibleDatabaseService==FlexibleDatabaseService.other && (authRemoteDataSource==null || userDataRemoteSource==null ||chatDataSource==null),''
      //     'Since ur not using firebase for your backend application authRemoteDataSource and userDataRemoteSource and chatDataSource cannot be null');
      // assert(flexibleDatabaseService==FlexibleDatabaseService.firebase && firebaseOptions==null,
      //     'Missing Firebase options file ');
      final GetIt serviceLocator = GetIt.instance;
    // Assign the provided or default values to the fields
      serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfo());

      serviceLocator.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSource());
      serviceLocator.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceFirebase());
      serviceLocator.registerLazySingleton(() => CurrentUserOp(authRemoteDataSource: serviceLocator()));
      serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(serviceLocator(), remoteDataSource: serviceLocator(), localDataSource: serviceLocator()));
      serviceLocator.registerLazySingleton<SignOutUseCase>(()=>SignOutUseCase(authRepository: serviceLocator()));

      serviceLocator.registerLazySingleton<CheckUsernameExistenceUseCase>(()=>CheckUsernameExistenceUseCase(serviceLocator()));
      serviceLocator.registerLazySingleton<UserDataLocalSource>(() => UserDataLocalSource());
      serviceLocator.registerLazySingleton<UserDataRemoteSource>(() => UserDataRemoteSource(userDataLocalSource: serviceLocator(), currentUserOp: serviceLocator()));
      serviceLocator.registerLazySingleton<UserDataRepository>(() =>
          UserDataRepImpl(remoteSource: serviceLocator(), networkInfo: serviceLocator(), localSource: serviceLocator()));

      serviceLocator.registerLazySingleton<GetUsersByPrefix>(() => GetUsersByPrefix( serviceLocator())) ;

      serviceLocator.registerLazySingleton<FindFriendsToText>(()=>FindFriendsToText(currentUserOp:serviceLocator(),userDataRepository: serviceLocator()));


      serviceLocator.registerLazySingleton<ChatDTOMapper>(() => ChatDTOMapper(userDataRepository: serviceLocator()));
      serviceLocator.registerLazySingleton<MessageRemoteSource>(()=>MessageRemoteSource(currentUserOp: serviceLocator()));
      serviceLocator.registerLazySingleton<GroupChatRepository>(()=>GroupChatRepImpl(groupChatRemoteSource: serviceLocator(), networkInfo: serviceLocator()));
      serviceLocator.registerLazySingleton<SendGroupMessage>(()=>SendGroupMessage(groupChatRepository: serviceLocator()));
      serviceLocator.registerLazySingleton<SetUpGroupChatListener>(()=>SetUpGroupChatListener(groupChatRepository: serviceLocator(), chatDTOMapper: serviceLocator()));
      serviceLocator.registerLazySingleton<MessageRepository>(()=>MessageRepImp(serviceLocator(),serviceLocator()));
      serviceLocator.registerLazySingleton<GetStartingMessages>(()=>GetStartingMessages(serviceLocator(),serviceLocator()));
      serviceLocator.registerLazySingleton<GetGroupMessages>(()=>GetGroupMessages(groupChatRepository: serviceLocator(), chatDTOMapper: serviceLocator()));
      serviceLocator.registerLazySingleton<SendMessage>(()=>SendMessage(serviceLocator()));
      serviceLocator.registerLazySingleton<SetUpChatListener>(()=>SetUpChatListener(messageRepository: serviceLocator(), chatDTOMapper:serviceLocator()));
      serviceLocator.registerLazySingleton<SetUpStartingChatListeners>(()=>SetUpStartingChatListeners(messageRepository: serviceLocator(), chatDTOMapper:serviceLocator()));




      _authRemoteDataSource = serviceLocator<AuthRemoteDataSource>();
    _userDataRepository  = serviceLocator<UserDataRepository>();
    _currentUserOp = serviceLocator<CurrentUserOp>();
    _getUsersByPrefixUseCase  = serviceLocator<GetUsersByPrefix>();
    _signInUseCase = serviceLocator<SignInUseCase>();
    _signOutUseCase = serviceLocator<SignOutUseCase>();
    _getStartingMessagesUseCase = serviceLocator<GetStartingMessages>();
    chatService = serviceLocator<ChatService>();
    isInitialized = true;
    _authRepository = serviceLocator<AuthRepository>();
      serviceLocator<NetworkInfo>().initialize();
    //await serviceLocator<PlaceOp>().getPlaces();
  }
  Future<void> signOut() async {
    return await _signOutUseCase();
  }
  Future<void> signIn({required Email email,required Password password}) async {
    try{
      await _signInUseCase(SignInParams(email: email, password: password));
    }
    catch(e){
      rethrow;
    }


  }
}

class FlexibleAppWrapper extends StatelessWidget{
  final String title;
  final ThemeData? generalTheme;
  final   UserGraphicsClassAttributes _userGraphicsClassAttributes;
  final AuthGraphicsClassAttributes _authGraphicsClassAttributes;
  final ChatGraphicsClassAttributes _chatGraphicsClassAttributes;
  final Widget Function(BuildContext context,bool? loggedIn,bool? loadingDependencies,bool?unloadingDependencies) builder;
  const FlexibleAppWrapper(

  {UserGraphicsClassAttributes userGraphicsClassAttributes=const UserGraphicsClassAttributes(),
      AuthGraphicsClassAttributes authGraphicsClassAttributes = const AuthGraphicsClassAttributes(),
      ChatGraphicsClassAttributes chatGraphicsClassAttributes = const ChatGraphicsClassAttributes(),super.key,required this.builder,required this.title,this.generalTheme}):
        _userGraphicsClassAttributes=userGraphicsClassAttributes,
  _authGraphicsClassAttributes = authGraphicsClassAttributes,_chatGraphicsClassAttributes = chatGraphicsClassAttributes;




  @override
  Widget build(BuildContext context) {
    assert(
    !FlexibleAppStarter().isInitialized,
    'FlexibleAppStarter is not initialized!',
    );
    // TODO: implement build
    return UserGraphicsClass(
        userSearchResultFormat: _userGraphicsClassAttributes.userSearchResultFormat,
        searchNewUsersFormat: _userGraphicsClassAttributes.searchNewUsersFormat,
        profilePageFormat: _userGraphicsClassAttributes.profilePageFormat,
        child:AuthGraphicsClass(
            signInFormFormat: _authGraphicsClassAttributes.signInFormFormat,
            child:ChatGraphicsClass(
                picWidgetFormat: _chatGraphicsClassAttributes.picWidgetFormat,

                userNameInsteadOfName: _chatGraphicsClassAttributes.userNameInsteadOfName,
                messageAlreadyReadFormat: _chatGraphicsClassAttributes.messageAlreadyReadFormat,

                chatTileLastMessageFormat: _chatGraphicsClassAttributes.chatTileLastMessageFormat,

                messageBubbleFormat: _chatGraphicsClassAttributes.messageBubbleFormat,

                chatroomContentFormat: _chatGraphicsClassAttributes.chatroomContentFormat,
                regularChatTileFormat: _chatGraphicsClassAttributes.regularChatTileFormat,

                scrollingAndRefreshingFormat: _chatGraphicsClassAttributes.scrollingAndRefreshingFormat,
                child: MaterialApp(
                  title:title,
                  theme: generalTheme,
                  home: BlocConsumer<AuthInitializeProcessesCubit, AuthProcessState>(
                    listener: (context, state) {

                    },
                    builder: (context, state) {

                      return _multiRepositoryProvider(builder(
                        context,
                       state.loadingDependencies,
                        state.unloadingDependencies,
                       state.loggedIn,


                      ));
                    },
                  ),
                ),
            )
        )
    );
  }
  MultiRepositoryProvider _multiRepositoryProvider(Widget child){
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider.value(value: FlexibleAppStarter()._authRepository),

          ChangeNotifierProvider(create: (_) =>
              FlexibleAppStarter().chatService),

          BlocProvider(
              create: (context) =>
              AuthInitializeProcessesCubit(

                chatService: Provider.of<ChatService>(context,listen: false),
                signOutUseCase: FlexibleAppStarter()._signOutUseCase,
                currentUserOp: FlexibleAppStarter()._currentUserOp, authRemoteDataSource: FlexibleAppStarter()._authRemoteDataSource,
              )..enable()),

          BlocProvider(create: (context)=>
              GeneralNavigationCubit()),
          BlocProvider(create: (context)=>
              UserOpCubit(
                  currentUserOp: FlexibleAppStarter()._currentUserOp,
                  userDataRepository:FlexibleAppStarter()._userDataRepository,
                  getUsersByPrefix: FlexibleAppStarter()._getUsersByPrefixUseCase))
        ], child: child,);
  }

}