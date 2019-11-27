import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseApi {
  final Firestore db = Firestore.instance;

  BaseApi() {
    db.settings(
      persistenceEnabled: true,
      sslEnabled: true,
      cacheSizeBytes: 250 * 1000 * 1000, // 250mb
    );
  }
}
