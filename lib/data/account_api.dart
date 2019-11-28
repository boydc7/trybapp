import 'package:trybapp/models/tryb_account.dart';
import 'package:trybapp/services/auth_service.dart';

import 'base_api.dart';

class AccountApi extends BaseApi {
  static final AccountApi _instance = AccountApi();

  static AccountApi get instance => _instance;

  Future<TrybAccount> connectAccount(TrybAccount account) async {
    await db.collection('accounts').document(account.id).setData(account.toJson());

    return account;
  }

  Future<TrybAccount> getMyAccount() async {
    var accountSnapshot = await db.collection('accounts').document(AuthService.instance.currentAccount.id).get();

    var account = TrybAccount.fromJson(tryGetMapResult(accountSnapshot));

    return account;
  }
}
