class Campaign {
  int? id;
  String? name;
  Null? code;
  Null? picture;
  String? description;
  String? notes;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  Null? deletedAt;

  Campaign(
      {this.id,
      this.name,
      this.code,
      this.picture,
      this.description,
      this.notes,
      this.isActive,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Campaign.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    code = json['code'];
    picture = json['picture'];
    description = json['description'];
    notes = json['notes'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    deletedAt = json['deletedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['code'] = this.code;
    data['picture'] = this.picture;
    data['description'] = this.description;
    data['notes'] = this.notes;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['deletedAt'] = this.deletedAt;
    return data;
  }
}
