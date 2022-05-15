class User {
  int? id;
  String? username;
  String? password;
  String? email;
  Null? refreshToken;
  String? firstname;
  String? lastname;
  bool? active;
  Null? activationToken;
  Null? resetPasswordToken;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  User(
      {this.id,
      this.username,
      this.password,
      this.email,
      this.refreshToken,
      this.firstname,
      this.lastname,
      this.active,
      this.activationToken,
      this.resetPasswordToken,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    refreshToken = json['refreshToken'];
    firstname = json['firstname'];
    lastname = json['lastname'];
    active = json['active'];
    activationToken = json['activationToken'];
    resetPasswordToken = json['resetPasswordToken'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['password'] = this.password;
    data['email'] = this.email;
    data['refreshToken'] = this.refreshToken;
    data['firstname'] = this.firstname;
    data['lastname'] = this.lastname;
    data['active'] = this.active;
    data['activationToken'] = this.activationToken;
    data['resetPasswordToken'] = this.resetPasswordToken;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}
