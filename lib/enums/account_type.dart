import 'package:trybapp/utils/enum_utils.dart';

enum AccountType {
  unknown,
  user,
  admin,
}

final accountTypeValues = EnumValues.fromValues(AccountType.values);
