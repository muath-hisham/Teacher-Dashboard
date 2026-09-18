/// App-wide constants.
abstract final class AppConstants {
  /// Maximum allowed length for class / student names.
  static const maxNameLength = 100;

  /// Maximum allowed length for note body text.
  static const maxNoteLength = 2000;

  /// Maximum allowed length for session links.
  static const maxLinkLength = 500;

  /// Maximum allowed length for phone numbers.
  static const maxPhoneLength = 20;

  /// Default country calling code (user-configurable via Settings).
  static const defaultCountryCode = '+20';
}
