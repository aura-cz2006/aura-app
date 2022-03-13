import 'package:aura/controllers/discussion_controller.dart';
import 'package:aura/models/thread.dart';

import '../controllers/meetups_controller.dart';
import 'meetup.dart';

abstract class Notification {
  bool read;

  // constructor
  Notification(this.read);
  Notification.withoutRead(): read = false;

  void markRead() {
    read = true;
  }
  @override
  String toString() {
    return 'Notification: {read: $read}';
  }
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

  ThreadNotification(this.threadID, this.notifType, read) : super(read);
  ThreadNotification.withoutRead(this.threadID, this.notifType) : super.withoutRead();

  @override
  String toString() {
    return 'Thread Notification: {read: $read, text: $getText(), ID: $threadID, type: $notifType}';
  }
  String getText(DiscussionController discCtrl) {
    Thread thread = discCtrl.getThread(threadID); // TODO
    switch(notifType) {
      case ThreadNotifType.SUCCESSFULLY_POSTED:
        return "Thread successfully posted: \"${thread.title}\"";
      case ThreadNotifType.NEW_COMMENT:
        return "New comment on your thread: \"${thread.title}\"";
      case ThreadNotifType.NEW_LIKE:
        return "New like on your thread: \"${thread.title}\"";
      case ThreadNotifType.TRENDING:
        return "Trending thread: \"${thread.title}\"";
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

  MeetupNotification(this.meetupID, this.notifType, read) : super(read);
  MeetupNotification.withoutRead(this.meetupID, this.notifType) : super.withoutRead();

  @override
  String toString() {
    return 'Meetup Notification: {read: $read, text: $getText(), ID: $meetupID, type: $notifType}';
  }
  String getText(MeetupsController meetCtrl) {
    Meetup meetup = meetCtrl.getMeetup(meetupID); // TODO
    switch(notifType) {
      case MeetupNotifType.SUCCESSFULLY_POSTED:
        return "Meetup successfully posted: \"${meetup.title}\"";
      case MeetupNotifType.SUCCESSFULLY_RSVP:
        return "Meetup successfully RSVPed: \"${meetup.title}\"";
      case MeetupNotifType.REMINDER:
        return "Meetup in 1 hour: \"${meetup.title}\"";
      case MeetupNotifType.NEW_COMMENT:
        return "New comment on your meetup: \"${meetup.title}\"";
      case MeetupNotifType.NEW_ATTENDEE:
        return "New attendee for your meetup: \"${meetup.title}\"";
      case MeetupNotifType.MEETUP_CANCELLED:
        return "Meetup cancelled: \"${meetup.title}\"";
      case MeetupNotifType.MEETUP_DETAIL_CHANGE:
        return "Meetup details changed: \"${meetup.title}\"";
    }
  }
}
