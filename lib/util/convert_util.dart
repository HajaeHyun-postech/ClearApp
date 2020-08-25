class ConvertUtil {
  static List<T> jsonArrayToObjectList<T>(
      List<dynamic> jsonArray, Function fromJson) {
    List<T> result = new List<T>();
    jsonArray.forEach((element) {
      result.add(fromJson(element));
    });
    return result;
  }
}
