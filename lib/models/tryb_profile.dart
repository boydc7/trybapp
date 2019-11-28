import 'package:trybapp/enums/account_type.dart';
import 'package:trybapp/enums/profile_type.dart';
import 'package:trybapp/models/base_model.dart';

class TrybProfile extends BaseModel {
  String id;
  String name;
  ProfileType profileType;
  String email;
  String avatar;
  bool isDefault;

  TrybProfile({
    this.id,
    this.name,
    this.profileType,
    this.email,
    this.avatar,
    this.isDefault,
  }) : super();

  TrybProfile.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = json['id'];
    name = json['name'];
    profileType = profileTypeValues.map[json['profileType']];
    email = json['email'];
    avatar = json['avatar'];
    isDefault = json['isDefault'];
  }

  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'id': id,
      'name': name,
      'accountType': accountTypeValues.reverseMap[profileType],
      'email': email,
      'avatar': avatar,
      'isDefault': isDefault,
    });
}
