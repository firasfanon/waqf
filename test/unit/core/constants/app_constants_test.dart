import 'package:flutter_test/flutter_test.dart';
import 'package:palestinian_ministry_endowments/core/constants/app_constants.dart';

void main() {
  group('AppConstants', () {
    group('App Information', () {
      test('should have correct app name in Arabic', () {
        expect(AppConstants.appName, 'وزارة الأوقاف والشؤون الدينية');
      });

      test('should have correct app name in English', () {
        expect(AppConstants.appNameEn, 'Palestinian Ministry of Endowments');
      });

      test('should have valid app version', () {
        expect(AppConstants.appVersion, isNotEmpty);
        expect(AppConstants.appVersion, matches(RegExp(r'^\d+\.\d+\.\d+')));
      });
    });

    group('Spacing Constants', () {
      test('should have ascending padding values', () {
        expect(AppConstants.paddingXS, lessThan(AppConstants.paddingS));
        expect(AppConstants.paddingS, lessThan(AppConstants.paddingM));
        expect(AppConstants.paddingM, lessThan(AppConstants.paddingL));
        expect(AppConstants.paddingL, lessThan(AppConstants.paddingXL));
        expect(AppConstants.paddingXL, lessThan(AppConstants.paddingXXL));
      });

      test('should have ascending radius values', () {
        expect(AppConstants.radiusXS, lessThan(AppConstants.radiusS));
        expect(AppConstants.radiusS, lessThan(AppConstants.radiusM));
        expect(AppConstants.radiusM, lessThan(AppConstants.radiusL));
        expect(AppConstants.radiusL, lessThan(AppConstants.radiusXL));
        expect(AppConstants.radiusXL, lessThan(AppConstants.radiusXXL));
      });
    });

    group('Animation Durations', () {
      test('should have ascending animation durations', () {
        expect(
          AppConstants.animationFast.inMilliseconds,
          lessThan(AppConstants.animationNormal.inMilliseconds),
        );
        expect(
          AppConstants.animationNormal.inMilliseconds,
          lessThan(AppConstants.animationSlow.inMilliseconds),
        );
      });
    });

    group('Palestinian Governorates', () {
      test('should have 16 governorates', () {
        expect(AppConstants.governorates.length, 16);
      });

      test('should include major cities', () {
        expect(AppConstants.governorates, contains('القدس'));
        expect(AppConstants.governorates, contains('رام الله والبيرة'));
        expect(AppConstants.governorates, contains('غزة'));
        expect(AppConstants.governorates, contains('الخليل'));
      });

      test('should not have duplicate governorates', () {
        final uniqueGovernorates = AppConstants.governorates.toSet();
        expect(uniqueGovernorates.length, AppConstants.governorates.length);
      });
    });

    group('Contact Information', () {
      test('should have valid phone number format', () {
        expect(AppConstants.phoneNumber, isNotEmpty);
        expect(AppConstants.phoneNumber, contains('+970'));
      });

      test('should have valid email format', () {
        expect(AppConstants.email, isNotEmpty);
        expect(AppConstants.email, contains('@'));
        expect(AppConstants.email, contains('awqaf.ps'));
      });

      test('should have valid website URL', () {
        expect(AppConstants.website, isNotEmpty);
        expect(AppConstants.website, startsWith('https://'));
        expect(AppConstants.website, contains('awqaf.ps'));
      });
    });

    group('Regular Expressions', () {
      test('email regex should validate correct emails', () {
        expect(AppConstants.emailRegex.hasMatch('test@example.com'), isTrue);
        expect(AppConstants.emailRegex.hasMatch('user.name@domain.co'), isTrue);
        expect(AppConstants.emailRegex.hasMatch('invalid-email'), isFalse);
        expect(AppConstants.emailRegex.hasMatch('@domain.com'), isFalse);
      });

      test('phone regex should validate Palestinian numbers', () {
        expect(AppConstants.phoneRegex.hasMatch('0599123456'), isTrue);
        expect(AppConstants.phoneRegex.hasMatch('+970599123456'), isTrue);
        expect(AppConstants.phoneRegex.hasMatch('970599123456'), isTrue);
        expect(AppConstants.phoneRegex.hasMatch('123'), isFalse);
      });

      test('Arabic regex should detect Arabic characters', () {
        expect(AppConstants.arabicRegex.hasMatch('مرحبا'), isTrue);
        expect(AppConstants.arabicRegex.hasMatch('Hello'), isFalse);
        expect(AppConstants.arabicRegex.hasMatch('Hello مرحبا'), isTrue);
      });
    });

    group('Service Categories', () {
      test('should have at least 5 service categories', () {
        expect(AppConstants.serviceCategories.length, greaterThanOrEqualTo(5));
      });

      test('should include mosque services', () {
        expect(
          AppConstants.serviceCategories,
          anyOf(contains('خدمات المساجد'), contains('مساجد')),
        );
      });
    });

    group('File Configuration', () {
      test('should have reasonable file size limits', () {
        expect(AppConstants.maxFileSize, greaterThan(0));
        expect(AppConstants.maxFileSize, lessThanOrEqualTo(100 * 1024 * 1024)); // Max 100MB
      });

      test('should support common image formats', () {
        expect(AppConstants.supportedImageFormats, contains('jpg'));
        expect(AppConstants.supportedImageFormats, contains('jpeg'));
        expect(AppConstants.supportedImageFormats, contains('png'));
      });

      test('should support common document formats', () {
        expect(AppConstants.supportedDocumentFormats, contains('pdf'));
        expect(AppConstants.supportedDocumentFormats, contains('doc'));
        expect(AppConstants.supportedDocumentFormats, contains('docx'));
      });
    });

    group('Islamic Calendar', () {
      test('should have 12 Islamic months', () {
        expect(AppConstants.islamicMonths.length, 12);
      });

      test('should include Ramadan', () {
        expect(AppConstants.islamicMonths, contains('رمضان'));
      });

      test('should include Dhul Hijjah', () {
        expect(AppConstants.islamicMonths, contains('ذو الحجة'));
      });
    });

    group('Security Configuration', () {
      test('should have reasonable session timeout', () {
        expect(AppConstants.sessionTimeoutMinutes, greaterThan(0));
        expect(AppConstants.sessionTimeoutMinutes, lessThanOrEqualTo(120));
      });

      test('should have reasonable max login attempts', () {
        expect(AppConstants.maxLoginAttempts, greaterThanOrEqualTo(3));
        expect(AppConstants.maxLoginAttempts, lessThanOrEqualTo(10));
      });

      test('should have reasonable lockout duration', () {
        expect(AppConstants.lockoutDurationMinutes, greaterThan(0));
        expect(AppConstants.lockoutDurationMinutes, lessThanOrEqualTo(60));
      });
    });

    group('Map Configuration', () {
      test('should have valid default coordinates for Palestine', () {
        // Palestine is approximately at 31.9°N, 35.2°E
        expect(AppConstants.defaultLatitude, greaterThan(31.0));
        expect(AppConstants.defaultLatitude, lessThan(33.0));
        expect(AppConstants.defaultLongitude, greaterThan(34.0));
        expect(AppConstants.defaultLongitude, lessThan(36.0));
      });

      test('should have reasonable default zoom level', () {
        expect(AppConstants.defaultZoom, greaterThan(0));
        expect(AppConstants.defaultZoom, lessThanOrEqualTo(20));
      });
    });
  });

  group('AppColors', () {
    test('should have Islamic green as primary color', () {
      expect(AppColors.islamicGreen.toARGB32(), equals(0xFF22C55E));
    });

    test('should have contrasting text colors', () {
      expect(AppColors.textPrimary, isNot(equals(AppColors.textSecondary)));
      expect(AppColors.textPrimary, isNot(equals(AppColors.textDisabled)));
    });

    test('should have distinct status colors', () {
      expect(AppColors.success, isNot(equals(AppColors.error)));
      expect(AppColors.warning, isNot(equals(AppColors.info)));
    });
  });

  group('AppDimensions', () {
    test('should have ascending breakpoints', () {
      expect(
        AppDimensions.mobileBreakpoint,
        lessThan(AppDimensions.tabletBreakpoint),
      );
      expect(
        AppDimensions.tabletBreakpoint,
        lessThan(AppDimensions.desktopBreakpoint),
      );
    });

    test('should have reasonable component heights', () {
      expect(AppDimensions.appBarHeight, greaterThan(40));
      expect(AppDimensions.appBarHeight, lessThan(100));
      expect(AppDimensions.buttonHeight, greaterThan(30));
      expect(AppDimensions.buttonHeight, lessThan(80));
    });

    test('should have ascending icon sizes', () {
      expect(AppDimensions.iconXS, lessThan(AppDimensions.iconS));
      expect(AppDimensions.iconS, lessThan(AppDimensions.iconM));
      expect(AppDimensions.iconM, lessThan(AppDimensions.iconL));
    });
  });
}
