// ignore_for_file: constant_identifier_names, non_constant_identifier_names

import 'package:dio/dio.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';

// step 5
class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = _handleError(error);
    } else if (error is Failure) {
      failure = error;
    } else if (error is Exception) {
      final msg = error.toString().replaceFirst('Exception: ', '').trim();
      failure = Failure(
        ResponseCode.DEAFULT,
        msg.isNotEmpty ? _localizeErrorMessage(msg) : ResponseMessage.DEAFULT,
      );
    } else if (error is String && error.trim().isNotEmpty) {
      failure = Failure(ResponseCode.DEAFULT, _localizeErrorMessage(error.trim()));
    } else {
      failure = DataSource.DEFAULT.getFailure();
    }
  }
}

// step 6
Failure _handleError(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.SEND_TIMEOUT.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    case DioExceptionType.badCertificate:
      return DataSource.DEFAULT.getFailure();
    case DioExceptionType.badResponse:
      final statusCode = error.response?.statusCode ?? 0;
      final responseData = error.response?.data;

      // 1. Try to extract server-provided error or validation message
      final extractedMessage = _extractErrorMessage(responseData);
      if (extractedMessage != null && extractedMessage.trim().isNotEmpty) {
        return Failure(
          statusCode,
          _localizeErrorMessage(extractedMessage.trim()),
        );
      }

      // 2. Fallback to friendly message by HTTP status code
      return _getFailureByStatusCode(statusCode);

    case DioExceptionType.cancel:
      return DataSource.CANCEL.getFailure();
    case DioExceptionType.connectionError:
      return DataSource.NO_INTERNET_CONNECTION.getFailure();
    case DioExceptionType.unknown:
      return DataSource.DEFAULT.getFailure();
    case DioExceptionType.transformTimeout:
      return DataSource.CONNECT_TIMEOUT.getFailure();
  }
}

/// Extract clean, readable error message from API response data (Map, List, or String)
String? _extractErrorMessage(dynamic data) {
  if (data == null) return null;

  if (data is Map) {
    // Check validation errors dictionary first if message is generic
    final rawMsg = data['message']?.toString();
    final hasSpecificErrors = data['errors'] != null;

    if (hasSpecificErrors) {
      final errorsMsg = _extractFromErrors(data['errors']);
      if (errorsMsg != null && errorsMsg.isNotEmpty) {
        return errorsMsg;
      }
    }

    // Check message field
    if (rawMsg != null && rawMsg.trim().isNotEmpty) {
      return rawMsg.trim();
    }

    // Check error field
    final err = data['error'];
    if (err is String && err.trim().isNotEmpty) {
      return err.trim();
    } else if (err is Map && err['message'] != null) {
      return err['message'].toString().trim();
    }

    // Check detail or msg field
    if (data['detail'] != null && data['detail'].toString().trim().isNotEmpty) {
      return data['detail'].toString().trim();
    }
    if (data['msg'] != null && data['msg'].toString().trim().isNotEmpty) {
      return data['msg'].toString().trim();
    }
  } else if (data is String) {
    final trimmed = data.trim();
    if (trimmed.isNotEmpty &&
        !trimmed.startsWith('<!DOCTYPE') &&
        !trimmed.startsWith('<html')) {
      return trimmed;
    }
  }
  return null;
}

/// Extract errors from validation errors payload (e.g. Laravel {"email": ["..."]})
String? _extractFromErrors(dynamic errors) {
  if (errors is Map) {
    final messages = <String>[];
    for (final entry in errors.entries) {
      final val = entry.value;
      if (val is List && val.isNotEmpty) {
        messages.addAll(val.map((e) => e.toString().trim()));
      } else if (val is String && val.trim().isNotEmpty) {
        messages.add(val.trim());
      }
    }
    if (messages.isNotEmpty) {
      return messages.join('\n');
    }
  } else if (errors is List && errors.isNotEmpty) {
    return errors.map((e) => e.toString().trim()).join('\n');
  }
  return null;
}

