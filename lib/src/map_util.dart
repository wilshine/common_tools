class MapUtil {
  static List<T> getValuesByKeys<T>(Map<String, T> map, List<String> keys) {
    List<T> values = [];
    for (int i = 0; i < keys.length; i++) {
      values.add(map[keys[i]] as T);
    }
    return values;
  }

  static void remove(Map<String, dynamic> map, bool Function(String k, dynamic v) test) {
    List<String> toBeRemoveKeys = [];
    map.forEach((key, value) {
      if (test(key, value)) {
        toBeRemoveKeys.add(key);
      }
    });
    for (var key in toBeRemoveKeys) {
      map.remove(key);
    }
  }

  static void removeNullOrZeroOrEmptyElement(Map<String, dynamic> map) {
    List<String> toBeRemoveKeys = [];
    map.forEach((key, value) {
      bool isRemove = false;
      if (value == null) {
        isRemove = true;
      } else if (value is int) {
        if (value == 0) {
          isRemove = true;
        }
      } else if (value is double) {
        if (value == 0.0) {
          isRemove = true;
        }
      } else if (value is String) {
        if (value.isEmpty) {
          isRemove = true;
        }
      } else if (value is List) {
        if (value.isEmpty) {
          isRemove = true;
        } else {
          List<int> elementRemoveIndexes = [];
          for (int i = 0; i < value.length; i++) {
            var e = value[i];
            if (e == null) {
              elementRemoveIndexes.add(i);
            }
          }
          for (var index in elementRemoveIndexes) {
            value.removeAt(index);
          }
        }
      }
      if (isRemove) {
        toBeRemoveKeys.add(key);
      }
    });
    for (var key in toBeRemoveKeys) {
      map.remove(key);
    }
  }
}
