class TrybAccount {
  int id;
  int defaultProfileId;
  String name;
  String authId;
  AccountType accountType;
  String email;
  String avatar;
  String phoneNumber;
  bool isEmailVerified;

  TrybAccount({
    this.id,
    this.defaultProfileId,
    this.name,
    this.authId,
    this.accountType,
    this.email,
    this.avatar,
    this.phoneNumber,
    this.isEmailVerified,
  }) {}

  TrybAccount.fromJson(Map<String, dynamic> json) {
    fromMap(json);
  }

  fromMap(Map<String, dynamic> json) {
    super.fromMap(json);
    id = json['id'];
    defaultProfileId = json['defaultProfileId'];
    name = json['name'];
    authId = json['authId'];
    accountType = JsonConverters.fromJson(json['accountType'], 'AccountType', context);
    email = json['email'];
    avatar = json['avatar'];
    phoneNumber = json['phoneNumber'];
    isEmailVerified = json['isEmailVerified'];
    return this;
  }

  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'id': id,
      'defaultProfileId': defaultProfileId,
      'name': name,
      'authId': authId,
      'accountType': JsonConverters.toJson(accountType, 'AccountType', context),
      'email': email,
      'avatar': avatar,
      'phoneNumber': phoneNumber,
      'isEmailVerified': isEmailVerified
    });
}
