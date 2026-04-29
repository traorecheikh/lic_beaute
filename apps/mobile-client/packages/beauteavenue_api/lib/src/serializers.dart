//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_import

import 'package:one_of_serializer/any_of_serializer.dart';
import 'package:one_of_serializer/one_of_serializer.dart';
import 'package:built_collection/built_collection.dart';
import 'package:built_value/json_object.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:built_value/iso_8601_date_time_serializer.dart';
import 'package:beauteavenue_api/src/date_serializer.dart';
import 'package:beauteavenue_api/src/model/date.dart';

import 'package:beauteavenue_api/src/model/api_error.dart';
import 'package:beauteavenue_api/src/model/auth_session.dart';
import 'package:beauteavenue_api/src/model/booking_create_input.dart';
import 'package:beauteavenue_api/src/model/booking_summary.dart';
import 'package:beauteavenue_api/src/model/booking_summary_list_response.dart';
import 'package:beauteavenue_api/src/model/booking_summary_list_response_items_inner.dart';
import 'package:beauteavenue_api/src/model/current_user.dart';
import 'package:beauteavenue_api/src/model/email_login_input.dart';
import 'package:beauteavenue_api/src/model/health_get200_response.dart';
import 'package:beauteavenue_api/src/model/logout_response.dart';
import 'package:beauteavenue_api/src/model/otp_request_input.dart';
import 'package:beauteavenue_api/src/model/otp_verify_input.dart';
import 'package:beauteavenue_api/src/model/salon_detail.dart';
import 'package:beauteavenue_api/src/model/salon_detail_services_inner.dart';
import 'package:beauteavenue_api/src/model/salon_summary.dart';
import 'package:beauteavenue_api/src/model/salon_summary_list_response.dart';
import 'package:beauteavenue_api/src/model/salon_summary_list_response_items_inner.dart';

part 'serializers.g.dart';

@SerializersFor([
  ApiError,
  AuthSession,
  BookingCreateInput,
  BookingSummary,
  BookingSummaryListResponse,
  BookingSummaryListResponseItemsInner,
  CurrentUser,
  EmailLoginInput,
  HealthGet200Response,
  LogoutResponse,
  OtpRequestInput,
  OtpVerifyInput,
  SalonDetail,
  SalonDetailServicesInner,
  SalonSummary,
  SalonSummaryListResponse,
  SalonSummaryListResponseItemsInner,
])
Serializers serializers = (_$serializers.toBuilder()
      ..add(const OneOfSerializer())
      ..add(const AnyOfSerializer())
      ..add(const DateSerializer())
      ..add(Iso8601DateTimeSerializer())
    ).build();

Serializers standardSerializers =
    (serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();
