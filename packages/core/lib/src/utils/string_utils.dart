extension StringExt on String {
  String toUpperCaseFirstLetter() {
    return '${substring(0, 1).toUpperCase()}${substring(1)}';
  }

  String toUpperCaseAllWords() {
    return split(' ').map((e) => e.toUpperCaseFirstLetter()).join(' ');
  }
}
