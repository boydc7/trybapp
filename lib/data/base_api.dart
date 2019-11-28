import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trybapp/services/auth_service.dart';

abstract class BaseApi {
  final Firestore db = Firestore.instance;

  BaseApi() {
    db.settings(
      persistenceEnabled: true,
      sslEnabled: true,
      cacheSizeBytes: 250 * 1000 * 1000, // 250mb
    );
  }

  Iterable<T> getQueryResults<T>(
    QuerySnapshot snapshot,
    Function resultMap,
  ) {
    if (snapshot == null || snapshot.documents == null) {
      return [];
    }

    return snapshot.documents.map((q) => resultMap(tryGetMapResult(q)));
  }

  Map<String, dynamic> tryGetMapResult(DocumentSnapshot snapshot) {
    if (snapshot == null || !snapshot.exists || snapshot.data == null || snapshot.data.isEmpty) {
      throw ('You do not have access to the resource requested, or it does not exist - code [baigot-${snapshot.documentID ?? '0uk0'}]');
    }

    return snapshot.data;
  }

  Query query(String collection) {
    return db
        .collection(collection)
        .where(
          'deletedOn',
          isEqualTo: 0,
        )
        .where(
          'trybAccountId',
          isEqualTo: AuthService.instance.currentAccountId,
        );
  }
}
