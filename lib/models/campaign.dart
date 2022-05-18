class Campaign {
  int? id;
  String? name;
  String? code;
  String? picture;
  String? description;
  String? notes;
  bool? isActive;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

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
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['code'] = code;
    data['picture'] = picture;
    data['description'] = description;
    data['notes'] = notes;
    data['isActive'] = isActive;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['deletedAt'] = deletedAt;
    return data;
  }

  Campaign copy() => Campaign(
        id: id,
        name: name,
        picture: picture,
        description: description,
        notes: notes,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
