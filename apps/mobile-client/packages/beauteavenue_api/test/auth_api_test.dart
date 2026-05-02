import 'package:test/test.dart';
import 'package:beauteavenue_api/beauteavenue_api.dart';

/// tests for AuthApi
void main() {
  final instance = BeauteavenueApi().getAuthApi();

  group(AuthApi, () {
    // Email login
    //
    //Future<AuthSession> apiV1AuthLoginPost(EmailLoginInput emailLoginInput) async
    test('test apiV1AuthLoginPost', () async {
      // TODO
    });

    // Logout current session
    //
    //Future<LogoutResponse> apiV1AuthLogoutPost({ RefreshInput refreshInput }) async
    test('test apiV1AuthLogoutPost', () async {
      // TODO
    });

    // Request an OTP code
    //
    //Future<OtpAcceptedResponse> apiV1AuthOtpRequestPost(OtpRequestInput otpRequestInput) async
    test('test apiV1AuthOtpRequestPost', () async {
      // TODO
    });

    // Verify OTP
    //
    //Future<AuthSession> apiV1AuthOtpVerifyPost(OtpVerifyInput otpVerifyInput) async
    test('test apiV1AuthOtpVerifyPost', () async {
      // TODO
    });

    // Refresh access token
    //
    //Future<AuthSession> apiV1AuthRefreshPost(RefreshInput refreshInput) async
    test('test apiV1AuthRefreshPost', () async {
      // TODO
    });

    // Register client or salon owner
    //
    //Future<AuthSession> apiV1AuthRegisterPost(RegisterInput registerInput) async
    test('test apiV1AuthRegisterPost', () async {
      // TODO
    });

    // Current user
    //
    //Future<CurrentUser> apiV1MeGet() async
    test('test apiV1MeGet', () async {
      // TODO
    });

    // Update current user
    //
    //Future<CurrentUser> apiV1MePatch(UpdateMeInput updateMeInput) async
    test('test apiV1MePatch', () async {
      // TODO
    });
  });
}
