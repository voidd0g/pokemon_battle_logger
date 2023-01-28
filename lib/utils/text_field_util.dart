class TextFieldUtil {
  static String? limitLength({required String? source, required int maxLength}) {
    if (source != null && source.length > maxLength) {
      return source.substring(0, maxLength);
    } else {
      return source;
    }
  }
}
