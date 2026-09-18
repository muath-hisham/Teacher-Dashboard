/// Arabic text normalization for search matching.
///
/// Unifies common Arabic letter variants so that a search for "احمد"
/// also matches "أحمد" or "إحمد", etc.
///
/// Operations:
/// - Remove diacritics (tashkeel): ً ٌ ٍ َ ُ ِ ّ ْ
/// - Remove tatweel (kashida): ـ
/// - Unify hamza forms: أ إ آ → ا
/// - Unify taa marbuta / haa: ة → ه
/// - Unify alef maqsura / yaa: ى → ي
abstract final class ArabicNormalizer {
  /// Arabic diacritics (Unicode range 0x064B–0x065F, plus 0x0670).
  static final _diacritics = RegExp(
    '[\u064B-\u065F\u0670]',
  );

  /// Tatweel / kashida character.
  static const _tatweel = '\u0640';

  /// Normalizes [text] for fuzzy Arabic search comparison.
  ///
  /// The result is lowercase and stripped of diacritics, tatweel,
  /// with unified letter forms.
  static String normalize(String text) {
    var result = text.toLowerCase();

    // Strip diacritics
    result = result.replaceAll(_diacritics, '');

    // Strip tatweel
    result = result.replaceAll(_tatweel, '');

    // Unify hamza-bearing alefs → plain alef
    result = result
        .replaceAll('\u0623', '\u0627') // أ → ا
        .replaceAll('\u0625', '\u0627') // إ → ا
        .replaceAll('\u0622', '\u0627'); // آ → ا

    // Unify taa marbuta → haa
    result = result.replaceAll('\u0629', '\u0647'); // ة → ه

    // Unify alef maqsura → yaa
    result = result.replaceAll('\u0649', '\u064A'); // ى → ي

    return result;
  }

  /// Returns `true` if [text] contains [query] after normalizing both.
  static bool containsNormalized(String text, String query) {
    return normalize(text).contains(normalize(query));
  }
}
