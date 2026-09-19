import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/get_profile_model/get_profile_model.dart';
import 'package:mizan/domain/repository/get_profile_repository.dart';
import 'package:mizan/domain/use_case/base_usecase.dart';

@injectable
class GetProfileUsecase implements BaseUsecase<void, GetProfileModel> {
  final GetProfileRepository _getProfileRepository;
  GetProfileUsecase(this._getProfileRepository);
  @override
  Future<Either<Failure, GetProfileModel>> execute(void input) async {
    return await _getProfileRepository.getProfile();
  }
}
