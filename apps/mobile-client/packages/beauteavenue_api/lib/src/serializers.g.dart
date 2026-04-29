// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'serializers.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializers _$serializers = (Serializers().toBuilder()
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
      ..add(EmailLoginInput.serializer)
      ..add(HealthGet200Response.serializer)
      ..add(LogoutResponse.serializer)
      ..add(OtpRequestInput.serializer)
      ..add(OtpVerifyInput.serializer)
      ..add(SalonDetail.serializer)
      ..add(SalonDetailServicesInner.serializer)
      ..add(SalonDetailSubscriptionTierEnum.serializer)
      ..add(SalonSummary.serializer)
      ..add(SalonSummaryListResponse.serializer)
      ..add(SalonSummaryListResponseItemsInner.serializer)
      ..add(SalonSummaryListResponseItemsInnerSubscriptionTierEnum.serializer)
      ..add(SalonSummarySubscriptionTierEnum.serializer)
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(BookingSummaryListResponseItemsInner)]),
          () => ListBuilder<BookingSummaryListResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList,
              const [const FullType(SalonSummaryListResponseItemsInner)]),
          () => ListBuilder<SalonSummaryListResponseItemsInner>())
      ..addBuilderFactory(
          const FullType(BuiltList, const [const FullType(String)]),
          () => ListBuilder<String>())
      ..addBuilderFactory(
          const FullType(
              BuiltList, const [const FullType(SalonDetailServicesInner)]),
          () => ListBuilder<SalonDetailServicesInner>()))
    .build();

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
