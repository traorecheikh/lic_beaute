import 'package:test/test.dart';
import 'package:beauteavenue_api/beauteavenue_api.dart';

/// tests for AdminApi
void main() {
  final instance = BeauteavenueApi().getAdminApi();

  group(AdminApi, () {
    // Audit event detail
    //
    //Future<AdminAuditDetail> apiV1AdminAuditAuditIdGet(String auditId) async
    test('test apiV1AdminAuditAuditIdGet', () async {
      // TODO
    });

    // List admin audit events
    //
    //Future<AdminAuditSummaryListResponse> apiV1AdminAuditGet({ String actor, String entityType, String action }) async
    test('test apiV1AdminAuditGet', () async {
      // TODO
    });

    // Admin dashboard
    //
    //Future<AdminDashboard> apiV1AdminDashboardGet() async
    test('test apiV1AdminDashboardGet', () async {
      // TODO
    });

    // List pending salon approvals
    //
    //Future<AdminSalonQueueResponse> apiV1AdminSalonsPendingGet({ String search, String category, String city, String status }) async
    test('test apiV1AdminSalonsPendingGet', () async {
      // TODO
    });

    // Approve salon listing
    //
    //Future<AdminSalonDetail> apiV1AdminSalonsSalonIdApprovePost(String salonId) async
    test('test apiV1AdminSalonsSalonIdApprovePost', () async {
      // TODO
    });

    // Salon approval detail
    //
    //Future<AdminSalonDetail> apiV1AdminSalonsSalonIdGet(String salonId) async
    test('test apiV1AdminSalonsSalonIdGet', () async {
      // TODO
    });

    // Reject salon listing
    //
    //Future<AdminSalonDetail> apiV1AdminSalonsSalonIdRejectPost(String salonId, AdminSalonDecisionInput adminSalonDecisionInput) async
    test('test apiV1AdminSalonsSalonIdRejectPost', () async {
      // TODO
    });

    // Request more information for salon listing
    //
    //Future<AdminSalonDetail> apiV1AdminSalonsSalonIdRequestInfoPost(String salonId, AdminSalonDecisionInput adminSalonDecisionInput) async
    test('test apiV1AdminSalonsSalonIdRequestInfoPost', () async {
      // TODO
    });

    // List subscription lifecycles
    //
    //Future<AdminSubscriptionListResponse> apiV1AdminSubscriptionsGet({ String search, String tier, String status }) async
    test('test apiV1AdminSubscriptionsGet', () async {
      // TODO
    });

    // Subscription detail
    //
    //Future<AdminSubscriptionDetail> apiV1AdminSubscriptionsSubscriptionIdGet(String subscriptionId) async
    test('test apiV1AdminSubscriptionsSubscriptionIdGet', () async {
      // TODO
    });

    // Apply admin subscription override
    //
    //Future<AdminSubscriptionDetail> apiV1AdminSubscriptionsSubscriptionIdOverridePost(String subscriptionId, AdminSubscriptionOverrideInput adminSubscriptionOverrideInput) async
    test('test apiV1AdminSubscriptionsSubscriptionIdOverridePost', () async {
      // TODO
    });
  });
}
