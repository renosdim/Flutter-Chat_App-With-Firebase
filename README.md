
# Custom Chat Application with Firebase Authentication

## Overview

This project is a custom chat application built using Flutter. It leverages Firebase for authentication and real-time data synchronization. The application is structured using clean architecture principles and employs various state management techniques to ensure a scalable and maintainable codebase.

## Project Structure

The project is organized into several key directories:

- **lib/operations**: Contains the core business logic and data handling for authentication, chat, and user operations.
- **lib/screens**: Contains the UI components and graphics classes for the application.
- **lib/flexibleApp**: Contains the main application wrapper and initialization logic.

### Key Directories and Files

- **lib/operations/auth**: Handles authentication logic, including data sources, repositories, use cases, and presentation (state management).
- **lib/operations/chat**: Manages chat functionalities, including data sources, repositories, use cases, and presentation.
- **lib/operations/users**: Manages user-related operations, including data sources, repositories, use cases, and presentation.
- **lib/screens/graphics_classes**: Contains UI components for authentication, chat, and user interfaces.
- **lib/flexibleApp/flexible_app_main.dart**: The main entry point of the application, initializing dependencies and setting up the application structure.

## State Management

The project uses a combination of state management techniques to handle different aspects of the application:

### Bloc (Business Logic Component)

Bloc is used extensively for managing state in the application. It helps separate business logic from UI components, making the code more modular and testable.

- **AuthInitializeProcessesCubit**: Manages the initialization processes for authentication.
- **GeneralNavigationCubit**: Handles navigation-related state.
- **UserOpCubit**: Manages user operations state.

### Provider

Provider is used for dependency injection and state management. It allows for easy access to shared instances of services and state across the widget tree.

- **ChangeNotifierProvider**: Used to provide instances of `ChatService` and other services that need to be accessed throughout the application.

### GetIt

GetIt is used as a service locator to manage dependencies. It allows for easy registration and retrieval of services and repositories.

- **serviceLocator**: A global instance of GetIt used to register and retrieve dependencies.

## Initialization

The `init` function in `flexible_app_main.dart` is responsible for initializing all the necessary dependencies for the application. It registers various data sources, repositories, and use cases with the service locator.

```dart
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
```

## Main Application Wrapper

The `FlexibleAppWrapper` class is the main entry point of the application. It sets up the UI structure and provides the necessary dependencies to the widget tree.

```dart
class FlexibleAppWrapper extends StatelessWidget {
  final String title;
  final ThemeData? generalTheme;
  final UserGraphicsClassAttributes _userGraphicsClassAttributes;
  final AuthGraphicsClassAttributes _authGraphicsClassAttributes;
  final ChatGraphicsClassAttributes _chatGraphicsClassAttributes;
  final Widget Function(BuildContext context, bool? loggedIn, bool? loadingDependencies, bool? unloadingDependencies) builder;

  const FlexibleAppWrapper({
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
      !serviceLocator.isRegistered<AuthRepository>(),
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
            home: BlocConsumer<AuthInitializeProcessesCubit, AuthProcessState>(
              listener: (context, state) {},
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
        ),
      ),
    );
  }

  MultiRepositoryProvider _multiRepositoryProvider(Widget child) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: serviceLocator<AuthRepository>()),
        ChangeNotifierProvider(create: (_) => serviceLocator<ChatService>()),
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
```

## Conclusion

This project demonstrates advanced Flutter development techniques, including clean architecture, state management with Bloc and Provider, and dependency injection with GetIt. The use of Firebase for authentication and real-time data synchronization further showcases the ability to integrate third-party services into a Flutter application.

By following these principles and techniques, the project ensures a scalable, maintainable, and testable codebase, making it an excellent example of professional Flutter development.
