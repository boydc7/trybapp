import 'package:trybapp/utils/enum_utils.dart';

enum ProfileType {
  unknown,
  account,
  consumer,
  serviceProvider,
}

final profileTypeValues = EnumValues.fromValues(ProfileType.values);
