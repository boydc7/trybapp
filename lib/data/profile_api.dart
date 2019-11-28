import 'package:trybapp/models/tryb_profile.dart';

import 'base_api.dart';

class ProfileApi extends BaseApi {
  static final ProfileApi _instance = ProfileApi();

  static ProfileApi get instance => _instance;

  Future<List<TrybProfile>> getMyProfiles() async {
    var profilesSnapshot = await query('profiles').getDocuments();

    var results = getQueryResults<TrybProfile>(
      profilesSnapshot,
      (m) => TrybProfile.fromJson(m),
    );

    return results;
  }
}
