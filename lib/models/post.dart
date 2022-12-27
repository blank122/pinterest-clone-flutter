class Post {
  // final String userimg;
  // final String username;
  // final String time;
  final String post_id;
  final String postcontent;
  final String postTitle;
  final String postimg;
  final String userid;
  // final String numcomments;
  // final String numshare;
  // bool isLiked;

  Post({
    // required this.userimg,
    // required this.username,
    // required this.time,
    required this.post_id,
    required this.postcontent,
    required this.postTitle,
    required this.postimg,
    required this.userid,

    // required this.numcomments,
    // required this.numshare,
    // required this.isLiked,
  });

  Map<String, dynamic> toJson() => {
        // 'userimg': userimg,
        // 'username': username,
        // 'time': time,
        'post_id': post_id,
        'postcontent': postcontent,
        'postTitle': postTitle,

        'postimg': postimg,
        'userid': userid,

        // 'numcomments': numcomments,
        // 'numshare': numshare,
        // 'isLiked': isLiked,
      };

  static Post fromJson(Map<String, dynamic> json) => Post(
        // userimg: json['userimg'],
        // username: json['username'],
        // time: json['time'],
        post_id: json['post_id'],
        postcontent: json['postcontent'],
        postTitle: json['postTitle'],

        postimg: json['postimg'],
        userid: json['userid'],

        // numcomments: json['numcomments'],
        // numshare: json['numshare'],
        // isLiked: json['isLiked'],
      );
}
