import 'package:aura/models/thread.dart';
import 'package:aura/models/user.dart';
import 'package:aura/view/community/detailed_thread_view.dart';
import 'package:aura/view/community/thread_list_view.dart';
import 'package:aura/view/settings/change_home_address_screen.dart';
import 'package:aura/view/signin/signin_screen.dart';
import 'package:aura/view/tabs/main_tab_bar.dart';
import 'package:aura/view/settings/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
    initialLocation: "/sign-in",
    urlPathStrategy: UrlPathStrategy.path,
    routes: <GoRoute>[
      GoRoute(
          path: "/tabs/:tabName",
          builder: (BuildContext context, GoRouterState state) => MainTabBar(
              key: state.pageKey, currentTab: state.params['tabName']!),
          routes: [
            GoRoute(
                path: 'meetups',
                builder: (BuildContext context, GoRouterState state) =>
                    ThreadListView(
                      key: state.pageKey,
                      topicName: 'meetups',
                    ),
                routes: [
                  GoRoute(
                      path: ':meetupId',
                      builder: (BuildContext context, GoRouterState state) =>
                          Text("detailed_meetup_view goes here"))
                ]),
            GoRoute(
                path: 'topic/:topicName',
                builder: (BuildContext context, GoRouterState state) =>
                    ThreadListView(
                        key: state.pageKey,
                        topicName: state.params['topicName']!),
                routes: [
                  GoRoute(
                    path: 'thread/:threadId',
                    builder: (BuildContext context, GoRouterState state) =>
                        DetailedThreadView(
                            key: state.pageKey,
                            threadID: state.params['threadId']!,
                            // TODO: remove currUser (should be passed via manager
                            currUserID: "1"),
                  )
                ])
          ]),
      GoRoute(
        path: "/settings",
        builder: (BuildContext context, GoRouterState state) =>
            const SettingsScreen(),
        routes: [
          GoRoute(
              path: "change_home_address",
              builder: (BuildContext context, GoRouterState state) =>
                  const ChangeHomeAddressScreen())
        ],
      ),
      GoRoute(
          path: "/sign-in",
          builder: (BuildContext context, GoRouterState state) =>
              const SigninScreen())

      // GoRoute(
      //     path: "/notifications",
      //     builder: (BuildContext context, GoRouterState state) => const NotificationsScreen()),
    ]
    // errorPageBuilder: (context, state) => MaterialPage<void>(
    //   key: state.pageKey,
    //   child: ErrorPage(state.error),
    // ),
    );
