import 'package:trybapp/enums/account_type.dart';
import 'package:trybapp/models/base_model.dart';

class TrybAccount extends BaseModel {
  String id;
  String defaultProfileId;
  String name;
  String authProvider;
  String authProviderToken;
  AccountType accountType;
  String email;
  String avatar;
  String phoneNumber;
  bool isEmailVerified;

  TrybAccount({
    this.id,
    this.defaultProfileId,
    this.name,
    this.authProvider,
    this.authProviderToken,
    this.accountType,
    this.email,
    this.avatar,
    this.phoneNumber,
    this.isEmailVerified,
  }) : super();

  TrybAccount.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = json['id'];
    defaultProfileId = json['defaultProfileId'];
    name = json['name'];
    authProvider = json['authProvider'];
    authProviderToken = json['authProviderToken'];
    accountType = accountTypeValues.map[json['accountType']];
    email = json['email'];
    avatar = json['avatar'];
    phoneNumber = json['phoneNumber'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'id': id,
      'defaultProfileId': defaultProfileId,
      'name': name,
      'authProvider': authProvider,
      'authProviderToken': authProviderToken,
      'accountType': accountTypeValues.reverseMap[accountType],
      'email': email,
      'avatar': avatar,
      'phoneNumber': phoneNumber,
      'isEmailVerified': isEmailVerified
    });
}
