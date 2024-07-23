


class ListUtil {
  static bool isElementsEquals(List listX, List listY) {
    if (listX.length != listY.length) {
      return false;
    }
    for (var element in listX) {
      if (!listY.contains(element)) {
        return false;
      }
    }
    return true;
  }
}
