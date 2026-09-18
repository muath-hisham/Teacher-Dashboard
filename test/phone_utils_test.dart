import 'package:flutter_test/flutter_test.dart';
import 'package:teacher_dashboard/core/utils/phone_utils.dart';

void main() {
  group('PhoneUtils.normalizePhone', () {
    test('strips leading 0 and prepends country code', () {
      expect(
        PhoneUtils.normalizePhone('01012345678', '+20'),
        '+201012345678',
      );
    });

    test('does not double-strip when no leading 0', () {
      expect(
        PhoneUtils.normalizePhone('1012345678', '+20'),
        '+201012345678',
      );
    });

    test('leaves number starting with + alone', () {
      expect(
        PhoneUtils.normalizePhone('+201012345678', '+20'),
        '+201012345678',
      );
    });

    test('strips spaces, dashes, and parentheses', () {
      expect(
        PhoneUtils.normalizePhone('(010) 123-456 78', '+20'),
        '+201012345678',
      );
    });

    test('returns null for empty input', () {
      expect(PhoneUtils.normalizePhone('', '+20'), isNull);
    });

    test('returns null for whitespace-only input', () {
      expect(PhoneUtils.normalizePhone('   ', '+20'), isNull);
    });

    test('handles different country code', () {
      expect(
        PhoneUtils.normalizePhone('0501234567', '+966'),
        '+966501234567',
      );
    });

    test('handles number with + and different country', () {
      expect(
        PhoneUtils.normalizePhone('+966501234567', '+20'),
        '+966501234567',
      );
    });
  });

  group('PhoneUtils.isValidPhone', () {
    test('valid E.164 number', () {
      expect(PhoneUtils.isValidPhone('+201012345678'), isTrue);
    });

    test('valid short number (7 digits)', () {
      expect(PhoneUtils.isValidPhone('+201234'), isFalse); // 6 digits
      expect(PhoneUtils.isValidPhone('+2012345'), isTrue); // 7 digits
    });

    test('rejects number without +', () {
      expect(PhoneUtils.isValidPhone('201012345678'), isFalse);
    });

    test('rejects number with letters', () {
      expect(PhoneUtils.isValidPhone('+20abc12345'), isFalse);
    });

    test('rejects too-short number', () {
      expect(PhoneUtils.isValidPhone('+12345'), isFalse); // 5 digits
    });

    test('accepts max length (15 digits)', () {
      expect(PhoneUtils.isValidPhone('+123456789012345'), isTrue);
    });

    test('rejects over 15 digits', () {
      expect(PhoneUtils.isValidPhone('+1234567890123456'), isFalse);
    });
  });
}
