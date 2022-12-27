class Pins {
  final String pins_id;
  final String pinscategory;
  final String pinsimage;
  final String pinstitle;
  final String userId;
  // final String userFname;
  // final String userLname;
  // final String userProfilePic;

  Pins({
    required this.pins_id,
    required this.pinscategory,
    required this.pinsimage,
    required this.pinstitle,
    required this.userId,
    // required this.userFname,
    // required this.userLname,
    // required this.userProfilePic,
  });

  //convert user input into json file
  Map<String, dynamic> toJson() => {
        'pins_id': pins_id,
        'pinscategory': pinscategory,
        'pinsimage': pinsimage,
        'pinstitle': pinstitle,
        'userId': userId,
        // 'userFname': userFname,
        // 'userLname': userLname,
        // 'userProfilePic': userProfilePic,
      };

  //retrieve json file
  static Pins fromJson(Map<String, dynamic> json) => Pins(
        pins_id: json['pins_id'] ?? json['pins_id'],
        pinscategory: json['pinscategory'] ?? json['pinscategory'],
        pinsimage: json['pinsimage'] ?? json['pinsimage'],
        pinstitle: json['pinstitle'] ?? json['pinstitle'],
        userId: json['userId'] ?? json['userId'],
        // userFname: json['userFname'] ?? json['userFname'],
        // userLname: json['userLname'] ?? json['userLname'],
        // userProfilePic: json['userProfilePic'] ?? json['userProfilePic'],
      );
}