/// Translate or map common technical/English messages into friendly Arabic
String _localizeErrorMessage(String rawMsg) {
  final lower = rawMsg.toLowerCase();

  // Email validation errors
  if (lower.contains('email') &&
      (lower.contains('invalid') ||
          lower.contains('not valid') ||
          lower.contains('must be a valid'))) {
    return "البريد الإلكتروني المدخل غير صالح، يرجى التأكد من كتابته بشكل صحيح (مثال: user@example.com).";
  }
  if (lower.contains('email') &&
      (lower.contains('taken') ||
          lower.contains('exists') ||
          lower.contains('already registered') ||
          lower.contains('already been taken'))) {
    return "البريد الإلكتروني مسجل مسبقاً، يرجى تسجيل الدخول أو استخدام بريد آخر.";
  }
  if (lower.contains('user not found') ||
      lower.contains('account not found') ||
      (lower.contains('email') && lower.contains('not found'))) {
    return "البريد الإلكتروني غير مسجل، يرجى إنشاء حساب جديد أولاً.";
  }

  // OTP / Verification Code errors
  if (lower.contains('invalid otp') ||
      lower.contains('otp is invalid') ||
      lower.contains('invalid code') ||
      lower.contains('wrong code') ||
      lower.contains('code is invalid')) {
    return "رمز التحقق غير صحيح، يرجى التأكد من الأرقام وإعادة المحاولة.";
  }
  if (lower.contains('expired') &&
      (lower.contains('otp') || lower.contains('code'))) {
    return "انتهت صلاحية رمز التحقق، يرجى طلب إرسال رمز جديد.";
  }

  // Rate limits
  if (lower.contains('too many requests') || lower.contains('rate limit')) {
    return "تم تجاوز عدد المحاولات المسموح بها، يرجى الانتظار قليلاً ثم المحاولة مجدداً.";
  }

  // Auth / Session
  if (lower.contains('unauthenticated') ||
      lower.contains('token expired') ||
      lower.contains('unauthorized')) {
    return "انتهت صلاحية الجلسة، يرجى تسجيل الدخول مجدداً.";
  }

  // Network / Connection
  if (lower.contains('network') ||
      lower.contains('socket') ||
      lower.contains('connection refused')) {
    return "تعذر الاتصال بالخادم، يرجى التحقق من اتصالك بالإنترنت.";
  }

  return rawMsg;
}

/// Fallback friendly messages by HTTP status code
Failure _getFailureByStatusCode(int statusCode) {
  switch (statusCode) {
    case ResponseCode.BAD_REQUEST: // 400
      return Failure(
        statusCode,
        "البيانات المدخلة غير صحيحة، يرجى مراجعة المدخلات والتأكد من صحتها.",
      );
    case ResponseCode.UNAUTORISED: // 401
      return Failure(
        statusCode,
        "غير مصرح بالدخول، يرجى التحقق من بياناتك أو إعادة تسجيل الدخول.",
      );
    case ResponseCode.FORBIDDEN: // 403
      return Failure(
        statusCode,
        "ليس لديك الصلاحية لتنفيذ هذا الإجراء.",
      );
    case ResponseCode.NOT_FOUND: // 404
      return Failure(
        statusCode,
        "الحساب أو العنصر المطلوب غير موجود في النظام.",
      );
    case 409:
      return Failure(
        409,
        "البيانات المدخلة (كالبريد الإلكتروني) مسجلة مسبقاً في النظام.",
      );
    case 422:
      return Failure(
        422,
        "البيانات المدخلة غير صالحة، يرجى التأكد من صحة البريد الإلكتروني والحقول.",
      );
    case 429:
      return Failure(
        429,
        "تم تجاوز عدد المحاولات المسموح بها، يرجى الانتظار قليلاً.",
      );
    case ResponseCode.INTERNAL_SERVER_ERROR: // 500
      return Failure(
        statusCode,
        "حدث خطأ غير متوقع في خادم النظام، يرجى المحاولة بعد قليل.",
      );
    case 502:
    case 503:
    case 504:
      return Failure(
        statusCode,
        "الخدمة غير متوفرة مؤقتاً بسبب أعمال الصيانة، يرجى المحاولة لاحقاً.",
      );
    default:
      return DataSource.DEFAULT.getFailure();
  }
}

//step1
enum DataSource {
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNAL_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT,
}

