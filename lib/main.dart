// import 'dart:io';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:go_router/go_router.dart';
// // import 'package:google_mobile_ads/google_mobile_ads.dart';
// // import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:logging/logging.dart';
// import 'package:provider/provider.dart';
// import 'package:tictactoe/src/game_internals/board_setting.dart';
//
// import 'firebase_options.dart';
// import 'src/ads/ads_controller.dart';
// import 'src/app_lifecycle/app_lifecycle.dart';
// import 'src/audio/audio_controller.dart';
// import 'src/crashlytics/crashlytics.dart';
// import 'src/games_services/games_services.dart';
// import 'src/games_services/score.dart';
// import 'src/in_app_purchase/in_app_purchase.dart';
// import 'src/level_selection/level_selection_screen.dart';
// import 'src/level_selection/levels.dart';
// import 'src/main_menu/main_menu_screen.dart';
// import 'src/play_session/play_session_screen.dart';
// import 'src/player_progress/persistence/local_storage_player_progress_persistence.dart';
// import 'src/player_progress/persistence/player_progress_persistence.dart';
// import 'src/player_progress/player_progress.dart';
// import 'src/settings/persistence/local_storage_settings_persistence.dart';
// import 'src/settings/persistence/settings_persistence.dart';
// import 'src/settings/settings.dart';
// import 'src/settings/settings_screen.dart';
// import 'src/style/ink_transition.dart';
// import 'src/style/palette.dart';
// import 'src/style/snack_bar.dart';
// import 'src/win_game/win_game_screen.dart';
//
// Future<void> main() async {
//   FirebaseCrashlytics? crashlytics;
//   if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
//     try {
//       WidgetsFlutterBinding.ensureInitialized();
//       await Firebase.initializeApp(
//         options: DefaultFirebaseOptions.currentPlatform,
//       );
//       crashlytics = FirebaseCrashlytics.instance;
//       FlutterError.onError = (errorDetails) {
//         FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
//       };
//       PlatformDispatcher.instance.onError = (error, stack) {
//         FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
//         return true;
//       };
//     } catch (e) {
//       debugPrint("Firebase couldn't be initialized: $e");
//     }
//   }
//
//   if (kDebugMode) {
//     // Log more when in debug mode.
//     Logger.root.level = Level.FINE;
//   }
//   // Subscribe to log messages.
//   Logger.root.onRecord.listen((record) {
//     final message = '${record.level.name}: ${record.time}: '
//         '${record.loggerName}: '
//         '${record.message}';
//
//     debugPrint(message);
//     // Add the message to the rotating Crashlytics log.
//     crashlytics?.log(message);
//
//     if (record.level >= Level.SEVERE) {
//       crashlytics?.recordError(message, filterStackTrace(StackTrace.current),
//           fatal: true);
//     }
//   });
//
//   _log.info('Going full screen');
//   SystemChrome.setEnabledSystemUIMode(
//     SystemUiMode.edgeToEdge,
//   );
//
//   AdsController? adsController;
//   // if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
//   //   /// Prepare the google_mobile_ads plugin so that the first ad loads
//   //   /// faster. This can be done later or with a delay if startup
//   //   /// experience suffers.
//   //   adsController = AdsController(MobileAds.instance);
//   //   adsController.initialize();
//   // }
//
//   GamesServicesController? gamesServicesController;
//   // if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
//   //   gamesServicesController = GamesServicesController()
//   //     // Attempt to log the player in.
//   //     ..initialize();
//   // }
//
//   InAppPurchaseController? inAppPurchaseController;
//   // if (!kIsWeb && (Platform.isIOS || Platform.isAndroid)) {
//   //   inAppPurchaseController = InAppPurchaseController(InAppPurchase.instance)
//   //     // Subscribing to [InAppPurchase.instance.purchaseStream] as soon
//   //     // as possible in order not to miss any updates.
//   //     ..subscribe();
//   //   // Ask the store what the player has bought already.
//   //   inAppPurchaseController.restorePurchases();
//   // }
//
//   runApp(
//     MyApp(
//       settingsPersistence: LocalStorageSettingsPersistence(),
//       playerProgressPersistence: LocalStoragePlayerProgressPersistence(),
//       inAppPurchaseController: inAppPurchaseController,
//       adsController: adsController,
//       gamesServicesController: gamesServicesController,
//     ),
//   );
// }
//
// Logger _log = Logger('main.dart');
//
// class MyApp extends StatelessWidget {
//   static final _router = GoRouter(
//     routes: [
//       GoRoute(
//           path: '/',
//           builder: (context, state) =>
//               const MainMenuScreen(key: Key('main menu')),
//           routes: [
//             GoRoute(
//                 path: 'play',
//                 pageBuilder: (context, state) => buildTransition<void>(
//                       child: const LevelSelectionScreen(
//                           key: Key('level selection')),
//                       color: context.watch<Palette>().backgroundLevelSelection,
//                     ),
//                 routes: [
//                   GoRoute(
//                     path: 'session/:level',
//                     pageBuilder: (context, state) {
//                       final levelNumber =
//                           int.parse(state.pathParameters['level']!);
//                       final level = gameLevels
//                           .singleWhere((e) => e.number == levelNumber);
//                       return buildTransition<void>(
//                         child: PlaySessionScreen(
//                           level,
//                           key: const Key('play session'),
//                         ),
//                         color: context.watch<Palette>().backgroundPlaySession,
//                         flipHorizontally: true,
//                       );
//                     },
//                   ),
//                   GoRoute(
//                     path: 'won',
//                     pageBuilder: (context, state) {
//                       final map =state.extra !=null? state.extra! as Map<String, dynamic>:{'score':0} as Map<String, dynamic>;
//                        final score = map['score'] as Score;
//                       //final score = map['score'] != null ? map['score'] as Score : Score(0, const BoardSetting(), Duration.zero, 0);
//                       return buildTransition<void>(
//                         child: WinGameScreen(
//                           score: score,
//                           key: const Key('win game'),
//                         ),
//                         color: context.watch<Palette>().backgroundPlaySession,
//                         flipHorizontally: true,
//                       );
//                     },
//                   )
//                 ]),
//             GoRoute(
//               path: 'settings',
//               builder: (context, state) =>
//                   const SettingsScreen(key: Key('settings')),
//             ),
//           ]),
//     ],
//   );
//
//   final PlayerProgressPersistence playerProgressPersistence;
//
//   final SettingsPersistence settingsPersistence;
//
//   final GamesServicesController? gamesServicesController;
//
//   final InAppPurchaseController? inAppPurchaseController;
//
//   final AdsController? adsController;
//
//   const MyApp({
//     required this.playerProgressPersistence,
//     required this.settingsPersistence,
//     required this.inAppPurchaseController,
//     required this.adsController,
//     required this.gamesServicesController,
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AppLifecycleObserver(
//       child: MultiProvider(
//         providers: [
//           ChangeNotifierProvider(
//             create: (context) {
//               var progress = PlayerProgress(playerProgressPersistence);
//               progress.getLatestFromStore();
//               return progress;
//             },
//           ),
//           Provider<GamesServicesController?>.value(
//               value: gamesServicesController),
//           Provider<AdsController?>.value(value: adsController),
//           ChangeNotifierProvider<InAppPurchaseController?>.value(
//               value: inAppPurchaseController),
//           Provider<SettingsController>(
//             lazy: false,
//             create: (context) => SettingsController(
//               persistence: settingsPersistence,
//             )..loadStateFromPersistence(),
//           ),
//           ProxyProvider2<SettingsController, ValueNotifier<AppLifecycleState>,
//               AudioController>(
//             // Ensures that the AudioController is created on startup,
//             // and not "only when it's needed", as is default behavior.
//             // This way, music starts immediately.
//             lazy: false,
//             create: (context) => AudioController()..initialize(),
//             update: (context, settings, lifecycleNotifier, audio) {
//               if (audio == null) throw ArgumentError.notNull();
//               audio.attachSettings(settings);
//               audio.attachLifecycleNotifier(lifecycleNotifier);
//               return audio;
//             },
//             dispose: (context, audio) => audio.dispose(),
//           ),
//           Provider(
//             create: (context) => Palette(),
//           ),
//         ],
//         child: Builder(builder: (context) {
//           final palette = context.watch<Palette>();
//
//           return MaterialApp.router(
//             title: 'Tic Tac Toe',
//             debugShowCheckedModeBanner: false,
//             theme: ThemeData.from(
//               colorScheme: ColorScheme.fromSeed(
//                 seedColor: palette.darkPen,
//                 background: palette.backgroundMain,
//               ),
//               textTheme: TextTheme(
//                 bodyMedium: TextStyle(
//                   color: palette.ink,
//                 ),
//               ),
//             ),
//             routeInformationProvider: _router.routeInformationProvider,
//             routeInformationParser: _router.routeInformationParser,
//             routerDelegate: _router.routerDelegate,
//             scaffoldMessengerKey: scaffoldMessengerKey,
//           );
//         }),
//       ),
//     );
//   }
// }


import 'dart:developer';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:tictactoe/src/game_internals/board_setting.dart';

import 'firebase_options.dart';
import 'src/ads/ads_controller.dart';
import 'src/app_lifecycle/app_lifecycle.dart';
import 'src/audio/audio_controller.dart';
import 'src/crashlytics/crashlytics.dart';
import 'src/games_services/games_services.dart';
import 'src/games_services/score.dart';
import 'src/in_app_purchase/in_app_purchase.dart';
import 'src/level_selection/level_selection_screen.dart';
import 'src/level_selection/levels.dart';
import 'src/main_menu/main_menu_screen.dart';
import 'src/play_session/play_session_screen.dart';
import 'src/player_progress/persistence/local_storage_player_progress_persistence.dart';
import 'src/player_progress/persistence/player_progress_persistence.dart';
import 'src/player_progress/player_progress.dart';
import 'src/settings/persistence/local_storage_settings_persistence.dart';
import 'src/settings/persistence/settings_persistence.dart';
import 'src/settings/settings.dart';
import 'src/settings/settings_screen.dart';
import 'src/style/ink_transition.dart';
import 'src/style/palette.dart';
import 'src/style/snack_bar.dart';
import 'src/win_game/win_game_screen.dart';

class MyModuleApp extends StatefulWidget {
  final PlayerProgressPersistence playerProgressPersistence;
  final SettingsPersistence settingsPersistence;
  final GamesServicesController? gamesServicesController;
  final InAppPurchaseController? inAppPurchaseController;
  // final AdsController? adsController;
  final String? userId;
  const MyModuleApp({
    required this.playerProgressPersistence,
    required this.settingsPersistence,
    required this.inAppPurchaseController,
     this.userId,
    this.gamesServicesController,
    super.key,
  });

  @override
  _MyModuleAppState createState() => _MyModuleAppState();
}

class _MyModuleAppState extends State<MyModuleApp> {
  final GlobalKey<NavigatorState>? navigatorKey = GlobalKey<NavigatorState>();
  late final GoRouter _router;


  @override
  void initState() {
    super.initState();
    // Initialize Google Mobile Ads SDK
   // load();
   _router = GoRouter(
      navigatorKey: navigatorKey,
      routes: [
        GoRoute(
            path: '/',
            name: 'main',
            builder: (context, state) =>
            const MainMenuScreen(key: Key('main menu')),
            routes: [
              GoRoute(
                  path: 'play',
                  name:'play',
                  pageBuilder: (context, state) => buildTransition<void>(
                    child: const LevelSelectionScreen(
                        key: Key('level selection')),
                    color: context.watch<Palette>().backgroundLevelSelection,
                  ),
                  routes: [
                    GoRoute(
                      path: 'session/:level',
                      name: 'session/:level',
                      pageBuilder: (context, state) {
                        final levelNumber =
                        int.parse(state.pathParameters['level']!);
                        final level = gameLevels
                            .singleWhere((e) => e.number == levelNumber);
                        return buildTransition<void>(
                          child: PlaySessionScreen(
                            level,
                            key: const Key('play session'),
                          ),
                          color: context.watch<Palette>().backgroundPlaySession,
                          flipHorizontally: true,
                        );
                      },
                    ),
                    GoRoute(
                      path: 'won',
                      name: 'won',
                      pageBuilder: (context, state) {
                        final map = state.extra != null
                            ? state.extra! as Map<String, dynamic>
                            : {'score': 0} as Map<String, dynamic>;
                        final score = map['score'] as Score;
                        return buildTransition<void>(
                          child: WinGameScreen(
                            score: score,
                            key: const Key('win game'), userId: widget.userId!,
                          ),
                          color: context.watch<Palette>().backgroundPlaySession,
                          flipHorizontally: true,
                        );
                      },
                    )
                  ]),
              GoRoute(
                path: 'settings',
                name: 'settings',
                builder: (context, state) =>
                const SettingsScreen(key: Key('settings')),
              ),
            ]),
      ],
    );
  }

  // load()async{
  //   await MobileAds.instance.initialize();
  // }


  @override
  Widget build(BuildContext context) {

 print("ebs user id =${widget.userId}");
    return WillPopScope(
      onWillPop: () async {
        if (navigatorKey!.currentState!.canPop()) {
          navigatorKey!.currentState!.pop();
          return false;
        } else {
          return true;
        }
      },
      child: AppLifecycleObserver(
        child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) {
                var progress = PlayerProgress(widget.playerProgressPersistence);
                progress.getLatestFromStore();
                return progress;
              },
            ),
            Provider<GamesServicesController?>.value(
                value: widget.gamesServicesController),
           // Provider<AdsController?>.value(value: widget.adsController),
            ChangeNotifierProvider<InAppPurchaseController?>.value(
                value: widget.inAppPurchaseController),
            Provider<SettingsController>(
              lazy: false,
              create: (context) => SettingsController(
                persistence: widget.settingsPersistence,
              )..loadStateFromPersistence(),
            ),
            ProxyProvider2<SettingsController, ValueNotifier<AppLifecycleState>,
                AudioController>(
              lazy: false,
              create: (context) => AudioController()..initialize(),
              update: (context, settings, lifecycleNotifier, audio) {
                if (audio == null) throw ArgumentError.notNull();
                audio.attachSettings(settings);
                audio.attachLifecycleNotifier(lifecycleNotifier);
                return audio;
              },
              dispose: (context, audio) => audio.dispose(),
            ),
            Provider(
              create: (context) => Palette(),
            ),
          ],
          child: Builder(builder: (context) {
            final palette = context.watch<Palette>();

            return MaterialApp.router(
              title: 'Tic Tac Toe',
              debugShowCheckedModeBanner: false,
              theme: ThemeData.from(
                colorScheme: ColorScheme.fromSeed(
                  seedColor: palette.darkPen,
                  background: palette.backgroundMain,
                ),
                textTheme: TextTheme(
                  bodyMedium: TextStyle(
                    color: palette.ink,
                  ),
                ),
              ),
              routeInformationProvider: _router.routeInformationProvider,
              routeInformationParser: _router.routeInformationParser,
              routerDelegate: _router.routerDelegate,
            );
          }),
        ),
      ),
    );
  }
}

