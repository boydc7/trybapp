class Enums {
  static String toEnumName(String enumToString) {
    var parts = enumToString.split('.');

    return parts[parts.length - 1];
  }
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  EnumValues.fromValues(List<T> enumValues) {
    map = Map.fromIterable(
      enumValues,
      key: (i) => Enums.toEnumName(i.toString()),
      value: (i) => i,
    );
  }

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => MapEntry(v, k));
    }
    return reverseMap;
  }
}
