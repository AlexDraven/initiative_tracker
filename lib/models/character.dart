// To parse this JSON data, do
//
//     final character = characterFromMap(jsonString);
// https://app.quicktype.io/

import 'dart:convert';

class Character {
  Character(
      {required this.rolClass,
      required this.level,
      required this.name,
      this.picture,
      required this.playerId,
      required this.race,
      this.id,
      required this.active});

  String rolClass;
  int level;
  String name;
  String? picture;
  String playerId;
  String race;
  String? id;
  bool active;

  factory Character.fromJson(String str) => Character.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Character.fromMap(Map<String, dynamic> json) => Character(
        rolClass: json["rolClass"],
        level: json["level"],
        name: json["name"],
        picture: json["picture"],
        playerId: json["playerId"],
        race: json["race"],
        active: json["active"],
      );

  Map<String, dynamic> toMap() => {
        "rolClass": rolClass,
        "level": level,
        "name": name,
        "picture": picture,
        "playerId": playerId,
        "race": race,
        "active": active
      };

  Character copy() => Character(
      rolClass: rolClass,
      level: level,
      name: name,
      picture: picture,
      playerId: playerId,
      race: race,
      id: id,
      active: active);
}
