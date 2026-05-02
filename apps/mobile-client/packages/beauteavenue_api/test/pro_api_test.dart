import 'package:test/test.dart';
import 'package:beauteavenue_api/beauteavenue_api.dart';

/// tests for ProApi
void main() {
  final instance = BeauteavenueApi().getProApi();

  group(ProApi, () {
    // Get salon analytics
    //
    //Future<ProAnalytics> apiV1ProAnalyticsGet({ String period }) async
    test('test apiV1ProAnalyticsGet', () async {
      // TODO
    });

    // List blocked slots
    //
    //Future<BuiltList<ProBlockedSlot>> apiV1ProBlockedSlotsGet() async
    test('test apiV1ProBlockedSlotsGet', () async {
      // TODO
    });

    // Create blocked slot
    //
    //Future<ProBlockedSlot> apiV1ProBlockedSlotsPost(ProBlockedSlotCreateInput proBlockedSlotCreateInput) async
    test('test apiV1ProBlockedSlotsPost', () async {
      // TODO
    });

    // Delete blocked slot
    //
    //Future<DeletedResponse> apiV1ProBlockedSlotsSlotIdDelete(String slotId) async
    test('test apiV1ProBlockedSlotsSlotIdDelete', () async {
      // TODO
    });

    // Accept booking
    //
    //Future<ProBookingStatusUpdate> apiV1ProBookingsBookingIdAcceptPost(String bookingId) async
    test('test apiV1ProBookingsBookingIdAcceptPost', () async {
      // TODO
    });

    // Complete booking
    //
    //Future<ProBookingStatusUpdate> apiV1ProBookingsBookingIdCompletePost(String bookingId) async
    test('test apiV1ProBookingsBookingIdCompletePost', () async {
      // TODO
    });

    // Get booking detail
    //
    //Future<ProBookingFullDetail> apiV1ProBookingsBookingIdGet(String bookingId) async
    test('test apiV1ProBookingsBookingIdGet', () async {
      // TODO
    });

    // Reject booking
    //
    //Future<ProBookingStatusUpdate> apiV1ProBookingsBookingIdRejectPost(String bookingId) async
    test('test apiV1ProBookingsBookingIdRejectPost', () async {
      // TODO
    });

    // Start booking
    //
    //Future<ProBookingStatusUpdate> apiV1ProBookingsBookingIdStartPost(String bookingId) async
    test('test apiV1ProBookingsBookingIdStartPost', () async {
      // TODO
    });

    // List pro bookings
    //
    //Future<BuiltList<ProBookingDetail>> apiV1ProBookingsGet({ String status, String date, int page, int pageSize }) async
    test('test apiV1ProBookingsGet', () async {
      // TODO
    });

    // Create manual booking
    //
    //Future<ProManualBookingCreated> apiV1ProBookingsManualPost(ProManualBookingInput proManualBookingInput) async
    test('test apiV1ProBookingsManualPost', () async {
      // TODO
    });

    // Complete checkout for a booking
    //
    //Future<ProCheckoutCompleteResult> apiV1ProCheckoutBookingIdCompletePost(String bookingId, ProCheckoutCompleteInput proCheckoutCompleteInput) async
    test('test apiV1ProCheckoutBookingIdCompletePost', () async {
      // TODO
    });

    // Get checkout details for a booking
    //
    //Future<ProCheckoutDetails> apiV1ProCheckoutBookingIdGet(String bookingId) async
    test('test apiV1ProCheckoutBookingIdGet', () async {
      // TODO
    });

    // Get salon client detail
    //
    //Future<ProClientDetail> apiV1ProClientsClientIdGet(String clientId) async
    test('test apiV1ProClientsClientIdGet', () async {
      // TODO
    });

    // List salon clients
    //
    //Future<BuiltList<ProClientSummary>> apiV1ProClientsGet({ String search }) async
    test('test apiV1ProClientsGet', () async {
      // TODO
    });

    // Salon operational dashboard
    //
    //Future<ProDashboard> apiV1ProDashboardGet() async
    test('test apiV1ProDashboardGet', () async {
      // TODO
    });

    // List opening hours
    //
    //Future<BuiltList<ProSalonHour>> apiV1ProHoursGet() async
    test('test apiV1ProHoursGet', () async {
      // TODO
    });

    // Update opening hours
    //
    //Future<UpdatedResponse> apiV1ProHoursPut(BuiltList<ProSalonProfileHoursInner> proSalonProfileHoursInner) async
    test('test apiV1ProHoursPut', () async {
      // TODO
    });

    // List subscription invoices
    //
    //Future<BuiltList<ProInvoice>> apiV1ProInvoicesGet() async
    test('test apiV1ProInvoicesGet', () async {
      // TODO
    });

    // Download subscription invoice PDF
    //
    //Future<Uint8List> apiV1ProInvoicesInvoiceIdPdfGet(String invoiceId) async
    test('test apiV1ProInvoicesInvoiceIdPdfGet', () async {
      // TODO
    });

    // List settlement and payout events
    //
    //Future<BuiltList<ProPayoutEvent>> apiV1ProPayoutsGet() async
    test('test apiV1ProPayoutsGet', () async {
      // TODO
    });

    // List salon reviews
    //
    //Future<BuiltList<ProReview>> apiV1ProReviewsGet() async
    test('test apiV1ProReviewsGet', () async {
      // TODO
    });

    // Respond to a review
    //
    //Future<UpdatedResponse> apiV1ProReviewsReviewIdResponsePost(String reviewId, ProReviewResponseInput proReviewResponseInput) async
    test('test apiV1ProReviewsReviewIdResponsePost', () async {
      // TODO
    });

    // Get owned salon profile
    //
    //Future<ProSalonProfile> apiV1ProSalonGet() async
    test('test apiV1ProSalonGet', () async {
      // TODO
    });

    // Update owned salon profile
    //
    //Future<ProSalonProfile> apiV1ProSalonPatch(ProSalonUpdateInput proSalonUpdateInput) async
    test('test apiV1ProSalonPatch', () async {
      // TODO
    });

    // List salon services
    //
    //Future<BuiltList<ProService>> apiV1ProServicesGet() async
    test('test apiV1ProServicesGet', () async {
      // TODO
    });

    // Create salon service
    //
    //Future<ProService> apiV1ProServicesPost(ProServiceCreateInput proServiceCreateInput) async
    test('test apiV1ProServicesPost', () async {
      // TODO
    });

    // Archive salon service
    //
    //Future<DeletedResponse> apiV1ProServicesServiceIdDelete(String serviceId) async
    test('test apiV1ProServicesServiceIdDelete', () async {
      // TODO
    });

    // Update salon service
    //
    //Future<ProService> apiV1ProServicesServiceIdPatch(String serviceId, ProServiceUpdateInput proServiceUpdateInput) async
    test('test apiV1ProServicesServiceIdPatch', () async {
      // TODO
    });

    // Archive salon staff
    //
    //Future<DeletedResponse> apiV1ProStaffEmployeeIdDelete(String employeeId) async
    test('test apiV1ProStaffEmployeeIdDelete', () async {
      // TODO
    });

    // Update salon staff
    //
    //Future<UpdatedResponse> apiV1ProStaffEmployeeIdPatch(String employeeId, ProStaffUpdateInput proStaffUpdateInput) async
    test('test apiV1ProStaffEmployeeIdPatch', () async {
      // TODO
    });

    // List salon staff
    //
    //Future<BuiltList<ProStaffMember>> apiV1ProStaffGet() async
    test('test apiV1ProStaffGet', () async {
      // TODO
    });

    // Create salon staff
    //
    //Future<ProStaffMember> apiV1ProStaffPost(ProStaffCreateInput proStaffCreateInput) async
    test('test apiV1ProStaffPost', () async {
      // TODO
    });

    // Initiate premium subscription checkout
    //
    //Future<ProSubscriptionCheckoutResult> apiV1ProSubscriptionCheckoutPost(ProSubscriptionCheckoutInput proSubscriptionCheckoutInput) async
    test('test apiV1ProSubscriptionCheckoutPost', () async {
      // TODO
    });

    // Get subscription details
    //
    //Future<ProSubscription> apiV1ProSubscriptionGet() async
    test('test apiV1ProSubscriptionGet', () async {
      // TODO
    });

    // Update subscription settings
    //
    //Future<UpdatedResponse> apiV1ProSubscriptionPatch(ProSubscriptionUpdateInput proSubscriptionUpdateInput) async
    test('test apiV1ProSubscriptionPatch', () async {
      // TODO
    });
  });
}
