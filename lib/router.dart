import 'package:aura/managers/thread_manager.dart';
import 'package:aura/models/thread.dart';
import 'package:aura/models/user.dart';
import 'package:aura/view/community/detailed_meetup_view.dart';
import 'package:aura/view/community/detailed_thread_view.dart';
import 'package:aura/view/community/edit_thread_view.dart';
import 'package:aura/view/community/meetup_listview.dart';
import 'package:aura/view/community/thread_list_view.dart';
import 'package:aura/view/settings/change_home_address_screen.dart';
import 'package:aura/view/signin/signin_screen.dart';
import 'package:aura/view/tabs/community/notifications_view.dart';
import 'package:aura/view/tabs/main_tab_bar.dart';
import 'package:aura/view/settings/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Thread sampleThread = Thread(
    '2',
    'Rafflesia spotted at Raffles City',
    '4',
    'what a gorgeous specimen! \nI love plants! \nBotanics is my favourite hobby, I could go on and on about it for days \nIn short, I love plants!',
    "Nature",
    DateTime.now().add(const Duration(days: 2)));

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
                    MeetUpListView(key: state.pageKey,),
                routes: [
                  GoRoute(
                      path: ':meetupId',
                      builder: (BuildContext context, GoRouterState state) =>
                          DetailedMeetupView(meetupID: state.params['meetupId']!,),
                      routes: [
                        GoRoute(
                            path: "edit",
                            builder:
                                (BuildContext context, GoRouterState state) =>
                                    EditThreadView(threadID: state.params['threadID']!)) // todo: replace this with editMeetupThread
                      ])
                ]),
            GoRoute(
                path: 'topic/:topicName',
                builder: (BuildContext context, GoRouterState state) =>
                    ThreadListView(
                      key: state.pageKey,
                      topic: state.params['topicName']!
                    )),
            GoRoute(
                path: 'thread/:threadId',
                builder: (BuildContext context, GoRouterState state) =>
                    DetailedThreadView(
                        key: state.pageKey,
                        threadID: state.params['threadId']!,
                        ),
                routes: [
                  GoRoute(
                      path: "edit",
                      builder: (BuildContext context, GoRouterState state) =>
                          EditThreadView(
                              threadID: state.params['threadId']!
                          ) // TODO: replace with thread id
                      )
                ]),
            GoRoute(
              path: 'meetup/:meetupId',
              builder: (BuildContext context, GoRouterState state) =>
                  DetailedMeetupView(
                      key: state.pageKey,
                      meetupID: state.params['meetupId']!,),
            ),
            GoRoute(
                path: "notifications",
                builder: (BuildContext context, GoRouterState state) =>
                    const NotificationsView()),
            // TODO: remove currUserId param
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
    ]
    // errorPageBuilder: (context, state) => MaterialPage<void>(
    //   key: state.pageKey,
    //   child: ErrorPage(state.error),
    // ),
    );
