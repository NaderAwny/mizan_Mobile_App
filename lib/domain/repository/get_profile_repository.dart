import 'package:dartz/dartz.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/get_profile_model/get_profile_model.dart';

abstract class GetProfileRepository {
  Future<Either<Failure, GetProfileModel>> getProfile();
}
