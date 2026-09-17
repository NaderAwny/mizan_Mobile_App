import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/domain/use_case/logout_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/logout/logout_cubit/logout_state.dart';

@injectable
class LogoutCubit extends Cubit<LogoutState> {
  final LogoutUseCase _usecase;
  LogoutCubit(this._usecase) : super(const LogoutState());

  Future<void> logout() async {
    emit(state.copyWith(
      flowState: LoadingState(
        stateRendererType: StateRendererType.popupLoadingState,
      ),
    ));
    (await _usecase.execute(null)).fold(
      (failure) => emit(state.copyWith(
        flowState: ErrorState(
          StateRendererType.popupErrorStatete,
          failure.message,
        ),
      )),
      (_) => emit(state.copyWith(
        isLoggedOut: true,
        flowState: ContentState(),
      )),
    );
  }
}