// step 4
extension DataSourceExtesion on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.SUCCESS:
        return Failure(ResponseCode.SUCCESS, ResponseMessage.SUCCESS);
      case DataSource.NO_CONTENT:
        return Failure(ResponseCode.NO_CONTENT, ResponseMessage.NO_CONTENT);
      case DataSource.BAD_REQUEST:
        return Failure(ResponseCode.BAD_REQUEST, ResponseMessage.BAD_REQUEST);
      case DataSource.FORBIDDEN:
        return Failure(ResponseCode.FORBIDDEN, ResponseMessage.FORBIDDEN);
      case DataSource.UNAUTORISED:
        return Failure(ResponseCode.UNAUTORISED, ResponseMessage.UNAUTORISED);
      case DataSource.NOT_FOUND:
        return Failure(ResponseCode.NOT_FOUND, ResponseMessage.NOT_FOUND);
      case DataSource.INTERNAL_SERVER_ERROR:
        return Failure(
          ResponseCode.INTERNAL_SERVER_ERROR,
          ResponseMessage.INTERNAL_SERVER_ERROR,
        );
      case DataSource.CONNECT_TIMEOUT:
        return Failure(
          ResponseCode.CONNECT_TIMEOUT,
          ResponseMessage.CONNECT_TIMEOUT,
        );
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL);
      case DataSource.RECIEVE_TIMEOUT:
        return Failure(
          ResponseCode.RECIEVE_TIMEOUT,
          ResponseMessage.RECIEVE_TIMEOUT,
        );
      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT);
      case DataSource.CACHE_ERROR:
        return Failure(ResponseCode.CACHE_ERROR, ResponseMessage.CACHE_ERROR);
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(
          ResponseCode.NO_INTERNET_CONNECTION,
          ResponseMessage.NO_INTERNET_CONNECTION,
        );
      case DataSource.DEFAULT:
        return Failure(ResponseCode.DEAFULT, ResponseMessage.DEAFULT);
    }
  }
}

//step 2
class ResponseCode {
  static const int SUCCESS = 200; // success with data
  static const int NO_CONTENT = 201; // success with no data (no content)
  static const int BAD_REQUEST = 400; // failure, API rejected request
  static const int UNAUTORISED = 401; // failure, user is not authorised
  static const int FORBIDDEN = 403; //  failure, API rejected request
  static const int INTERNAL_SERVER_ERROR = 500; // failure, crash in server side
  static const int NOT_FOUND = 404;
  // local status code
  static const int CONNECT_TIMEOUT = -1;
  static const int CANCEL = -2;
  static const int RECIEVE_TIMEOUT = -3;
  static const int SEND_TIMEOUT = -4;
  static const int CACHE_ERROR = -5;
  static const int NO_INTERNET_CONNECTION = -6;
  static const int DEAFULT = -7;
}

//step 3
class ResponseMessage {
  static String SUCCESS = AppStrings.success;
  static String NO_CONTENT = AppStrings.noContent;
  static String BAD_REQUEST =
      "البيانات المدخلة غير صحيحة، يرجى مراجعة الحقول والمحاولة مجدداً.";
  static String UNAUTORISED =
      "غير مصرح بالدخول، يرجى تسجيل الدخول مجدداً.";
  static String FORBIDDEN =
      "ليس لديك الصلاحية لتنفيذ هذا الإجراء.";
  static String INTERNAL_SERVER_ERROR =
      "حدث خطأ في خادم النظام، يرجى المحاولة لاحقاً.";
  static String NOT_FOUND =
      "الحساب أو العنصر المطلوب غير موجود.";
  static String CONNECT_TIMEOUT =
      "انتهت مهلة الاتصال بالخادم، يرجى التأكد من اتصال الإنترنت.";
  static String CANCEL =
      "تم إلغاء العملية.";
  static String RECIEVE_TIMEOUT =
      "استغرق الخادم وقتاً أطول للاستجابة، يرجى إعادة المحاولة.";
  static String SEND_TIMEOUT =
      "انتهت مهلة إرسال البيانات، يرجى إعادة المحاولة.";
  static String CACHE_ERROR =
      AppStrings.cacheError;
  static String NO_INTERNET_CONNECTION =
      "لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة.";
  static String DEAFULT =
      "حدث خطأ غير متوقع، يرجى التحقق من البيانات والمحاولة لاحقاً.";
}

class ApiInternalStatus {
  static const int SUCCESS = 1;
  static const int FAILURE = 0;
}
