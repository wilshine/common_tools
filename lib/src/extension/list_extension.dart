extension ListExt<T> on List<T> {
  /// 返回第一个元素，如果是空则返回null
  T? get firstSafe => elementSafeAt(0);

  /// 返回最后一个元素，如果是空则返回null
  T? get lastSafe => elementSafeAt(length - 1);

  /// 返回下标元素，如果不存在则返回空
  T? elementSafeAt(int index) {
    if (index < 0) {
      return null;
    }
    if (index >= length) {
      return null;
    }
    if (isEmpty) {
      return null;
    }
    return elementAt(index);
  }

  /// 判断两个List是否一样
  bool isElementsEquals(List list) {
    if (length != list.length) {
      return false;
    }
    for (T element in this) {
      if (!list.contains(element)) {
        return false;
      }
    }
    return true;
  }

  /// 获取列表中某个元素，没有就返回orElse，否则返回null
  T? firstWhereOrElse(bool Function(T element) test, {T Function()? orElse}) {
    for (var element in this) {
      if (test(element)) return element;
    }
    if (orElse != null) return orElse();
    return null;
  }

  /// 返回列表某个下标的元素，没有就返回orElse，否则返回null
  T? elementAtOrElse(int index, {T Function()? orElse}) {
    int elementIndex = 0;
    for (T element in this) {
      if (index == elementIndex) return element;
      elementIndex++;
    }
    if (orElse != null) return orElse();
    return null;
  }
}
