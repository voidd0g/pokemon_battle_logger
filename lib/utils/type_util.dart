class TypeUtil {
  static String? typeToString(int type) {
    switch (type) {
      case 1:
        return 'ノーマル';
      case 2:
        return 'ほのお';
      case 3:
        return 'みず';
      case 4:
        return 'くさ';
      case 5:
        return 'でんき';
      case 6:
        return 'こおり';
      case 7:
        return 'かくとう';
      case 8:
        return 'どく';
      case 9:
        return 'じめん';
      case 10:
        return 'ひこう';
      case 11:
        return 'エスパー';
      case 12:
        return 'むし';
      case 13:
        return 'いわ';
      case 14:
        return 'ゴースト';
      case 15:
        return 'ドラゴン';
      case 16:
        return 'あく';
      case 17:
        return 'はがね';
      case 18:
        return 'フェアリー';
      default:
        return null;
    }
  }
}
