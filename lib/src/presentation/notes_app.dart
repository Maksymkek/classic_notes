import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:notes/src/dependencies/di.dart';

//import 'generated/locale_keys.g.dart';
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
  late final Future<void> diInit;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [NotesApp.routeObserver],
      routes: NotesApp.navigation.routes,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(useMaterial3: true),
      onGenerateRoute: NotesApp.navigation.onGenerateRoot,
      home: FutureBuilder(
        future: diInit,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            setCurrentLocale(context);
            final myFoo =
                NotesApp.navigation.routes[NotesApp.navigation.initialRoute];
            return myFoo!(context);
          } else {
            final myFoo =
                NotesApp.navigation.routes[NotesApp.navigation.loadRoute];
            return myFoo!(context);
          }
        },
      ),
    );
  }

  void setCurrentLocale(BuildContext context) {
    context.setLocale(
      Locale(
        ServiceLocator.getInstance().appSettingsCubit.state.language.value,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    diInit = ServiceLocator.getInstance().init();
  }
}
