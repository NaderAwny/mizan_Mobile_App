import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/domain/use_case/select_user_type_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/select_user_type/select_user_type_cubit/select_user_type_state.dart';

@injectable
class SelectUserTypeCubit extends Cubit<SelectUserTypeState> {
  final SelectUserTypeUseCase _usecase;
  SelectUserTypeCubit(this._usecase) : super(const SelectUserTypeState());

  Future<void> selectUserType({
    required String userType,
    String? shopName,
    String? address,
  }) async {
    emit(state.copyWith(
      flowState: LoadingState(
        stateRendererType: StateRendererType.popupLoadingState,
        title: "جاري الحفظ",
        message: "جاري حفظ نوع الحساب المختار...",
      ),
    ));
    (await _usecase.execute(
      SelectUserTypeInput(userType, shopName: shopName, address: address),
    )).fold(
      (failure) => emit(state.copyWith(
        flowState: ErrorState(
          StateRendererType.popupErrorStatete,
          failure.message,
          title: "تعذر حفظ البيانات",
        ),
      )),
      (session) => emit(state.copyWith(
        data: session,
        flowState: ContentState(),
      )),
    );
  }
}
