class User {
  int? id;
  String? username;
  String? password;
  String? email;
  String? refreshToken;
  String? firstname;
  String? lastname;
  bool? active;
  String? activationToken;
  String? resetPasswordToken;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['refreshToken'] = refreshToken;
    data['firstname'] = firstname;
    data['lastname'] = lastname;
    data['active'] = active;
    data['activationToken'] = activationToken;
    data['resetPasswordToken'] = resetPasswordToken;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    return data;
  }
}
