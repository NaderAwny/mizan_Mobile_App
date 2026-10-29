import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/get_profile_model/get_profile_model.dart';
import 'package:mizan/domain/use_case/get_profile_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/get_profile/cubit/get_profile_state.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';

@lazySingleton
class GetProfileCubit extends Cubit<GetProfileState> {
  final GetProfileUsecase _getProfileUsecase;

  GetProfileCubit(this._getProfileUsecase) : super(const GetProfileState());

  Future<void> getProfile() async {
    if (isClosed) return;
    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.fullScreenLoadingState,
          title: AppStrings.loading,
          message: 'جار تحميل البايانات جلب معلومات الملف الشخصى ',
        ),
      ),
    );

    final Either<Failure, GetProfileModel> result = await _getProfileUsecase
        .execute(null);

    result.fold(
      (Failure failure) {
        if (isClosed) return;
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.fullScreenErrorState,
              failure.message,
              title: 'خطاء في جلب البايانات ',
            ),
          ),
        );
      },
      (GetProfileModel profile) {
        if (isClosed) return;
        emit(state.copyWith(data: profile, flowState: ContentState()));
      },
    );
  }
}
