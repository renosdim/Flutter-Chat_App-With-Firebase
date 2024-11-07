//
// import 'package:custom_chat_clean_architecture_with_login_firebase/flexibleApp/flexible_database__service_enum.dart';
// import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/data/data_sources/auth_remote_data_source_firebase.dart';
// import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/domain/use_cases/sign_in_use_case.dart';
// import 'package:custom_chat_clean_architecture_with_login_firebase/operations/chat/regular_chat/data/data_sources/chat_data_source.dart';
// import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/data/data_sources/user_data_local_source.dart';
// import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/data/data_sources/user_data_remote_source.dart';
// import 'package:custom_chat_clean_architecture_with_login_firebase/operations/users/domain/entities/user_data_entity.dart';
// import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/chat_tab_picker.dart';
// import 'package:custom_chat_clean_architecture_with_login_firebase/screens/graphics_classes/chat_graphics_class.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/cupertino.dart';
//
// import '../injection.dart';
// import '../operations/auth/current_user.dart';
// import '../operations/auth/data/data_sources/auth_local_data_source.dart';
// import '../operations/auth/data/data_sources/auth_remote_data_source.dart';
// import '../operations/auth/data/repositories/auth_repository_impl.dart';
// import '../operations/auth/domain/repositories/auth_repository.dart';
// import '../operations/auth/domain/use_cases/chech_username_existence.dart';
// import '../operations/auth/domain/use_cases/sign_out_use_case.dart';
// import '../operations/chat/regular_chat/data/data_sources/common_chat_data_source.dart';
// import '../operations/chat/regular_chat/data/repositories/group_chat_rep_impl.dart';
// import '../operations/chat/regular_chat/data/repositories/message_rep_impl.dart';
// import '../operations/chat/regular_chat/domain/repositories/group_chat_repository.dart';
// import '../operations/chat/regular_chat/domain/repositories/message_repository.dart';
// import '../operations/chat/regular_chat/domain/usecases/find_friends_to_text.dart';
// import '../operations/chat/regular_chat/domain/usecases/get_group_messages.dart';
// import '../operations/chat/regular_chat/domain/usecases/get_starting_messages_usecase.dart';
// import '../operations/chat/regular_chat/domain/usecases/group_chat_listener_usecase.dart';
// import '../operations/chat/regular_chat/domain/usecases/send_group_message_usecase.dart';
// import '../operations/chat/regular_chat/domain/usecases/send_message_usecase.dart';
// import '../operations/chat/regular_chat/domain/usecases/set_up_starting_chat_listeners.dart';
// import '../operations/chat/regular_chat/domain/usecases/setup_chat_listener_usecase.dart';
// import '../operations/chat/regular_chat/dtos/chat_dto_mapper.dart';
// import '../operations/chat/regular_chat/presentation/ChatService.dart';
// import '../operations/common/network_info.dart';
// import '../operations/users/data/repositories/user_data_repository_impl.dart';
// import '../operations/users/domain/repositories/user_data_repository.dart';
// import '../operations/users/domain/usecases/get_users_by_prefix_usecase.dart';
// import '../screens/example_chat_tiles.dart';
// class AuthUseCases{
//   final SignOutUseCase signOutUseCase;
//   final SignInUseCase signInUseCase;
//   const AuthUseCases({required this.signInUseCase,required this.signOutUseCase});
// }
// class UserUseCases{
//
// }
//
// class FlexibleAppStarter {
//   static final FlexibleAppStarter _instance = FlexibleAppStarter._internal();
//   late final    CurrentUserOp currentUserOp;
//   late final AuthUseCases authUseCases;
//   late final chatService;
//   // Private named constructor
//   FlexibleAppStarter._internal();
//
//   // Factory constructor to return the singleton instance
//   factory FlexibleAppStarter() {
//     return _instance;
//   }
//
//   // Initialization function
//   void init({
//     required FlexibleDatabaseService flexibleDatabaseService,
//     AuthRemoteDataSource? authRemoteDataSource,
//     ChatDataSource? chatDataSource,
//     FirebaseOptions? firebaseOptions,
//     UserDataRemoteSource? userDataRemoteSource,
//     UserDataLocalSource? userDataLocalSource,
//     ChatGraphicsClass chatGraphicsClass = const ChatGraphicsClass(),
//   }) {
//       assert(flexibleDatabaseService==FlexibleDatabaseService.other && (authRemoteDataSource==null || userDataRemoteSource==null ||chatDataSource==null),''
//           'Since ur not using firebase for your backend application authRemoteDataSource and userDataRemoteSource and chatDataSource cannot be null');
//       assert(flexibleDatabaseService==FlexibleDatabaseService.firebase && firebaseOptions==null,
//           'Missing Firebase options file ');
//
//     // Assign the provided or default values to the fields
//     serviceLocator.registerLazySingleton<NetworkInfo>(() => NetworkInfo());
//
//     serviceLocator.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSource());
//     serviceLocator.registerLazySingleton<AuthRemoteDataSource>(() =>authRemoteDataSource??AuthRemoteDataSourceFirebase());
//     serviceLocator.registerLazySingleton(() => CurrentUserOp(authRemoteDataSource: serviceLocator()));
//     currentUserOp = serviceLocator<CurrentUserOp>();
//     serviceLocator.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(serviceLocator(), remoteDataSource: serviceLocator(), localDataSource: serviceLocator()));
//
//     serviceLocator.registerLazySingleton<SignOutUseCase>(()=>SignOutUseCase(authRepository: serviceLocator()));
//     serviceLocator.registerLazySingleton<SignInUseCase>(()=>SignInUseCase(authRepository: serviceLocator()));
//     authUseCases = AuthUseCases(signInUseCase: serviceLocator<SignInUseCase>(), signOutUseCase: serviceLocator<SignOutUseCase>());
//     serviceLocator.registerLazySingleton<CheckUsernameExistenceUseCase>(()=>CheckUsernameExistenceUseCase(serviceLocator()));
//     serviceLocator.registerLazySingleton<UserDataLocalSource>(() => UserDataLocalSource());
//     serviceLocator.registerLazySingleton<UserDataRemoteSource>(() => UserDataRemoteSource(userDataLocalSource: serviceLocator(), currentUserOp: serviceLocator()));
//     serviceLocator.registerLazySingleton<UserDataRepository>(() =>
//         UserDataRepImpl(remoteSource: serviceLocator(), networkInfo: serviceLocator(), localSource: serviceLocator()));
//
//     serviceLocator.registerLazySingleton<GetUsersByPrefix>(() => GetUsersByPrefix( serviceLocator())) ;
//
//     serviceLocator.registerLazySingleton<FindFriendsToText>(()=>FindFriendsToText(currentUserOp:serviceLocator(),userDataRepository: serviceLocator()));
//
//
//     serviceLocator.registerLazySingleton<ChatDTOMapper>(() => ChatDTOMapper(userDataRepository: serviceLocator()));
//     serviceLocator.registerLazySingleton<ChatDataSource>(()=>chatDataSource??MessageRemoteSource(currentUserOp: serviceLocator()));
//     serviceLocator.registerLazySingleton<GroupChatRepository>(()=>GroupChatRepImpl(groupChatRemoteSource: serviceLocator(), networkInfo: serviceLocator()));
//     serviceLocator.registerLazySingleton<SendGroupMessage>(()=>SendGroupMessage(groupChatRepository: serviceLocator()));
//     serviceLocator.registerLazySingleton<SetUpGroupChatListener>(()=>SetUpGroupChatListener(groupChatRepository: serviceLocator(), chatDTOMapper: serviceLocator()));
//     serviceLocator.registerLazySingleton<MessageRepository>(()=>MessageRepImp(serviceLocator(),serviceLocator()));
//     serviceLocator.registerLazySingleton<GetStartingMessages>(()=>GetStartingMessages(serviceLocator(),serviceLocator()));
//     serviceLocator.registerLazySingleton<GetGroupMessages>(()=>GetGroupMessages(groupChatRepository: serviceLocator(), chatDTOMapper: serviceLocator()));
//     serviceLocator.registerLazySingleton<SendMessage>(()=>SendMessage(serviceLocator()));
//     serviceLocator.registerLazySingleton<SetUpChatListener>(()=>SetUpChatListener(messageRepository: serviceLocator(), chatDTOMapper:serviceLocator()));
//     serviceLocator.registerLazySingleton<SetUpStartingChatListeners>(()=>SetUpStartingChatListeners(messageRepository: serviceLocator(), chatDTOMapper:serviceLocator()));
//
//     serviceLocator.registerLazySingleton<ChatService>(()=>ChatService(
//         currentUserOp:serviceLocator(),
//         getGroupMessagesUseCase:serviceLocator(),
//         getStartingMessagesUseCase:serviceLocator(),
//         sendMessageUseCase:serviceLocator(),
//         sendGroupMessageUseCase:serviceLocator(),
//         setUpChatListener:serviceLocator(),
//         setUpGroupChatListener:serviceLocator(),
//         startingChatListeners:serviceLocator(), chatGraphicsClass: chatGraphicsClass));
//
//     chatService = serviceLocator<ChatService>();
//     //await serviceLocator<PlaceOp>().getPlaces();
//   }
// }
