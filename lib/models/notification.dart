import 'package:aura/controllers/discussion_controller.dart';
import 'package:aura/models/thread.dart';

import '../controllers/meetups_controller.dart';
import 'meetup.dart';

abstract class Notification {
  bool read;
  String _id;

  // constructor
  Notification(this.read, this._id);
  Notification.withoutRead(this._id): read = false;

  get id => _id;

  void setRead(newReadStatus) {
    read = newReadStatus;
  }
  String getText();
  @override
  String toString() {
    return 'Notification: {read: $read, id: $_id}';
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

  ThreadNotification(this.threadID, this.notifType, read, id) : super(read, id);

  @override
  String toString() {
    return 'Thread Notification: {read: $read, text: $getText(), ID: $threadID, type: $notifType}';
  }
  @override
  String getText() {
    Thread thread = DiscussionController.getThread(threadID); // TODO
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

  MeetupNotification(this.meetupID, this.notifType, read, id) : super(read, id);

  @override
  String toString() {
    return 'Meetup Notification: {read: $read, text: $getText(), ID: $meetupID, type: $notifType}';
  }
  @override
  String getText() {
    Meetup meetup = MeetupsController.getMeetup(meetupID); // TODO
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
