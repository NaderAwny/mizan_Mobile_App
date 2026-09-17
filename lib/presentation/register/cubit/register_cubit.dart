// ignore_for_file: body_might_complete_normally_nullable
import 'package:emails_validator/emails_validator.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/app/funcation.dart';
import 'package:mizan/data/request/register_request.dart';
import 'package:mizan/domain/use_case/register_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/register/cubit/register_state.dart';

@injectable
class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUseCase registerUseCase;
  RegisterCubit(this.registerUseCase) : super(const RegisterState());

  void register() async {
    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          title: "جاري التسجيل",
          message: "جاري إنشاء الحساب الخاص بك...",
        ),
      ),
    );

    (await registerUseCase.execute(
      RegisterRequest(
        email: state.email,
        firstName: state.firstName,
        lastName: state.lastName,
      ),
    )).fold(
      (failure) => {
        // left -> failure
        emit(
          state.copyWith(
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
              title: "تعذر إنشاء الحساب",
            ),
          ),
        ),
        // ignore: avoid_print
        print(failure.message),
      },
      (data) => {
        // right -> data (success)
        emit(
          state.copyWith(
            flowState: ContentState(),
            registerSuccess: true,
          ),
        ),
      },
    );
  }

  void resetSuccess() {
    emit(state.copyWith(registerSuccess: false, flowState: ContentState()));
  }

  void setEmail(String email) {
    final valid = isEmailValid(email);
    final newState = state.copyWith(
      email: email,
      isEmailValid: valid,
      registerSuccess: false,
    );
    emit(
      newState.copyWith(
        email: email,
        firstName: newState.firstName,
        lastName: newState.lastName,
        registerSuccess: false,
        isEmailValid: isEmailValid(email),
        isAllValid: validateAllInputs(
          email,
          newState.firstName,
          newState.lastName,
        ),
      ),
    );
  }

  void setFirstName(String firstName) {
    final valid = validateFirstName(firstName);
    emit(
      state.copyWith(
        firstName: firstName,
        registerSuccess: false,
        isFirstNameValid: valid,
        isAllValid: validateAllInputs(state.email, firstName, state.lastName),
        email: state.email,
        lastName: state.lastName,
      ),
    );
  }

  void setLastName(String lastName) {
    final valid = validateLastName(lastName);
    emit(
      state.copyWith(
        lastName: lastName,
        registerSuccess: false,
        isLastNameValid: valid,
        isAllValid: validateAllInputs(state.email, state.firstName, lastName),
        email: state.email,
        firstName: state.firstName,
      ),
    );
  }

  bool isEmailValid(String email) {
    return EmailsValidator.validate(email);
  }

  bool validateFirstName(String firstName) {
    if (isValidName(firstName)) {
      return true;
    }
    return false;
  }

  bool validateLastName(String lastName) {
    if (isValidName(lastName)) {
      return true;
    }
    return false;
  }

  bool validateAllInputs(String email, String firstName, String lastName) {
    return isEmailValid(email) &&
        validateFirstName(firstName) &&
        validateLastName(lastName);
  }
}
