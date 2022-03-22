import 'package:aura/controllers/discussion_controller.dart';
import 'package:aura/models/thread.dart';

import '../controllers/meetups_controller.dart';
import 'meetup.dart';

abstract class Notification {
  bool isRead;
  String _notifID;

  // constructor
  Notification(this.isRead, this._notifID);
  Notification.withoutRead(this._notifID): isRead = false;

  get notifID => _notifID;

  void setRead(bool newReadStatus) {
    isRead = newReadStatus;
  }
  String getTypeMsg();
}

enum ThreadNotifType {
  SUCCESSFULLY_POSTED,
  NEW_COMMENT,
  NEW_LIKE,
  TRENDING
}

class ThreadNotification extends Notification {
  String threadID;
  ThreadNotifType notifType;

  ThreadNotification(this.threadID, this.notifType, read, notifID) : super(read, notifID);

  @override
  String getTypeMsg() {
    switch(notifType) {
      case ThreadNotifType.SUCCESSFULLY_POSTED:
        return "Thread successfully posted";
      case ThreadNotifType.NEW_COMMENT:
        return "New comment on your thread";
      case ThreadNotifType.NEW_LIKE:
        return "New like on your thread";
      case ThreadNotifType.TRENDING:
        return "Trending thread";
    }
  }
}

enum MeetupNotifType {
  SUCCESSFULLY_POSTED,
  SUCCESSFULLY_RSVP,
  REMINDER,
  NEW_COMMENT,
  NEW_ATTENDEE,
  MEETUP_CANCELLED,
  MEETUP_DETAIL_CHANGE
}

class MeetupNotification extends Notification {
  String meetupID;
  MeetupNotifType notifType;

  MeetupNotification(this.meetupID, this.notifType, read, id) : super(read, id);

  @override
  String getTypeMsg() {
    switch(notifType) {
      case MeetupNotifType.SUCCESSFULLY_POSTED:
        return "Meetup successfully posted";
      case MeetupNotifType.SUCCESSFULLY_RSVP:
        return "Meetup successfully RSVPed";
      case MeetupNotifType.REMINDER:
        return "Meetup in 1 hour";
      case MeetupNotifType.NEW_COMMENT:
        return "New comment on your meetup";
      case MeetupNotifType.NEW_ATTENDEE:
        return "New attendee for your meetup";
      case MeetupNotifType.MEETUP_CANCELLED:
        return "Meetup cancelled";
      case MeetupNotifType.MEETUP_DETAIL_CHANGE:
        return "Meetup details changed";
    }
  }
}
