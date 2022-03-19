import 'package:aura/main_tab_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
    initialLocation: "/tabs/map",
    urlPathStrategy: UrlPathStrategy.path,
    routes: <GoRoute>[
  GoRoute(
      path: "/tabs/:tabName",
      builder: (BuildContext context, GoRouterState state) =>
          MainTabBar(key: state.pageKey, currentTab: state.params['tabName']!)),
  // GoRoute(
  //     path: "/settings",
  //     builder: (BuildContext context, GoRouterState state) => const SettingsScreen()),
  // GoRoute(
  //     path: "/notifications",
  //     builder: (BuildContext context, GoRouterState state) => const NotificationsScreen()),
]
    // errorPageBuilder: (context, state) => MaterialPage<void>(
    //   key: state.pageKey,
    //   child: ErrorPage(state.error),
    // ),
    );
