// https://app.quicktype.io/

// To parse this JSON data, do
//
//     final character = characterFromJson(jsonString);

import 'dart:convert';

class Character {
  Character({
    this.id,
    required this.name,
    required this.rolClass,
    required this.race,
    required this.level,
    this.picture,
    required this.description,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String name;
  String rolClass;
  String race;
  int level;
  String? picture;
  String description;
  bool isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Character.fromRawJson(String str) =>
      Character.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Character.fromJson(Map<String, dynamic> json) => Character(
        id: json["id"],
        name: json["name"],
        rolClass: json["rolClass"],
        race: json["race"],
        level: json["level"],
        picture: json["picture"],
        description: json["description"],
        isActive: json["isActive"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "rolClass": rolClass,
        "race": race,
        "level": level,
        "picture": picture,
        "description": description,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };

  Character copy() => Character(
        id: id,
        name: name,
        rolClass: rolClass,
        race: race,
        level: level,
        picture: picture,
        description: description,
        isActive: isActive,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}
