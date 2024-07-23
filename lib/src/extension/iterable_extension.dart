extension IterableExt<E> on Iterable<E> {

  E? firstIf(bool Function(E e) test, {E Function()? orElse}) {
    for (E element in this) {
      if (test(element)) {
        return element;
      }
    }
    if (orElse != null) {
      return orElse();
    }
    return null;
  }

}