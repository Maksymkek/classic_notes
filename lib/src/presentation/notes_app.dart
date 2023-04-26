import 'package:flutter/material.dart';
import 'package:notes/src/dependencies/di.dart';
import 'package:notes/src/presentation/common_widgets/circle_progress_indicator.dart';

import 'router/router.dart';

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  static final AppNavigation navigation = AppNavigation();
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DI.getInstance().init(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            navigatorObservers: [routeObserver],
            routes: navigation.routes,
            theme: ThemeData(useMaterial3: true),
            initialRoute: navigation.initialRoute,
            onGenerateRoute: navigation.onGenerateRoot,
          );
        } else {
          return const CircleProgressIndicatorWidget();
        }
      },
    );
  }
}
