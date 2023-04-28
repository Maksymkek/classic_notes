import 'package:flutter/material.dart';
import 'package:notes/src/dependencies/di.dart';
import 'package:notes/src/presentation/common_widgets/circle_progress_indicator.dart';

import 'router/router.dart';

class NotesApp extends StatefulWidget {
  const NotesApp({super.key});

  static final AppNavigation navigation = AppNavigation();
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();

  @override
  State<NotesApp> createState() => _NotesAppState();
}

class _NotesAppState extends State<NotesApp> {
  final diInit = DI.getInstance().init();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: diInit,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            navigatorObservers: [NotesApp.routeObserver],
            routes: NotesApp.navigation.routes,
            theme: ThemeData(useMaterial3: true),
            initialRoute: NotesApp.navigation.initialRoute,
            onGenerateRoute: NotesApp.navigation.onGenerateRoot,
          );
        } else {
          return const CircleProgressIndicatorWidget();
        }
      },
    );
  }
}
