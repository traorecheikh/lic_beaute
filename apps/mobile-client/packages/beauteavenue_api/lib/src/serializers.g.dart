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
      ..add(AdminSalonDetailSubscriptionIntentTierEnum.serializer)
      ..add(AdminSalonQueueFilters.serializer)
      ..add(AdminSalonQueueFiltersStatusEnum.serializer)
      ..add(AdminSalonQueueItem.serializer)
      ..add(AdminSalonQueueItemApprovalStatusEnum.serializer)
      ..add(AdminSalonQueueItemSubscriptionIntentTierEnum.serializer)
      ..add(AdminSalonQueueResponse.serializer)
      ..add(AdminSubscriptionDetail.serializer)
      ..add(AdminSubscriptionDetailBillingProviderEnum.serializer)
      ..add(AdminSubscriptionDetailEntitlementsInner.serializer)
      ..add(AdminSubscriptionDetailEventsInner.serializer)
      ..add(AdminSubscriptionDetailEventsInnerSource_Enum.serializer)
      ..add(AdminSubscriptionDetailInvoicesInner.serializer)
      ..add(AdminSubscriptionDetailInvoicesInnerStatusEnum.serializer)
      ..add(AdminSubscriptionDetailPendingChargesInner.serializer)
      ..add(AdminSubscriptionDetailPendingChargesInnerChargeTypeEnum.serializer)
      ..add(AdminSubscriptionDetailPendingChargesInnerProviderEnum.serializer)
      ..add(AdminSubscriptionDetailPendingChargesInnerStatusEnum.serializer)
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
      ..add(ApiV1AdminConfigCategoriesGet200ResponseInner.serializer)
      ..add(ApiV1AdminConfigCategoriesPostRequest.serializer)
      ..add(ApiV1AdminConfigDocumentsGet200ResponseInner.serializer)
      ..add(ApiV1AdminConfigDocumentsPostRequest.serializer)
      ..add(ApiV1AdminConfigSettingsGet200ResponseInner.serializer)
      ..add(ApiV1AdminConfigSettingsKeyPatchRequest.serializer)
      ..add(ApiV1AdminMediaMediaIdApprovePost200Response.serializer)
      ..add(ApiV1AdminMediaMediaIdApprovePostRequest.serializer)
      ..add(ApiV1AdminMediaMediaIdRejectPost200Response.serializer)
      ..add(ApiV1AdminMediaMediaIdRejectPostRequest.serializer)
      ..add(ApiV1AdminMediaMediaIdSignedViewUrlPost200Response.serializer)
      ..add(ApiV1AdminMediaPendingGet200Response.serializer)
      ..add(ApiV1AdminMediaPendingGet200ResponseItemsInner.serializer)
      ..add(ApiV1AdminSalonsGet200Response.serializer)
      ..add(ApiV1AdminSalonsGet200ResponseItemsInner.serializer)
      ..add(
          ApiV1AdminSalonsGet200ResponseItemsInnerApprovalStatusEnum.serializer)
      ..add(ApiV1AdminSalonsGet200ResponseItemsInnerSubscriptionIntentTierEnum
          .serializer)
      ..add(ApiV1AdminSalonsPost201Response.serializer)
      ..add(ApiV1AdminSalonsPost201ResponseApprovalStatusEnum.serializer)
      ..add(ApiV1AdminSalonsPost201ResponseDocumentsInner.serializer)
      ..add(ApiV1AdminSalonsPost201ResponseDocumentsInnerStatusEnum.serializer)
      ..add(ApiV1AdminSalonsPost201ResponseOwner.serializer)
      ..add(ApiV1AdminSalonsPost201ResponseServicesInner.serializer)
      ..add(ApiV1AdminSalonsPost201ResponseServicesInnerDepositModeEnum
          .serializer)
      ..add(
          ApiV1AdminSalonsPost201ResponseSubscriptionIntentTierEnum.serializer)
      ..add(ApiV1AdminSalonsPostRequest.serializer)
      ..add(ApiV1BookingsBookingIdReviewPost201Response.serializer)
      ..add(ApiV1BookingsBookingIdReviewPostRequest.serializer)
      ..add(ApiV1ConfigPricingGet200Response.serializer)
      ..add(ApiV1ConfigPricingGet200ResponseStandard.serializer)
      ..add(ApiV1ConfigSupportGet200Response.serializer)
      ..add(ApiV1MeAddressesAddressIdPatchRequest.serializer)
      ..add(ApiV1MeAddressesGet200Response.serializer)
      ..add(ApiV1MeAddressesGet200ResponseItemsInner.serializer)
      ..add(ApiV1MeAddressesPostRequest.serializer)
      ..add(ApiV1MeBenefitsGet200Response.serializer)
      ..add(ApiV1MeBenefitsGet200ResponseItemsInner.serializer)
      ..add(ApiV1MeBenefitsGet200ResponseItemsInnerKindEnum.serializer)
      ..add(ApiV1MeBenefitsGet200ResponseItemsInnerStatusEnum.serializer)
      ..add(ApiV1MePaymentMethodsGet200Response.serializer)
      ..add(ApiV1MePaymentMethodsGet200ResponseItemsInner.serializer)
      ..add(ApiV1MePaymentMethodsGet200ResponseItemsInnerMethodEnum.serializer)
      ..add(
          ApiV1MePaymentMethodsGet200ResponseItemsInnerProviderEnum.serializer)
      ..add(ApiV1MeVouchersGet200Response.serializer)
      ..add(ApiV1MeVouchersGet200ResponseItemsInner.serializer)
      ..add(ApiV1MeVouchersGet200ResponseItemsInnerStatusEnum.serializer)
      ..add(ApiV1MediaUploadIntentPost201Response.serializer)
      ..add(ApiV1MediaUploadIntentPostRequest.serializer)
      ..add(ApiV1MediaUploadIntentPostRequestPurposeEnum.serializer)
      ..add(ApiV1MediaUploadPost201Response.serializer)
      ..add(ApiV1NotificationsGet200Response.serializer)
      ..add(ApiV1NotificationsGet200ResponseItemsInner.serializer)
      ..add(ApiV1NotificationsIdReadPost200Response.serializer)
      ..add(ApiV1PaymentsWebhooksPaydunyaPost200Response.serializer)
      ..add(ApiV1ProVouchersPost201Response.serializer)
      ..add(ApiV1PushTokensPost201Response.serializer)
      ..add(ApiV1SalonsIdAvailabilityGet200ResponseInner.serializer)
      ..add(ApiV1SalonsIdReviewsGet200Response.serializer)
      ..add(ApiV1SalonsSalonIdPublicMediaGet200Response.serializer)
      ..add(ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner.serializer)
      ..add(AuthSession.serializer)
      ..add(BookingCreateInput.serializer)
      ..add(BookingCreateInputChannelEnum.serializer)
      ..add(BookingCreateInputProviderEnum.serializer)
      ..add(BookingRescheduleInput.serializer)
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
      ..add(ClientBenefit.serializer)
      ..add(ClientBenefitKindEnum.serializer)
      ..add(ClientBenefitStatusEnum.serializer)
      ..add(ClientPaymentMethod.serializer)
      ..add(ClientPaymentMethodCreateInput.serializer)
      ..add(ClientPaymentMethodCreateInputMethodEnum.serializer)
      ..add(ClientPaymentMethodCreateInputProviderEnum.serializer)
      ..add(ClientPaymentMethodMethodEnum.serializer)
      ..add(ClientPaymentMethodProviderEnum.serializer)
      ..add(ClientPaymentMethodUpdateInput.serializer)
      ..add(ClientPaymentMethodUpdateInputMethodEnum.serializer)
      ..add(ClientVoucher.serializer)
      ..add(ClientVoucherStatusEnum.serializer)
      ..add(CurrentUser.serializer)
      ..add(CurrentUserPreferredContactChannelEnum.serializer)
      ..add(CurrentUserPreferredLanguageEnum.serializer)
      ..add(CurrentUserRoleEnum.serializer)
      ..add(DeletedResponse.serializer)
      ..add(EmailLoginInput.serializer)
      ..add(EmailOtpAcceptedResponse.serializer)
      ..add(EmailOtpRequestInput.serializer)
      ..add(EmailOtpVerifyInput.serializer)
      ..add(FavoriteItem.serializer)
      ..add(FavoriteItemSubscriptionTierEnum.serializer)
      ..add(FavoriteListResponse.serializer)
      ..add(HealthGet200Response.serializer)
      ..add(HealthGet200ResponseDatabase.serializer)
      ..add(LogoutResponse.serializer)
      ..add(MediaAsset.serializer)
      ..add(MediaUploadResponse.serializer)
      ..add(OtpAcceptedResponse.serializer)
      ..add(OtpRequestInput.serializer)
      ..add(OtpVerifyInput.serializer)
      ..add(PaydunyaExecutePaymentInput.serializer)
      ..add(PaydunyaExecutePaymentResponse.serializer)
      ..add(PaydunyaExecutePaymentResponseOtherUrl.serializer)
      ..add(PaydunyaMethodListResponse.serializer)
      ..add(PaydunyaMethodListResponseMethodsInner.serializer)
      ..add(PaymentInitiateInput.serializer)
      ..add(PaymentInitiateInputChannelEnum.serializer)
      ..add(PaymentInitiateInputProviderEnum.serializer)
      ..add(PaymentInitiateResponse.serializer)
      ..add(PaymentReconcileResponse.serializer)
      ..add(PaymentReconcileResponseProviderEnum.serializer)
      ..add(PaymentReconcileResponseStatusEnum.serializer)
      ..add(PaymentStatusResponse.serializer)
      ..add(PaymentStatusResponseProviderEnum.serializer)
      ..add(PaymentStatusResponseStatusEnum.serializer)
      ..add(PaymentWebhookBody.serializer)
      ..add(PaymentWebhookBodyAmount.serializer)
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
      ..add(ProClientBenefitCreateInput.serializer)
      ..add(ProClientBenefitCreateInputKindEnum.serializer)
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
      ..add(ProSalonProfileApprovalStatusEnum.serializer)
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
      ..add(ProStaffCreateInputRoleEnum.serializer)
      ..add(ProStaffMember.serializer)
      ..add(ProStaffMemberRoleEnum.serializer)
      ..add(ProStaffUpdateInput.serializer)
      ..add(ProStaffUpdateInputRoleEnum.serializer)
      ..add(ProSubscription.serializer)
      ..add(ProSubscriptionBillingMethod.serializer)
      ..add(ProSubscriptionBillingMethodProviderEnum.serializer)
      ..add(ProSubscriptionCheckoutInput.serializer)
      ..add(ProSubscriptionCheckoutInputActionEnum.serializer)
      ..add(ProSubscriptionCheckoutInputBillingCycleEnum.serializer)
      ..add(ProSubscriptionCheckoutInputChannelEnum.serializer)
      ..add(ProSubscriptionCheckoutInputProviderEnum.serializer)
      ..add(ProSubscriptionCheckoutInputTierEnum.serializer)
      ..add(ProSubscriptionCheckoutResult.serializer)
      ..add(ProSubscriptionExecuteInput.serializer)
      ..add(ProSubscriptionExecuteResponse.serializer)
      ..add(ProSubscriptionPendingTierEnum.serializer)
      ..add(ProSubscriptionStatusEnum.serializer)
      ..add(ProSubscriptionTierEnum.serializer)
      ..add(ProSubscriptionUpdateInput.serializer)
      ..add(ProSubscriptionUpdateInputBillingMethod.serializer)
      ..add(ProSubscriptionUpdateInputBillingMethodProviderEnum.serializer)
      ..add(ProVoucherCreateInput.serializer)
      ..add(ProfileOptions.serializer)
      ..add(ProfileOptionsContactChannelsEnum.serializer)
      ..add(ProfileOptionsLanguagesEnum.serializer)
      ..add(ProfileOptionsPaymentProvidersEnum.serializer)
      ..add(PushTokenInput.serializer)
      ..add(PushTokenInputPlatformEnum.serializer)
      ..add(RedeemVoucherInput.serializer)
      ..add(RefreshInput.serializer)
      ..add(RegisterInput.serializer)
      ..add(RegisterInputAnyOf.serializer)
      ..add(RegisterInputAnyOf1.serializer)
      ..add(RegisterInputAnyOf1DocumentsInner.serializer)
      ..add(RegisterInputAnyOf1HoursInner.serializer)
      ..add(RegisterInputAnyOf1Salon.serializer)
      ..add(RegisterInputAnyOf1ServicesInner.serializer)
      ..add(RegisterInputAnyOf1ServicesInnerDepositModeEnum.serializer)
      ..add(RegisterInputAnyOf1SubscriptionIntentTierEnum.serializer)
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
      ..add(UpdateMeInputPreferredContactChannelEnum.serializer)
      ..add(UpdateMeInputPreferredLanguageEnum.serializer)
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
          const FullType(BuiltList, const [
            const FullType(AdminSubscriptionDetailPendingChargesInner)
          ]),
          () => ListBuilder<AdminSubscriptionDetailPendingChargesInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(AdminSubscriptionListResponseItemsInner)]),
          () => ListBuilder<AdminSubscriptionListResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(ApiV1AdminMediaPendingGet200ResponseItemsInner)
          ]),
          () => ListBuilder<ApiV1AdminMediaPendingGet200ResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ApiV1AdminSalonsGet200ResponseItemsInner)]),
          () => ListBuilder<ApiV1AdminSalonsGet200ResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ApiV1AdminSalonsGet200ResponseItemsInner)]),
          () => ListBuilder<ApiV1AdminSalonsGet200ResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(ApiV1BookingsBookingIdReviewPost201Response)
          ]),
          () => ListBuilder<ApiV1BookingsBookingIdReviewPost201Response>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ApiV1MeAddressesGet200ResponseItemsInner)]),
          () => ListBuilder<ApiV1MeAddressesGet200ResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ApiV1MeBenefitsGet200ResponseItemsInner)]),
          () => ListBuilder<ApiV1MeBenefitsGet200ResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(ApiV1MePaymentMethodsGet200ResponseItemsInner)
          ]),
          () => ListBuilder<ApiV1MePaymentMethodsGet200ResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ApiV1MeVouchersGet200ResponseItemsInner)]),
          () => ListBuilder<ApiV1MeVouchersGet200ResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(ApiV1NotificationsGet200ResponseItemsInner)
          ]),
          () => ListBuilder<ApiV1NotificationsGet200ResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(
                ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner)
          ]),
          () => ListBuilder<
              ApiV1SalonsSalonIdPublicMediaGet200ResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(BookingSummaryListResponseItemsInner)]),
          () => ListBuilder<BookingSummaryListResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(PaydunyaMethodListResponseMethodsInner)]),
          () => ListBuilder<PaydunyaMethodListResponseMethodsInner>())
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
              const [const FullType(RegisterInputAnyOf1DocumentsInner)]),
          () => ListBuilder<RegisterInputAnyOf1DocumentsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(SalonSummaryListResponseItemsInner)]),
          () => ListBuilder<SalonSummaryListResponseItemsInner>())
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
              BuiltList, const [const FullType(ProfileOptionsLanguagesEnum)]),
          () => ListBuilder<ProfileOptionsLanguagesEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ProfileOptionsContactChannelsEnum)]),
          () => ListBuilder<ProfileOptionsContactChannelsEnum>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(ProfileOptionsPaymentProvidersEnum)]),
          () => ListBuilder<ProfileOptionsPaymentProvidersEnum>())
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
          const FullType(BuiltList, const [
            const FullType(ApiV1AdminSalonsPost201ResponseServicesInner)
          ]),
          () => ListBuilder<ApiV1AdminSalonsPost201ResponseServicesInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(ApiV1AdminSalonsPost201ResponseDocumentsInner)
          ]),
          () => ListBuilder<ApiV1AdminSalonsPost201ResponseDocumentsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(ApiV1AdminSalonsPost201ResponseServicesInner)
          ]),
          () => ListBuilder<ApiV1AdminSalonsPost201ResponseServicesInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [
            const FullType(ApiV1AdminSalonsPost201ResponseDocumentsInner)
          ]),
          () => ListBuilder<ApiV1AdminSalonsPost201ResponseDocumentsInner>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>())
      ..addBuilderFactory(
          const FullType(BuiltMap, const [
            const FullType(String),
            const FullType.nullable(JsonObject)
          ]),
          () => MapBuilder<String, JsonObject?>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
