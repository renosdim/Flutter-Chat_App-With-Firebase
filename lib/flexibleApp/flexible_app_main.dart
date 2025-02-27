import 'package:custom_chat_clean_architecture_with_login_firebase/flexibleApp/flexible_database__service_enum.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/data/data_sources/auth_remote_data_source_firebase.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/domain/use_cases/sign_in_use_case.dart';

import 'package:custom_chat_clean_architecture_with_login_firebase/operations/chat/regular_chat/data/data_sources/chat_data_source.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/data/data_sources/user_data_local_source.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/data/data_sources/user_data_remote_source.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/general_navigation_bloc/general_navigation_state.dart';
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

class AuthUseCases {
  final SignOutUseCase signOutUseCase;
  final SignInUseCase signInUseCase;
  const AuthUseCases({required this.signInUseCase, required this.signOutUseCase});
}

class UserUseCases {}

enum FlexibleAuthProvider {
  google,
  email;
}

final GetIt serviceLocator = GetIt.instance;

// Initialization function
void init({
  required FlexibleDatabaseService flexibleDatabaseService,
  AuthRemoteDataSource? authRemoteDataSource,
  ChatDataSource? chatDataSource,
  FirebaseOptions? firebaseOptions,
  UserDataRemoteSource? userDataRemoteSource,
  UserDataLocalSource? userDataLocalSource,
}) {
  serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfo());

  serviceLocator.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSource());
  serviceLocator.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceFirebase());
  serviceLocator.registerLazySingleton(() => CurrentUserOp(authRemoteDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(serviceLocator(), remoteDataSource: serviceLocator(), localDataSource: serviceLocator()));
  serviceLocator.registerLazySingleton<SignOutUseCase>(() => SignOutUseCase(authRepository: serviceLocator()));

  serviceLocator.registerLazySingleton<CheckUsernameExistenceUseCase>(() => CheckUsernameExistenceUseCase(serviceLocator()));
  serviceLocator.registerLazySingleton<UserDataLocalSource>(() => UserDataLocalSource());
  serviceLocator.registerLazySingleton<UserDataRemoteSource>(() => UserDataRemoteSource(userDataLocalSource: serviceLocator(), currentUserOp: serviceLocator()));
  serviceLocator.registerLazySingleton<UserDataRepository>(() => UserDataRepImpl(remoteSource: serviceLocator(), networkInfo: serviceLocator(), localSource: serviceLocator()));

  serviceLocator.registerLazySingleton<GetUsersByPrefix>(() => GetUsersByPrefix(serviceLocator()));

  serviceLocator.registerLazySingleton<FindFriendsToText>(() => FindFriendsToText(currentUserOp: serviceLocator(), userDataRepository: serviceLocator()));

  serviceLocator.registerLazySingleton<ChatDTOMapper>(() => ChatDTOMapper(userDataRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<MessageRemoteSource>(() => MessageRemoteSource(currentUserOp: serviceLocator()));
  serviceLocator.registerLazySingleton<GroupChatRepository>(() => GroupChatRepImpl(groupChatRemoteSource: serviceLocator(), networkInfo: serviceLocator()));
  serviceLocator.registerLazySingleton<SendGroupMessage>(() => SendGroupMessage(groupChatRepository: serviceLocator()));
  serviceLocator.registerLazySingleton<SetUpGroupChatListener>(() => SetUpGroupChatListener(groupChatRepository: serviceLocator(), chatDTOMapper: serviceLocator()));
  serviceLocator.registerLazySingleton<MessageRepository>(() => MessageRepImp(serviceLocator(), serviceLocator()));
  serviceLocator.registerLazySingleton<GetStartingMessages>(() => GetStartingMessages(serviceLocator(), serviceLocator()));
  serviceLocator.registerLazySingleton<GetGroupMessages>(() => GetGroupMessages(groupChatRepository: serviceLocator(), chatDTOMapper: serviceLocator()));
  serviceLocator.registerLazySingleton<SendMessage>(() => SendMessage(serviceLocator()));
  serviceLocator.registerLazySingleton<SetUpChatListener>(() => SetUpChatListener(messageRepository: serviceLocator(), chatDTOMapper: serviceLocator()));
  serviceLocator.registerLazySingleton<SetUpStartingChatListeners>(() => SetUpStartingChatListeners(messageRepository: serviceLocator(), chatDTOMapper: serviceLocator()));

  serviceLocator<NetworkInfo>().initialize();
}

class StartFlowWrapper extends StatelessWidget {
  final String title;
  final ThemeData? generalTheme;
  final UserGraphicsClassAttributes _userGraphicsClassAttributes;
  final AuthGraphicsClassAttributes _authGraphicsClassAttributes;
  final ChatGraphicsClassAttributes _chatGraphicsClassAttributes;
  final Widget Function(BuildContext context, bool? loggedIn, bool? loadingDependencies, bool? unloadingDependencies) builder;

  const StartFlowWrapper({
    UserGraphicsClassAttributes userGraphicsClassAttributes = const UserGraphicsClassAttributes(),
    AuthGraphicsClassAttributes authGraphicsClassAttributes = const AuthGraphicsClassAttributes(),
    ChatGraphicsClassAttributes chatGraphicsClassAttributes = const ChatGraphicsClassAttributes(),
    super.key,
    required this.builder,
    required this.title,
    this.generalTheme,
  })  : _userGraphicsClassAttributes = userGraphicsClassAttributes,
        _authGraphicsClassAttributes = authGraphicsClassAttributes,
        _chatGraphicsClassAttributes = chatGraphicsClassAttributes;

  @override
  Widget build(BuildContext context) {
    assert(
      serviceLocator.isRegistered<AuthRepository>(),
      'FlexibleAppStarter is not initialized!',
    );
    // TODO: implement build
    return UserGraphicsClass(
      userSearchResultFormat: _userGraphicsClassAttributes.userSearchResultFormat,
      searchNewUsersFormat: _userGraphicsClassAttributes.searchNewUsersFormat,
      profilePageFormat: _userGraphicsClassAttributes.profilePageFormat,
      child: AuthGraphicsClass(
        signInFormFormat: _authGraphicsClassAttributes.signInFormFormat,
        child: ChatGraphicsClass(
          picWidgetFormat: _chatGraphicsClassAttributes.picWidgetFormat,
          userNameInsteadOfName: _chatGraphicsClassAttributes.userNameInsteadOfName,
          messageAlreadyReadFormat: _chatGraphicsClassAttributes.messageAlreadyReadFormat,
          chatTileLastMessageFormat: _chatGraphicsClassAttributes.chatTileLastMessageFormat,
          messageBubbleFormat: _chatGraphicsClassAttributes.messageBubbleFormat,
          chatroomContentFormat: _chatGraphicsClassAttributes.chatroomContentFormat,
          regularChatTileFormat: _chatGraphicsClassAttributes.regularChatTileFormat,
          scrollingAndRefreshingFormat: _chatGraphicsClassAttributes.scrollingAndRefreshingFormat,
          child: MaterialApp(
            title: title,
            theme: generalTheme,
            home: 
                _multiRepositoryProvider(
                 
                BlocConsumer<AuthInitializeProcessesCubit, AuthProcessState>(
              listener: (context, state) {},
              builder: (context, state)=> builder(
                  context,
                   state.loggedIn,
                  state.loadingDependencies,
                  state.unloadingDependencies,
                 
                )))
              
          ),
        ),
      ),
    );
  }

  MultiRepositoryProvider _multiRepositoryProvider(Widget child) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: serviceLocator<AuthRepository>()),
        ChangeNotifierProvider(create: (_) => ChatService(currentUserOp: serviceLocator(), startingChatListeners: serviceLocator(), getStartingMessagesUseCase: serviceLocator(), sendMessageUseCase: serviceLocator(), sendGroupMessageUseCase: serviceLocator(), setUpChatListener: serviceLocator())..enable()),
        BlocProvider(
          create: (context) => AuthInitializeProcessesCubit(
            chatService: Provider.of<ChatService>(context, listen: false),
            signOutUseCase: serviceLocator<SignOutUseCase>(),
            currentUserOp: serviceLocator<CurrentUserOp>(),
            authRemoteDataSource: serviceLocator<AuthRemoteDataSource>(),
          )..enable(),
        ),
        BlocProvider(create: (context) => GeneralNavigationCubit()),
        BlocProvider(
          create: (context) => UserOpCubit(
            currentUserOp: serviceLocator<CurrentUserOp>(),
            userDataRepository: serviceLocator<UserDataRepository>(),
            getUsersByPrefix: serviceLocator<GetUsersByPrefix>(),
          ),
        ),
      ],
      child: child,
    );
  }
}