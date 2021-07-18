class APIPath {
  static String wod(String uid, String wodId) => 'users/$uid/wods/$wodId';
  static String wods(String uid) => 'users/$uid/wods';
  static String entry(String uid, String entryId) =>
      'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';
}
