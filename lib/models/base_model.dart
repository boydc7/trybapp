import 'package:flutter/foundation.dart';

abstract class BaseModel {
  String createdBy;
  String modifiedBy;
  String deletedBy;
  DateTime createdOn;
  DateTime modifiedOn;
  DateTime deletedOn;

  @mustCallSuper
  BaseModel() {

  }

  @mustCallSuper
  BaseModel.fromJson(Map<String, dynamic> json) {
    createdBy = json['createdBy'];
    modifiedBy = json['modifiedBy'];
    deletedBy = json['deletedBy'];
    createdOn = json['createdOn'];
    createdOn = json['modifiedOn'];
    deletedOn = json['deletedOn'];

  }

  @mustCallSuper
  Map<String, dynamic> toJson() =>
      
}
