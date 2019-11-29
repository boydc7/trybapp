import 'package:trybapp/models/base_model.dart';

class ServiceCategory extends BaseModel {
  String id;
  String name;
  String imageUrl;

  ServiceCategory({
    this.id,
    this.name,
    this.imageUrl,
  }) : super();

  ServiceCategory.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = json['id'];
    name = json['name'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() => super.toJson()
    ..addAll({
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
    });
}
