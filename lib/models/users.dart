class Users {
  final String id;
  final String firstname;
  final String lastname;
  final String password;
  final String email;
  final String profilePic;

  Users({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.password,
    required this.email,
    required this.profilePic,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstname': firstname,
        'lastname': lastname,
        'password': password,
        'email': email,
        'profilePic': profilePic,
      };

  static Users fromJson(Map<String, dynamic> json) => Users(
        id: json['id'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        password: json['password'],
        email: json['email'],
        profilePic: json['profilePic'],
      );
}
