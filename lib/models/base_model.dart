import 'package:flutter/foundation.dart';
import 'package:trybapp/services/auth_service.dart';

abstract class BaseModel {
  String createdBy;
  String modifiedBy;
  String deletedBy;
  int createdOn;
  int modifiedOn;
  int deletedOn;
  String trybAccountId;

  @mustCallSuper
  BaseModel() {
    var currentUid = AuthService.instance.currentAccountId;

    createdBy = currentUid;
    modifiedBy = createdBy;
    createdOn = DateTime.now().millisecondsSinceEpoch;
    modifiedOn = createdOn;
    deletedOn = 0;
    trybAccountId = currentUid;
  }

  @mustCallSuper
  BaseModel.fromJson(Map<String, dynamic> json) {
    var currentUid = AuthService.instance.currentAccountId;

    createdBy = json['createdBy'] ?? currentUid;
    modifiedBy = json['modifiedBy'] ?? currentUid;
    deletedBy = json['deletedBy'];
    createdOn = json['createdOn'] ?? DateTime.now().millisecondsSinceEpoch;
    createdOn = json['modifiedOn'] ?? DateTime.now().millisecondsSinceEpoch;
    deletedOn = json['deletedOn'] ?? 0;
    trybAccountId = json['trybAccountId'] ?? currentUid;
  }

  @mustCallSuper
  Map<String, dynamic> toJson() {
    var currentUid = AuthService.instance.currentAccountId;

    return {
      'createdBy': createdBy,
      'modifiedBy': currentUid ?? modifiedBy ?? createdBy,
      'deletedBy': deletedBy ?? (deletedOn > 0 ? currentUid ?? modifiedBy ?? createdBy : null),
      'createdOn': createdOn ?? DateTime.now().millisecondsSinceEpoch,
      'modifiedOn': DateTime.now().millisecondsSinceEpoch,
      'deletedOn': deletedOn ?? 0,
      'trybAccountId': currentUid,
    };
  }
}
