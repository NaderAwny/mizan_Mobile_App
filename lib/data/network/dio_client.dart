// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/app/constants.dart';
import 'package:mizan/app/session_manager.dart';
import 'package:mizan/data/local/token_local_data_source.dart';
import 'package:mizan/data/network/auth_interceptor.dart';

const String APPLICATION_JSON = "application/json";
const String CONTENT_TYPE = "content-type";
const String ACCEPT = "accept";

@lazySingleton
class DioFactory {
  late final Dio dio;

  DioFactory(
    TokenLocalDataSource tokenLocalDataSource,
    SessionManager sessionManager,
  ) {
    final Map<String, String> headers = {
      CONTENT_TYPE: APPLICATION_JSON,
      ACCEPT: APPLICATION_JSON,
    };

    // authDio منفصل (بدون AuthInterceptor) لتجنب الـ loop عند refresh
    final authDio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
        headers: headers,
        connectTimeout: Duration(milliseconds: Constants.apiTimeOut),
        receiveTimeout: Duration(milliseconds: Constants.apiTimeOut),
        sendTimeout: Duration(milliseconds: Constants.apiTimeOut),
      ),
    );

    if (!kReleaseMode) {
      (authDio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
        headers: headers,
        connectTimeout: Duration(milliseconds: Constants.apiTimeOut),
        receiveTimeout: Duration(milliseconds: Constants.apiTimeOut),
        sendTimeout: Duration(milliseconds: Constants.apiTimeOut),
      ),
    );

    if (!kReleaseMode) {
      // Bypass SSL certificate errors in debug mode (e.g. self-signed / duckdns certs)
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        final client = HttpClient();
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };

      // Log all requests, responses and errors
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            debugPrint('┌── REQUEST ──────────────────────────');
            debugPrint('│ URL: ${options.baseUrl}${options.path}');
            debugPrint('│ Method: ${options.method}');
            debugPrint('│ Data: ${options.data}');
            debugPrint('└─────────────────────────────────────');
            handler.next(options);
          },
          onResponse: (response, handler) {
            debugPrint('┌── RESPONSE ─────────────────────────');
            debugPrint('│ Status: ${response.statusCode}');
            debugPrint('│ Data: ${response.data}');
            debugPrint('└─────────────────────────────────────');
            handler.next(response);
          },
          onError: (error, handler) {
            debugPrint('┌── ERROR ────────────────────────────');
            debugPrint('│ Type: ${error.type}');
            debugPrint('│ Message: ${error.message}');
            debugPrint('│ Status: ${error.response?.statusCode}');
            debugPrint('│ Data: ${error.response?.data}');
            debugPrint('│ Error: ${error.error}');
            debugPrint('└─────────────────────────────────────');
            handler.next(error);
          },
        ),
      );
    }

    // AuthInterceptor على الـ dio الرئيسي فقط
    dio.interceptors.add(
      AuthInterceptor(
        tokenLocalDataSource: tokenLocalDataSource,
        authDio: authDio,
        sessionManager: sessionManager,
      ),
    );
  }
}
