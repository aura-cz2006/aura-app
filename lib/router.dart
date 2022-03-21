import 'package:aura/models/thread.dart';
import 'package:aura/models/user.dart';
import 'package:aura/view/community/detailed_thread_view.dart';
import 'package:aura/view/community/thread_list_view.dart';
import 'package:aura/view/settings/change_home_address_screen.dart';
import 'package:aura/view/tabs/main_tab_bar.dart';
import 'package:aura/view/settings/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
    initialLocation: "/tabs/map",
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
                            // TODO: only supply strings to the widget here:
                            // thread: state.params['threadId']!,
                            thread: Thread(
                                "TEST_ID",
                                "This is the Title.",
                                User("SOME_UID", "SOME_USERNAME"),
                                "This is the thread content.",
                                DateTime.now()),
                            // TODO: remove currUser (should be passed via manager
                            currUser: User("CURR_UID", "CURR_USERNAME")),
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

      // GoRoute(
      //     path: "/notifications",
      //     builder: (BuildContext context, GoRouterState state) => const NotificationsScreen()),
    ]
    // errorPageBuilder: (context, state) => MaterialPage<void>(
    //   key: state.pageKey,
    //   child: ErrorPage(state.error),
    // ),
    );
