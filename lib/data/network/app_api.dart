import 'package:dio/dio.dart';
import 'package:mizan/app/constants.dart';
import 'package:mizan/data/response/auth_session_responses/auth_session_responses.dart';
import 'package:mizan/data/response/base_responses/base_responses.dart';
import 'package:mizan/data/response/contact_responses/contact_responses.dart';
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

  // ======================== Contacts Endpoints ========================
  @POST("/api/contacts")
  Future<ContactResponse> createContact(
    @Field('name') String name,
    @Field('phoneNumber') String phoneNumber,
    @Field('notes') String? notes,
    @Field('isVip') bool? isVip,
    @Field('contactEmail') String? contactEmail,
  );

  @GET("/api/contacts")
  Future<ContactsPageResponse> getContacts(
    @Query("page") int page,
    @Query("pageSize") int pageSize,
    @Query("search") String? search,
  );

  // VIP endpoint placed before {id} to avoid collision
  @GET("/api/contacts/vip")
  Future<ContactsPageResponse> getVipContacts(
    @Query("page") int page,
    @Query("pageSize") int pageSize,
  );

  @GET("/api/contacts/{id}")
  Future<ContactResponse> getContactById(@Path("id") String id);

  @PATCH("/api/contacts/{id}/toggle-vip")
  Future<ContactResponse> toggleVip(@Path("id") String id);

  @GET("/api/contacts/{id}/transactions")
  Future<ContactProfileResponse> getContactProfile(@Path("id") String id);

  @PUT("/api/contacts/{id}")
  Future<ContactResponse> updateContact(
    @Path("id") String id,
    @Field('name') String name,
    @Field('phoneNumber') String phoneNumber,
    @Field('notes') String notes,
    @Field('isVip') bool isVip,
    @Field('contactEmail') String? contactEmail,
  );

  @DELETE("/api/contacts/{id}")
  Future<void> deleteContact(@Path("id") String id);
}
