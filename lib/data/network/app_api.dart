import 'package:dio/dio.dart';
import 'package:mizan/app/constants.dart';
import 'package:mizan/data/response/auth_session_responses/auth_session_responses.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';
import 'package:mizan/data/response/register_responses/register_responses.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part "app_api.g.dart";

@RestApi(baseUrl: Constants.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  // register وsend-otp — يستخدمون @Field (الطريقة الأصلية في المشروع)
  @POST("/api/auth/register")
  Future<RegisterDataResponse> register(
    @Field('email') String email,
    @Field('firstName') String firstName,
    @Field('lastName') String lastName,
  );

  @POST("/api/auth/send-otp")
  Future<RegisterDataResponse> sendOtp(@Field('email') String email);

  // العمليات الجديدة — @Body() Map (نمط AuthRemoteDataSource)
  @POST("/api/auth/verify-otp")
  Future<AuthSessionResponse> verifyOtp(@Body() Map<String, dynamic> body);

  @POST("/api/auth/select-user-type")
  Future<AuthSessionResponse> selectUserType(@Body() Map<String, dynamic> body);

  @POST("/api/auth/logout")
  Future<BaseResponse> logout(@Body() Map<String, dynamic> body);
}
