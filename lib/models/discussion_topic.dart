enum DiscussionTopic { MEETUPS, GENERAL, FOOD, IT, SPORTS, NATURE }

extension TopicConverter on DiscussionTopic {
  static Map<DiscussionTopic, Map<String, String>> topicMap = {
    DiscussionTopic.MEETUPS: {
      "readable": "Meetups",
      "parsable": "meetups"
    },
    DiscussionTopic.GENERAL: {
      "readable": "General Discussion",
      "parsable": "general"
    },
    DiscussionTopic.FOOD: {
      "readable": "Food",
      "parsable": "food"
    },
    DiscussionTopic.IT: {
      "readable": "IT",
      "parsable": "tech"
    },
    DiscussionTopic.SPORTS: {
      "readable": "Sports",
      "parsable": "sports"
    },
    DiscussionTopic.NATURE: {
      "readable": "Nature",
      "parsable": "nature"
    },
  };

  String topic2readable() {
    if (topicMap.containsKey(this)) {
      return topicMap[this]!["readable"] ?? "ERROR DISPLAYING TOPIC";
    }
    else {
      return "UNKNOWN TOPIC";
    }
  }

  String topic2parsable() {
    if (topicMap.containsKey(this)) {
      return topicMap[this]!["parsable"] ?? "error";
    }
    else {
      return "error";
    }
  }

  static DiscussionTopic parsable2topic(String parsable) {
    return (topicMap.keys).firstWhere((key) => topicMap[key]!["parsable"] == parsable);
  }

  bool isThreadTopic() {
    if (this == DiscussionTopic.MEETUPS) {
      return false;
    } else {
      return true;
    }
  }
}
