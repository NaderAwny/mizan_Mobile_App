import 'package:dartz/dartz.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/auth_session_model/auth_session_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthSession>> verifyOtp({
    required String email,
    required String code,
  });
  Future<Either<Failure, AuthSession>> selectUserType({
    required String userType,
    String? shopName,
    String? address,
  });
  Future<Either<Failure, void>> logout();
}
