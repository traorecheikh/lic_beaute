// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (Serializers().toBuilder()
      ..add(AdminAuditDetail.serializer)
      ..add(AdminAuditDetailRelatedLinksInner.serializer)
      ..add(AdminAuditDetailSeverityEnum.serializer)
      ..add(AdminAuditFilters.serializer)
      ..add(AdminAuditSummary.serializer)
      ..add(AdminAuditSummaryListResponse.serializer)
      ..add(AdminAuditSummaryListResponseItemsInner.serializer)
      ..add(AdminAuditSummaryListResponseItemsInnerSeverityEnum.serializer)
      ..add(AdminAuditSummarySeverityEnum.serializer)
      ..add(AdminDashboard.serializer)
      ..add(AdminDashboardInactivityAlertsInner.serializer)
      ..add(AdminDashboardInactivityAlertsInnerStatusEnum.serializer)
      ..add(AdminDashboardKpisInner.serializer)
      ..add(AdminDashboardQuickLinks.serializer)
      ..add(AdminDashboardTopGrowthSalonsInner.serializer)
      ..add(AdminSalonDecisionInput.serializer)
      ..add(AdminSalonDetail.serializer)
      ..add(AdminSalonDetailApprovalStatusEnum.serializer)
      ..add(AdminSalonDetailDocumentsInner.serializer)
      ..add(AdminSalonDetailDocumentsInnerStatusEnum.serializer)
      ..add(AdminSalonDetailOwner.serializer)
      ..add(AdminSalonDetailServicesInner.serializer)
      ..add(AdminSalonDetailServicesInnerDepositModeEnum.serializer)
      ..add(AdminSalonDetailSubscriptionIntentTierEnum.serializer)
      ..add(AdminSalonQueueFilters.serializer)
      ..add(AdminSalonQueueFiltersStatusEnum.serializer)
      ..add(AdminSalonQueueItem.serializer)
      ..add(AdminSalonQueueItemApprovalStatusEnum.serializer)
      ..add(AdminSalonQueueItemSubscriptionIntentTierEnum.serializer)
      ..add(AdminSalonQueueResponse.serializer)
      ..add(AdminSalonQueueResponseItemsInner.serializer)
      ..add(AdminSalonQueueResponseItemsInnerApprovalStatusEnum.serializer)
      ..add(AdminSalonQueueResponseItemsInnerSubscriptionIntentTierEnum
          .serializer)
      ..add(AdminSubscriptionDetail.serializer)
      ..add(AdminSubscriptionDetailBillingProviderEnum.serializer)
      ..add(AdminSubscriptionDetailEntitlementsInner.serializer)
      ..add(AdminSubscriptionDetailEventsInner.serializer)
      ..add(AdminSubscriptionDetailEventsInnerSource_Enum.serializer)
      ..add(AdminSubscriptionDetailInvoicesInner.serializer)
      ..add(AdminSubscriptionDetailInvoicesInnerStatusEnum.serializer)
      ..add(AdminSubscriptionDetailStatusEnum.serializer)
      ..add(AdminSubscriptionDetailTierEnum.serializer)
      ..add(AdminSubscriptionListResponse.serializer)
      ..add(AdminSubscriptionListResponseItemsInner.serializer)
      ..add(
          AdminSubscriptionListResponseItemsInnerBillingProviderEnum.serializer)
      ..add(AdminSubscriptionListResponseItemsInnerStatusEnum.serializer)
      ..add(AdminSubscriptionListResponseItemsInnerTierEnum.serializer)
      ..add(AdminSubscriptionListResponseSummary.serializer)
      ..add(AdminSubscriptionOverrideInput.serializer)
      ..add(AdminSubscriptionOverrideInputActionEnum.serializer)
      ..add(AdminSubscriptionOverrideInputMetadata.serializer)
      ..add(AdminSubscriptionSummary.serializer)
      ..add(AdminSubscriptionSummaryBillingProviderEnum.serializer)
      ..add(AdminSubscriptionSummaryStatusEnum.serializer)
      ..add(AdminSubscriptionSummaryTierEnum.serializer)
      ..add(ApiError.serializer)
      ..add(AuthSession.serializer)
      ..add(BookingCreateInput.serializer)
      ..add(BookingCreateInputProviderEnum.serializer)
      ..add(BookingSummary.serializer)
      ..add(BookingSummaryDepositPaymentStatusEnum.serializer)
      ..add(BookingSummaryListResponse.serializer)
      ..add(BookingSummaryListResponseItemsInner.serializer)
      ..add(BookingSummaryListResponseItemsInnerDepositPaymentStatusEnum
          .serializer)
      ..add(BookingSummaryListResponseItemsInnerPaymentProviderEnum.serializer)
      ..add(BookingSummaryListResponseItemsInnerStatusEnum.serializer)
      ..add(BookingSummaryPaymentProviderEnum.serializer)
      ..add(BookingSummaryStatusEnum.serializer)
      ..add(CurrentUser.serializer)
      ..add(CurrentUserRoleEnum.serializer)
      ..add(DeletedResponse.serializer)
      ..add(EmailLoginInput.serializer)
      ..add(HealthGet200Response.serializer)
      ..add(HealthGet200ResponseDatabase.serializer)
      ..add(LogoutResponse.serializer)
      ..add(OtpAcceptedResponse.serializer)
      ..add(OtpRequestInput.serializer)
      ..add(OtpVerifyInput.serializer)
      ..add(ProAnalytics.serializer)
      ..add(ProAnalyticsTopServicesInner.serializer)
      ..add(ProBlockedSlot.serializer)
      ..add(ProBlockedSlotCreateInput.serializer)
      ..add(ProBlockedSlotCreateInputScopeEnum.serializer)
      ..add(ProBlockedSlotScopeEnum.serializer)
      ..add(ProBookingDetail.serializer)
      ..add(ProBookingDetailStatusEnum.serializer)
      ..add(ProBookingFullDetail.serializer)
      ..add(ProBookingFullDetailEventsInner.serializer)
      ..add(ProBookingFullDetailPaymentsInner.serializer)
      ..add(ProBookingFullDetailStatusEnum.serializer)
      ..add(ProBookingStatusUpdate.serializer)
      ..add(ProBookingStatusUpdateStatusEnum.serializer)
      ..add(ProCheckoutCompleteInput.serializer)
      ..add(ProCheckoutCompleteInputPaymentMethodEnum.serializer)
      ..add(ProCheckoutCompleteResult.serializer)
      ..add(ProCheckoutCompleteResultStatusEnum.serializer)
      ..add(ProCheckoutDetails.serializer)
      ..add(ProCheckoutDetailsLineItemsInner.serializer)
      ..add(ProCheckoutDetailsStatusEnum.serializer)
      ..add(ProClientDetail.serializer)
      ..add(ProClientDetailRecentBookingsInner.serializer)
      ..add(ProClientDetailRecentBookingsInnerStatusEnum.serializer)
      ..add(ProClientSummary.serializer)
      ..add(ProDashboard.serializer)
      ..add(ProInvoice.serializer)
      ..add(ProManualBookingCreated.serializer)
      ..add(ProManualBookingCreatedStatusEnum.serializer)
      ..add(ProManualBookingInput.serializer)
      ..add(ProPayoutEvent.serializer)
      ..add(ProReview.serializer)
      ..add(ProReviewResponseInput.serializer)
      ..add(ProSalonHour.serializer)
      ..add(ProSalonProfile.serializer)
      ..add(ProSalonProfileHoursInner.serializer)
      ..add(ProSalonProfileSubscriptionTierEnum.serializer)
      ..add(ProSalonUpdateInput.serializer)
      ..add(ProSalonUpdateInputTeamDisplay.serializer)
      ..add(ProService.serializer)
      ..add(ProServiceCreateInput.serializer)
      ..add(ProServiceCreateInputDepositModeEnum.serializer)
      ..add(ProServiceDepositModeEnum.serializer)
      ..add(ProServiceUpdateInput.serializer)
      ..add(ProServiceUpdateInputDepositModeEnum.serializer)
      ..add(ProStaffCreateInput.serializer)
      ..add(ProStaffMember.serializer)
      ..add(ProStaffUpdateInput.serializer)
      ..add(ProSubscription.serializer)
      ..add(ProSubscriptionBillingMethod.serializer)
      ..add(ProSubscriptionBillingMethodProviderEnum.serializer)
      ..add(ProSubscriptionCheckoutInput.serializer)
      ..add(ProSubscriptionCheckoutInputActionEnum.serializer)
      ..add(ProSubscriptionCheckoutInputProviderEnum.serializer)
      ..add(ProSubscriptionCheckoutResult.serializer)
      ..add(ProSubscriptionStatusEnum.serializer)
      ..add(ProSubscriptionTierEnum.serializer)
      ..add(ProSubscriptionUpdateInput.serializer)
      ..add(ProSubscriptionUpdateInputBillingMethod.serializer)
      ..add(ProSubscriptionUpdateInputBillingMethodProviderEnum.serializer)
      ..add(RefreshInput.serializer)
      ..add(RegisterInput.serializer)
      ..add(RegisterInputAnyOf.serializer)
      ..add(RegisterInputAnyOf1.serializer)
      ..add(RegisterInputAnyOf1HoursInner.serializer)
      ..add(RegisterInputAnyOf1Salon.serializer)
      ..add(RegisterInputAnyOf1ServicesInner.serializer)
      ..add(RegisterInputAnyOf1ServicesInnerDepositModeEnum.serializer)
      ..add(RegisterInputAnyOf1TypeEnum.serializer)
      ..add(RegisterInputAnyOfTypeEnum.serializer)
      ..add(SalonDetail.serializer)
      ..add(SalonDetailServicesInner.serializer)
      ..add(SalonDetailStaffInner.serializer)
      ..add(SalonDetailSubscriptionTierEnum.serializer)
      ..add(SalonDetailTeamDisplay.serializer)
      ..add(SalonSummary.serializer)
      ..add(SalonSummaryListResponse.serializer)
      ..add(SalonSummaryListResponseItemsInner.serializer)
      ..add(SalonSummaryListResponseItemsInnerSubscriptionTierEnum.serializer)
      ..add(SalonSummarySubscriptionTierEnum.serializer)
      ..add(UpdateMeInput.serializer)
      ..add(UpdatedResponse.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(AdminAuditDetailRelatedLinksInner)]),
          () => ListBuilder<AdminAuditDetailRelatedLinksInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(AdminAuditSummaryListResponseItemsInner)]),
          () => ListBuilder<AdminAuditSummaryListResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(AdminDashboardKpisInner)]),
          () => ListBuilder<AdminDashboardKpisInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(AdminDashboardTopGrowthSalonsInner)]),
          () => ListBuilder<AdminDashboardTopGrowthSalonsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(AdminDashboardInactivityAlertsInner)]),
          () => ListBuilder<AdminDashboardInactivityAlertsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(AdminSalonQueueResponseItemsInner)]),
          () => ListBuilder<AdminSalonQueueResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(AdminSubscriptionDetailEntitlementsInner)]),
          () => ListBuilder<AdminSubscriptionDetailEntitlementsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(AdminSubscriptionDetailEventsInner)]),
          () => ListBuilder<AdminSubscriptionDetailEventsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(AdminSubscriptionDetailInvoicesInner)]),
          () => ListBuilder<AdminSubscriptionDetailInvoicesInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(AdminSubscriptionListResponseItemsInner)]),
          () => ListBuilder<AdminSubscriptionListResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(BookingSummaryListResponseItemsInner)]),
          () => ListBuilder<BookingSummaryListResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProAnalyticsTopServicesInner)]),
          () => ListBuilder<ProAnalyticsTopServicesInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ProBookingFullDetailPaymentsInner)]),
          () => ListBuilder<ProBookingFullDetailPaymentsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ProBookingFullDetailEventsInner)]),
          () => ListBuilder<ProBookingFullDetailEventsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ProCheckoutDetailsLineItemsInner)]),
          () => ListBuilder<ProCheckoutDetailsLineItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ProCheckoutDetailsLineItemsInner)]),
          () => ListBuilder<ProCheckoutDetailsLineItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ProClientDetailRecentBookingsInner)]),
          () => ListBuilder<ProClientDetailRecentBookingsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(RegisterInputAnyOf1ServicesInner)]),
          () => ListBuilder<RegisterInputAnyOf1ServicesInner>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(RegisterInputAnyOf1HoursInner)]),
          () => ListBuilder<RegisterInputAnyOf1HoursInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(SalonSummaryListResponseItemsInner)]),
          () => ListBuilder<SalonSummaryListResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(ProSalonProfileHoursInner)]),
          () => ListBuilder<ProSalonProfileHoursInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(SalonDetailServicesInner)]),
          () => ListBuilder<SalonDetailServicesInner>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(SalonDetailStaffInner)]),
          () => ListBuilder<SalonDetailStaffInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(AdminSalonDetailServicesInner)]),
          () => ListBuilder<AdminSalonDetailServicesInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(AdminSalonDetailDocumentsInner)]),
          () => ListBuilder<AdminSalonDetailDocumentsInner>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
