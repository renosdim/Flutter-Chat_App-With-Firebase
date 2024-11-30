import 'dart:async';
import 'package:custom_chat_clean_architecture_with_login_firebase/flexibleApp/flexible_app_main.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/flexibleApp/flexible_database__service_enum.dart';

import 'package:custom_chat_clean_architecture_with_login_firebase/operations/auth/presentation/screens/sign_in_screen.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/chat/chat_tab_picker.dart';
import 'package:custom_chat_clean_architecture_with_login_firebase/screens/theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'injection.dart';
import 'operations/auth/current_user.dart';
import 'operations/common/network_info.dart';


typedef AppBuilder = Future<Widget> Function();

Future<void> bootstrap(AppBuilder builder) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url:'https://lkytesrttersudpfdjuz.supabase.co',
    anonKey:'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxreXRlc3J0dGVyc3VkcGZkanV6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzEwNjM1MjQsImV4cCI6MjA0NjYzOTUyNH0.sSVKPTRwhrrHFmQkLfbI9NXDdkcAFkWvBZ7dUEKmuHk'
    ,
    realtimeClientOptions: const RealtimeClientOptions(
    logLevel: RealtimeLogLevel.info,
  ),

  storageOptions: const StorageClientOptions(
  retryAttempts: 10,
  ),
  );
  FlexibleAppStarter().init(flexibleDatabaseService: FlexibleDatabaseService.firebase);
  //WidgetsBinding.instance.addObserver(AppLifecycleListener());
  //FirebaseDatabase.instance.setPersistenceEnabled(true);



  runApp(await builder());
}

void main() {
  bootstrap(
        () async {

          //await CloudMessaging().configurePushNotifications();

          return const App(
        );});
}

class App extends StatefulWidget {
  const App({
    super.key,


  });





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


    return FlexibleAppWrapper(
      title: 'Clean Architecture',
      generalTheme: darkTheme(),
      builder: (
        BuildContext context,
        bool? loggedIn,
        bool? loadingDependencies,
        bool? unloadingDependencies,
      ) {
        if (loadingDependencies == true) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (loggedIn == true) {
          return const Scaffold(
            body: ChatChooser(),
          );
        } else if (loggedIn == false) {
          return const Scaffold(
            body: Center(child: SignInScreen()),
          );
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );




  }
}




