import 'package:test/test.dart';
import 'package:beauteavenue_api/beauteavenue_api.dart';


/// tests for PaymentsApi
void main() {
  final instance = BeauteavenueApi().getPaymentsApi();

  group(PaymentsApi, () {
    // Initiate deposit payment for a booking
    //
    //Future<PaymentInitiateResponse> apiV1PaymentsDepositsInitiatePost(PaymentInitiateInput paymentInitiateInput) async
    test('test apiV1PaymentsDepositsInitiatePost', () async {
      // TODO
    });

    // Get payment status
    //
    //Future<PaymentStatusResponse> apiV1PaymentsPaymentIdGet(String paymentId) async
    test('test apiV1PaymentsPaymentIdGet', () async {
      // TODO
    });

    // Manually reconcile a payment (admin or pro)
    //
    //Future<PaymentReconcileResponse> apiV1PaymentsPaymentIdReconcilePost(String paymentId) async
    test('test apiV1PaymentsPaymentIdReconcilePost', () async {
      // TODO
    });

    // Refund a payment
    //
    //Future<PaymentStatusResponse> apiV1PaymentsPaymentIdRefundPost(String paymentId) async
    test('test apiV1PaymentsPaymentIdRefundPost', () async {
      // TODO
    });

    // Intech payment webhook callback
    //
    //Future<ApiV1PaymentsWebhooksIntechPost200Response> apiV1PaymentsWebhooksIntechPost(PaymentWebhookBody paymentWebhookBody) async
    test('test apiV1PaymentsWebhooksIntechPost', () async {
      // TODO
    });

    // PayTech payment webhook callback
    //
    //Future<ApiV1PaymentsWebhooksIntechPost200Response> apiV1PaymentsWebhooksPaytechPost(PaymentWebhookBody paymentWebhookBody) async
    test('test apiV1PaymentsWebhooksPaytechPost', () async {
      // TODO
    });

  });
}
