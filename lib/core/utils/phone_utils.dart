/// Phone number normalization and validation utilities.
///
/// Rules:
/// - Strip spaces, dashes, and parentheses.
/// - If the number already starts with `+`, leave it alone.
/// - Otherwise strip a leading `0`, then prepend [countryCode].
/// - Validation: `+` followed by 7–15 digits (E.164-ish).
abstract final class PhoneUtils {
  static final _stripChars = RegExp(r'[\s\-\(\)]');
  static final _validPhone = RegExp(r'^\+\d{7,15}$');

  /// Normalizes a raw phone string using [countryCode].
  ///
  /// Returns `null` if the input is empty after stripping.
  /// Example: `normalizePhone('01012345678', '+20')` → `'+201012345678'`
  static String? normalizePhone(String raw, String countryCode) {
    var cleaned = raw.replaceAll(_stripChars, '');
    if (cleaned.isEmpty) return null;

    if (!cleaned.startsWith('+')) {
      // Strip leading 0 before prepending country code
      if (cleaned.startsWith('0')) {
        cleaned = cleaned.substring(1);
      }
      cleaned = '$countryCode$cleaned';
    }
    return cleaned;
  }

  /// Returns `true` if [phone] looks like a valid E.164-ish number.
  ///
  /// Expects `+` followed by 7–15 digits.
  static bool isValidPhone(String phone) {
    return _validPhone.hasMatch(phone);
  }
}
