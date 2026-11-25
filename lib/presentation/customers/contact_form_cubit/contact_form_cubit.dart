import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/data/network/failure.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/domain/use_case/create_contact_use_case.dart';
import 'package:mizan/domain/use_case/update_contact_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/customers/contact_form_cubit/contact_form_state.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';

@injectable
class ContactFormCubit extends Cubit<ContactFormState> {
  final CreateContactUseCase _createContactUseCase;
  final UpdateContactUseCase _updateContactUseCase;

  Contact? _initialContact;

  ContactFormCubit(this._createContactUseCase, this._updateContactUseCase)
    : super(const ContactFormState());

  void init(Contact? contact) {
    _initialContact = contact;
    emit(
      state.copyWith(
        isEditMode: contact != null,
        isVip: contact?.isVip ?? false,
        flowState: ContentState(),
      ),
    );
  }

  void toggleVip(bool val) => emit(state.copyWith(isVip: val));

  bool _isLettersOnly(String str) {
    // Allows Arabic characters, English letters, and spaces
    final RegExp letterRegex = RegExp(r'^[\p{L}\s]+$', unicode: true);
    return letterRegex.hasMatch(str.trim());
  }

  Future<void> submit({
    required String name,
    required String phoneNumber,
    String? notes,
    bool isVip = false,
    String contactEmail = '',
  }) async {
    final String trimmedName = name.trim();
    final String trimmedPhone = phoneNumber.trim();

    if (trimmedName.isEmpty) {
      emit(
        state.copyWith(
          flowState: ErrorState(
            StateRendererType.popupErrorStatete,
            "يرجى إدخال اسم الطرف",
            title: "حقل مطلوب",
          ),
        ),
      );
      return;
    }

    if (!_isLettersOnly(trimmedName)) {
      emit(
        state.copyWith(
          flowState: ErrorState(
            StateRendererType.popupErrorStatete,
            AppStrings.nameLettersOnly,
            title: "خطأ في الاسم",
          ),
        ),
      );
      return;
    }

    if (trimmedPhone.isEmpty) {
      emit(
        state.copyWith(
          flowState: ErrorState(
            StateRendererType.popupErrorStatete,
            "يرجى إدخال رقم الهاتف",
            title: "حقل مطلوب",
          ),
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        flowState: LoadingState(
          stateRendererType: StateRendererType.popupLoadingState,
          title: AppStrings.loading,
          message: _initialContact == null
              ? "جاري إضافة الطرف..."
              : "جاري تعديل بيانات الطرف...",
        ),
      ),
    );

    if (_initialContact == null) {
      // Create Contact
      final Either<Failure, Contact> result = await _createContactUseCase
          .execute(
            CreateContactInput(
              trimmedName,
              trimmedPhone,
              notes?.trim(),
              isVip,
              contactEmail.trim(),
            ),
          );

      result.fold(
        (Failure failure) {
          if (isClosed) return;
          emit(
            state.copyWith(
              flowState: ErrorState(
                StateRendererType.popupErrorStatete,
                failure.message,
                title: "تعذر إضافة الطرف",
              ),
            ),
          );
        },
        (Contact contact) {
          if (isClosed) return;
          emit(
            state.copyWith(
              savedContact: contact,
              isActionSuccess: true,
              flowState: ContentState(),
            ),
          );
        },
      );
    } else {
      // Update Contact (Full body)
      final Either<Failure, Contact> result = await _updateContactUseCase
          .execute(
            UpdateContactInput(
              _initialContact!.id,
              trimmedName,
              trimmedPhone,
              notes?.trim(),
              isVip,
              contactEmail.trim(),
            ),
          );

      result.fold(
        (Failure failure) {
          if (isClosed) return;
          emit(
            state.copyWith(
              flowState: ErrorState(
                StateRendererType.popupErrorStatete,
                failure.message,
                title: "تعذر تعديل بيانات الطرف",
              ),
            ),
          );
        },
        (Contact contact) {
          if (isClosed) return;
          emit(
            state.copyWith(
              savedContact: contact,
              isActionSuccess: true,
              flowState: ContentState(),
            ),
          );
        },
      );
    }
  }
}
