extension ListExt<T> on List<T> {
  T? safeGetAt(int index) {
    if (index < 0 || index > length - 1) {
      return null;
    }

    return this[index];
  }
}
