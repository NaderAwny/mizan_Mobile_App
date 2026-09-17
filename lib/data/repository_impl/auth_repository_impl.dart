import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/data_source/auth_remote_data_source.dart';
import 'package:mizan/data/local/token_local_data_source.dart';
import 'package:mizan/data/mapper/auth_session_mappr.dart';
import 'package:mizan/data/network/error_handler.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/data/network/network_info.dart';
import 'package:mizan/domain/model/auth_session_model/auth_session_model.dart';
import 'package:mizan/domain/repository/auth_repository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remote;
  final NetworkInfo _networkInfo;
  final TokenLocalDataSource _tokenLocalDataSource;

  AuthRepositoryImpl(this._remote, this._networkInfo, this._tokenLocalDataSource);

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() call) async {
    if (!await _networkInfo.isConnected) {
      return Left(DataSource.NO_INTERNET_CONNECTION.getFailure());
    }
    try {
      return Right(await call());
    } catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }

  @override
  Future<Either<Failure, AuthSession>> verifyOtp({
    required String email,
    required String code,
  }) =>
      _guard(() async {
        final r = await _remote.verifyOtp({'email': email, 'code': code});
        if (r.success != true) throw Exception(r.message ?? ResponseMessage.DEAFULT);
        final session = r.data!.toDomain();
        await _tokenLocalDataSource.saveSession(
          accessToken: session.token,
          refreshToken: session.refreshToken,
          expiresInSeconds: session.expiresInSeconds,
        );
        return session;
      });

  @override
  Future<Either<Failure, AuthSession>> selectUserType({
    required String userType,
    String? shopName,
    String? address,
  }) =>
      _guard(() async {
        final r = await _remote.selectUserType({
          'userType': userType,
          'shopName': ?shopName,
          'address': ?address,
        });
        if (r.success != true) throw Exception(r.message ?? ResponseMessage.DEAFULT);
        final session = r.data!.toDomain();
        await _tokenLocalDataSource.saveSession(
          accessToken: session.token,
          refreshToken: session.refreshToken,
          expiresInSeconds: session.expiresInSeconds,
        );
        return session;
      });

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      final refreshToken = await _tokenLocalDataSource.getRefreshToken();
      if (refreshToken != null) {
        await _remote.logout({'refreshToken': refreshToken});
      }
    } catch (_) {
      // حتى لو السيرفر رفض، لازم نمسح محليًا عشان المستخدم يعرف يخرج فعليًا.
    } finally {
      await _tokenLocalDataSource.clear();
    }
    return const Right(null);
  }
}
