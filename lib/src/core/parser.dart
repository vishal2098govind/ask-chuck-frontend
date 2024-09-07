T parseValueType<T>(
  Object? value, {
  required T defaultValue,
}) {
  switch (value) {
    case T():
      return value;
    default:
      return defaultValue;
  }
}

List<T> parseList<T>(
  Object? value, {
  required T Function(Object? e) parseItem,
}) {
  switch (value) {
    case List():
      final List<T> l = [];
      for (var e in value) {
        l.add(parseItem(e));
      }
      return l;
  }

  return <T>[];
}
