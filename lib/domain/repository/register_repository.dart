import 'package:dartz/dartz.dart';
import 'package:mizan/data/request/register_request.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/register_model.dart';

abstract class RegisterRepository {
  Future<Either<Failure, RegisterModel>> registerRepository(
    RegisterRequest registerRequest,
  );
}
