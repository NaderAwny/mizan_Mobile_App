import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:mizan/domain/model/contact_model.dart';
import 'package:mizan/domain/use_case/delete_contact_use_case.dart';
import 'package:mizan/domain/use_case/get_contact_profile_use_case.dart';
import 'package:mizan/domain/use_case/toggle_vip_contact_use_case.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer.dart';
import 'package:mizan/presentation/common/state_randrer/state_randrer_impl.dart';
import 'package:mizan/presentation/customers/contact_profile_cubit/contact_profile_state.dart';
import 'package:mizan/presentation/resources/strings_manager.dart';

@injectable
class ContactProfileCubit extends Cubit<ContactProfileState> {
  final GetContactProfileUseCase _getContactProfileUseCase;
  final ToggleVipContactUseCase _toggleVipContactUseCase;
  final DeleteContactUseCase _deleteContactUseCase;

  ContactProfileCubit(
    this._getContactProfileUseCase,
    this._toggleVipContactUseCase,
    this._deleteContactUseCase,
  ) : super(const ContactProfileState());

  Future<void> getProfile(String contactId) async {
    emit(state.copyWith(
      flowState: LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState,
        title: AppStrings.loading,
        message: "جاري جلب سجل الطرف المالي...",
      ),
    ));

    final result = await _getContactProfileUseCase.execute(contactId);

    result.fold(
      (failure) {
        if (isClosed) return;
        emit(state.copyWith(
          flowState: ErrorState(
            StateRendererType.fullScreenErrorState,
            failure.message,
            title: "تعذر تحميل ملف الطرف",
          ),
        ));
      },
      (profile) {
        if (isClosed) return;
        emit(state.copyWith(
          data: profile,
          flowState: ContentState(),
        ));
      },
    );
  }

  Future<void> toggleVip() async {
    final profile = state.data;
    if (profile == null) return;

    final updatedProfile = ContactProfile(
      contactId: profile.contactId,
      contactName: profile.contactName,
      phoneNumber: profile.phoneNumber,
      contactEmail: profile.contactEmail,
      isVip: !profile.isVip,
      totalTransactions: profile.totalTransactions,
      totalAmount: profile.totalAmount,
      transactions: profile.transactions,
    );

    emit(state.copyWith(data: updatedProfile));

    final result = await _toggleVipContactUseCase.execute(profile.contactId);

    result.fold(
      (failure) {
        if (isClosed) return;
        // Revert
        emit(state.copyWith(
          data: profile,
          flowState: ErrorState(
            StateRendererType.popupErrorStatete,
            failure.message,
            title: "فشل تحديث حالة التمييز",
          ),
        ));
      },
      (updatedContact) {
        if (isClosed) return;
        emit(state.copyWith(
          data: ContactProfile(
            contactId: updatedContact.id,
            contactName: updatedContact.name,
            phoneNumber: updatedContact.phoneNumber,
            contactEmail: updatedContact.contactEmail,
            isVip: updatedContact.isVip,
            totalTransactions: profile.totalTransactions,
            totalAmount: profile.totalAmount,
            transactions: profile.transactions,
          ),
        ));
      },
    );
  }

  Future<bool> deleteContact() async {
    final profile = state.data;
    if (profile == null) return false;

    emit(state.copyWith(
      flowState: LoadingState(
        stateRendererType: StateRendererType.popupLoadingState,
        title: "جاري الحذف",
        message: "جاري حذف الطرف...",
      ),
    ));

    final result = await _deleteContactUseCase.execute(profile.contactId);

    return result.fold(
      (failure) {
        if (isClosed) return false;
        emit(state.copyWith(
          flowState: ErrorState(
            StateRendererType.popupErrorStatete,
            failure.message,
            title: "فشل الحذف",
          ),
        ));
        return false;
      },
      (_) {
        if (isClosed) return true;
        emit(state.copyWith(
          isDeleted: true,
          flowState: ContentState(),
        ));
        return true;
      },
    );
  }
}
