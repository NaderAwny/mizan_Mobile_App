import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/app_api.dart';
import 'package:mizan/data/network/dio_client.dart';

@module
abstract class AppModule {
  @lazySingleton
  InternetConnectionChecker get internetConnectionChecker =>
      InternetConnectionChecker.createInstance(
        addresses: [
          AddressCheckOption(
            uri: Uri.parse('https://google.com'),
            timeout: const Duration(seconds: 5),
          ),
          AddressCheckOption(
            uri: Uri.parse('https://cloudflare.com'),
            timeout: const Duration(seconds: 5),
          ),
          AddressCheckOption(
            uri: Uri.parse('https://example.com'),
            timeout: const Duration(seconds: 5),
          ),
        ],
      );

  @lazySingleton
  FlutterSecureStorage get provideSecureStorage => const FlutterSecureStorage();

  @lazySingleton
  Dio dio(DioFactory dioFactory) => dioFactory.dio;

  @lazySingleton
  AppServiceClient appServiceClient(Dio dio) => AppServiceClient(dio);
}
