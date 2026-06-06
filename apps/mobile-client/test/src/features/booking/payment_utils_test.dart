import 'package:flutter_test/flutter_test.dart';
import 'package:beauteavenue_mobile_client/src/features/booking/payment_utils.dart';

void main() {
  group('channelFromMethodLabel', () {
    test('returns orange_senegal for Orange Money Senegal', () {
      expect(channelFromMethodLabel('Orange Money Sénégal'), 'orange_senegal');
    });

    test('is case-insensitive with accented chars', () {
      expect(channelFromMethodLabel('ORANGE MONEY SÉNÉGAL'), 'orange_senegal');
    });

    test('returns wave_senegal for Wave', () {
      expect(channelFromMethodLabel('Wave Sénégal'), 'wave_senegal');
    });

    test('returns wave_ci for Wave Cote', () {
      expect(channelFromMethodLabel('Wave Côte d\'Ivoire'), 'wave_ci');
    });

    test('returns djamo for Djamo', () {
      expect(channelFromMethodLabel('Djamo'), 'djamo');
    });

    test('returns paydunya_wallet for Portefeuille PayDunya', () {
      expect(channelFromMethodLabel('Portefeuille PayDunya'), 'paydunya_wallet');
    });

    test('returns wizall_senegal for Wizall', () {
      expect(channelFromMethodLabel('Wizall Sénégal'), 'wizall_senegal');
    });

    test('returns om_ci for Orange Money Cote', () {
      expect(channelFromMethodLabel('Orange Money Côte d\'Ivoire'), 'om_ci');
    });

    test('returns om_bf for Orange Money Burkina', () {
      expect(channelFromMethodLabel('Orange Money Burkina Faso'), 'om_bf');
    });

    test('returns om_ml for Orange Money Mali', () {
      expect(channelFromMethodLabel('Orange Money Mali'), 'om_ml');
    });

    test('returns mtn_ci for MTN Money Cote', () {
      expect(channelFromMethodLabel('MTN Money Côte d\'Ivoire'), 'mtn_ci');
    });

    test('returns mtn_bj for MTN Benin', () {
      expect(channelFromMethodLabel('MTN Bénin'), 'mtn_bj');
    });

    test('returns mtn_cm for MTN Cameroun', () {
      expect(channelFromMethodLabel('MTN Cameroun'), 'mtn_cm');
    });

    test('returns moov_ci for Moov Cote', () {
      expect(channelFromMethodLabel('Moov Côte d\'Ivoire'), 'moov_ci');
    });

    test('returns moov_bf for Moov Burkina', () {
      expect(channelFromMethodLabel('Moov Burkina'), 'moov_bf');
    });

    test('returns moov_bj for Moov Benin', () {
      expect(channelFromMethodLabel('Moov Bénin'), 'moov_bj');
    });

    test('returns moov_tg for Moov Togo', () {
      expect(channelFromMethodLabel('Moov Togo'), 'moov_tg');
    });

    test('returns moov_ml for Moov Mali', () {
      expect(channelFromMethodLabel('Moov Mali'), 'moov_ml');
    });

    test('returns t_money_tg for T-Money Togo', () {
      expect(channelFromMethodLabel('T-Money Togo'), 't_money_tg');
    });

    test('returns carte_bancaire for Carte Bancaire', () {
      expect(channelFromMethodLabel('Carte Bancaire'), 'carte_bancaire');
    });

    test('returns empty string for unknown label', () {
      expect(channelFromMethodLabel('Unknown Payment Method'), '');
    });

    test('matches wave_senegal before wave_ci for Wave Senegal', () {
      // 'Wave Sénégal' contains 'wave' but not 'wave côte', so returns 'wave_senegal'
      expect(channelFromMethodLabel('Wave Sénégal'), 'wave_senegal');
    });

    test('matches wave_ci for Wave Cote', () {
      // 'Wave Côte' contains 'wave côte', so returns 'wave_ci'
      expect(channelFromMethodLabel('Wave Côte du Nord'), 'wave_ci');
    });
  });

  group('inferDjamoCountryCode', () {
    test('returns CI for +225 prefix', () {
      expect(inferDjamoCountryCode('+2250102030405'), 'CI');
    });

    test('returns CI for 225 prefix without plus', () {
      expect(inferDjamoCountryCode('2250102030405'), 'CI');
    });

    test('returns CI for 10-digit number', () {
      expect(inferDjamoCountryCode('0102030405'), 'CI');
    });

    test('returns SN for 9-digit number', () {
      expect(inferDjamoCountryCode('771234567'), 'SN');
    });

    test('returns SN for +221 prefix', () {
      expect(inferDjamoCountryCode('+221771234567'), 'SN');
    });

    test('returns SN for empty string', () {
      expect(inferDjamoCountryCode(''), 'SN');
    });

    test('strips non-digit characters before checking', () {
      expect(inferDjamoCountryCode('+225 01 02 03 04 05'), 'CI');
      expect(inferDjamoCountryCode('77 123 45 67'), 'SN');
    });
  });
}
