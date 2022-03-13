class Thread {
  String? id;
  String? title;

  // late String body;
  // late List<String> comments; // todo: change this to List<Comment>
  // late User author;
  // late List<User> likedBy;

  // constructor
  Thread(
    this.id,
    this.title, // body, comments, author, likedBy
  );

  @override
  String toString() {
    return 'Discussion: {id: ${id ?? ""}, title: ${title ?? ""}}';
  }
}
