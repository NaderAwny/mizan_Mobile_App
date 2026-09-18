import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
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

  ContactFormCubit(
    this._createContactUseCase,
    this._updateContactUseCase,
  ) : super(const ContactFormState());

  void init(Contact? contact) {
    _initialContact = contact;
    emit(state.copyWith(
      isEditMode: contact != null,
      flowState: ContentState(),
    ));
  }

  bool _isLettersOnly(String str) {
    // Allows Arabic characters, English letters, and spaces
    final letterRegex = RegExp(r'^[\p{L}\s]+$', unicode: true);
    return letterRegex.hasMatch(str.trim());
  }

  Future<void> submit({
    required String name,
    required String phoneNumber,
    String? notes,
    bool isVip = false,
    String contactEmail = '',
  }) async {
    final trimmedName = name.trim();
    final trimmedPhone = phoneNumber.trim();

    if (trimmedName.isEmpty) {
      emit(state.copyWith(
        flowState: ErrorState(
          StateRendererType.popupErrorStatete,
          "يرجى إدخال اسم الطرف",
          title: "حقل مطلوب",
        ),
      ));
      return;
    }

    if (!_isLettersOnly(trimmedName)) {
      emit(state.copyWith(
        flowState: ErrorState(
          StateRendererType.popupErrorStatete,
          AppStrings.nameLettersOnly,
          title: "خطأ في الاسم",
        ),
      ));
      return;
    }

    if (trimmedPhone.isEmpty) {
      emit(state.copyWith(
        flowState: ErrorState(
          StateRendererType.popupErrorStatete,
          "يرجى إدخال رقم الهاتف",
          title: "حقل مطلوب",
        ),
      ));
      return;
    }

    emit(state.copyWith(
      flowState: LoadingState(
        stateRendererType: StateRendererType.popupLoadingState,
        title: AppStrings.loading,
        message: _initialContact == null ? "جاري إضافة الطرف..." : "جاري تعديل بيانات الطرف...",
      ),
    ));

    if (_initialContact == null) {
      // Create Contact
      final result = await _createContactUseCase.execute(
        CreateContactInput(
          name: trimmedName,
          phoneNumber: trimmedPhone,
          notes: notes?.trim(),
        ),
      );

      result.fold(
        (failure) {
          if (isClosed) return;
          emit(state.copyWith(
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
              title: "تعذر إضافة الطرف",
            ),
          ));
        },
        (contact) {
          if (isClosed) return;
          emit(state.copyWith(
            savedContact: contact,
            isActionSuccess: true,
            flowState: ContentState(),
          ));
        },
      );
    } else {
      // Update Contact (Full body)
      final result = await _updateContactUseCase.execute(
        UpdateContactInput(
          id: _initialContact!.id,
          name: trimmedName,
          phoneNumber: trimmedPhone,
          notes: notes?.trim() ?? '',
          isVip: isVip,
          contactEmail: contactEmail.trim(),
        ),
      );

      result.fold(
        (failure) {
          if (isClosed) return;
          emit(state.copyWith(
            flowState: ErrorState(
              StateRendererType.popupErrorStatete,
              failure.message,
              title: "تعذر تعديل بيانات الطرف",
            ),
          ));
        },
        (contact) {
          if (isClosed) return;
          emit(state.copyWith(
            savedContact: contact,
            isActionSuccess: true,
            flowState: ContentState(),
          ));
        },
      );
    }
  }
}
