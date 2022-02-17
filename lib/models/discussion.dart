class Discussion {
  String? id;
  String? title;

  // late String body;
  // late List<String> comments; // todo: change this to List<Comment>
  // late User author;
  // late List<User> likedBy;

  // constructor
  Discussion(
    this.id,
    this.title, // body, comments, author, likedBy
  );

  @override
  String toString() {
    return 'Discussion: {id: ${id ?? ""}, title: ${title ?? ""}}';
  }
}
