class TextUtil {
  static bool isNullOrEmpty(String text) {
    if (text is String) {
      return text == null || text.isEmpty;
    } else {
      return true;
    }
  }

  static String jointUnit(String text, String unit) {
    if (text == null || text.length == 0) {
      return '';
    }

    if (text.length < unit.length) {
      return text + unit;
    }

    String tmp = text.substring(text.length - unit.length);
    if (tmp == unit) {
      return text;
    }

    return text + unit;
  }

  static String formatNumber(double value) {
    if (value == null) {
      return '0';
    }
    return value.toStringAsFixed(value.truncateToDouble() == value ? 0 : 1);
  }
}
