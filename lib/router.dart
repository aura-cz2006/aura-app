import 'package:aura/globals.dart';
import 'package:aura/managers/thread_manager.dart';
import 'package:aura/models/thread.dart';
import 'package:aura/models/user.dart';
import 'package:aura/view/community/create_meetup_view.dart';
import 'package:aura/view/community/detailed_meetup_view.dart';
import 'package:aura/view/community/detailed_thread_view.dart';
import 'package:aura/view/community/edit_meetup_view.dart';
import 'package:aura/view/community/edit_thread_view.dart';
import 'package:aura/view/community/meetup_listview.dart';
import 'package:aura/view/community/thread_list_view.dart';
import 'package:aura/view/onboarding/introduction_page_view.dart';
import 'package:aura/view/settings/change_home_address_screen.dart';
import 'package:aura/view/signin/signin_screen.dart';
import 'package:aura/view/community/create_thread_view.dart';
import 'package:aura/view/community/notifications_view.dart';
import 'package:aura/view/tabs/main_tab_bar.dart';
import 'package:aura/view/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/discussion_topic.dart';



final router = GoRouter(
    initialLocation: "/sign-in",
    urlPathStrategy: UrlPathStrategy.path,
    routes: <GoRoute>[
      // login route(s) go here
      GoRoute(
        path: "/onboarding",
        builder: (BuildContext context, GoRouterState state) => IntroScreen(key: state.pageKey)
      ),
      GoRoute(
          path: "/tabs/:tabName",
          builder: (BuildContext context, GoRouterState state) => MainTabBar(
              key: state.pageKey, currentTab: state.params['tabName']!),
          routes: [
            GoRoute(
                path: 'meetups',
                builder: (BuildContext context, GoRouterState state) =>
                    MeetUpListView(
                      key: state.pageKey,
                    ),
                routes: [
                  // GoRoute(path: "createMeetup",
                  //     builder: (BuildContext context, GoRouterState state) =>
                  //         CreateMeetupView(
                  //             key: state.pageKey)
                  // ),
                  GoRoute(
                      path: ':meetupId',
                      builder: (BuildContext context, GoRouterState state) =>
                          state.params['meetupId'] == "createMeetup"
                              ? CreateMeetupView(key: state.pageKey)
                              : DetailedMeetupView(
                                  meetupID: state.params['meetupId']!,
                                ),
                      routes: [
                        GoRoute(
                            path: "editMeetup",
                            builder:
                                (BuildContext context, GoRouterState state) =>
                                    EditMeetupView(
                                        meetupID: state.params['meetupId']!))
                      ])
                ]),
            GoRoute(
                path: 'topic/:topicName',
                builder: (BuildContext context, GoRouterState state) =>
                    ThreadListView(
                        key: state.pageKey, topic: TopicConverter.parsable2topic(state.params['topicName']!)), routes: [
                      GoRoute(path: "createThread",
                          builder: (BuildContext context, GoRouterState state) =>
                              CreateThreadView(
                                  key: state.pageKey,
                                  topic: TopicConverter.parsable2topic(state.params['topicName']!))
                      )]),
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
                              threadID: state.params[
                                  'threadId']!) // TODO: replace with thread id
                      )
                ]),
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
                  ChangeHomeAddressScreen())
        ],
      ),
      GoRoute(
          path: "/sign-in",
          builder: (BuildContext context, GoRouterState state) =>
              const SigninScreen())
    ],

    redirect: (state) {
      //Check initial bool value
      final bool? onBoardedInitialValue = Prefs.prefs?.getBool('hasOnboarded');
      //hasOnboarded is either null, True

      final isOnboarding = state.subloc == '/onboarding';

      print({
        onBoardedInitialValue,
        isOnboarding
      });

      //null check. If null, user has NOT onboarded.  If not null, user HAS onboarded.
      final hasOnboarded = (onBoardedInitialValue == null) ? false : true;
      //If user has onboarded, redirect to map. If haven't, go to onboarding.
      if (!hasOnboarded) return isOnboarding ? null : '/onboarding';
      //If have already onboarded, go to map
      if (isOnboarding) return '/tabs/map';


      // if (hasOnboarded) return isOnboarding ? null : '/onboarding';
      //
      // if (isOnboarding) return '/tabs/map';
      //
      // if the user is not logged in, they need to login
      // final bool? prefsLoggedIn = Prefs.prefs?.getBool('isLoggedIn');
      // final loggedIn = (prefsLoggedIn != null) ?? false;
      // final loggingIn = state.subloc == '/login';
      // if (!loggedIn) return loggingIn ? null : '/login';
      //
      // // if the user is logged in but still on the login page, send them to
      // // the home page
      // if (loggingIn) return '/tabs/map';
      //
      // for onboarding
      // no need to redirect at all
      return null;
    },

    // errorPageBuilder: (context, state) => MaterialPage<void>(
    //   key: state.pageKey,
    //   child: ErrorPage(state.error),
    // ),
    );
