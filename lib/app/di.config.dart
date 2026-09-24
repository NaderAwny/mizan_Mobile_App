// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:internet_connection_checker/internet_connection_checker.dart'
    as _i973;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../data/data_source/auth_remote_data_source.dart' as _i1010;
import '../data/data_source/contact_remote_data_source.dart' as _i1006;
import '../data/data_source/get_list_transaction_remote_data_source.dart'
    as _i696;
import '../data/data_source/get_profile_data_source.dart' as _i197;
import '../data/data_source/register_remote_data_source.dart' as _i1006;
import '../data/data_source/send_otp_remote_data_source.dart' as _i371;
import '../data/data_source/transaction_remote_data_source.dart' as _i93;
import '../data/local/onboarding_local_data_source.dart' as _i603;
import '../data/local/secure_token_local_data_source.dart' as _i388;
import '../data/local/shared_prefs_onboarding_data_source.dart' as _i398;
import '../data/local/token_local_data_source.dart' as _i1028;
import '../data/network/app_api.dart' as _i563;
import '../data/network/dio_client.dart' as _i765;
import '../data/network/network_info.dart' as _i371;
import '../data/repository_impl/auth_repository_impl.dart' as _i970;
import '../data/repository_impl/contact_repository_impl.dart' as _i956;
import '../data/repository_impl/get_list_transaction_repository_impl.dart'
    as _i543;
import '../data/repository_impl/get_profile_repository_impl.dart' as _i379;
import '../data/repository_impl/register_repository_impl.dart' as _i432;
import '../data/repository_impl/send_otp_repository_impl.dart' as _i1060;
import '../data/repository_impl/transaction_repository_impl.dart' as _i905;
import '../domain/repository/auth_repository.dart' as _i306;
import '../domain/repository/contact_repository.dart' as _i621;
import '../domain/repository/get_list_%20transaction_repository.dart' as _i92;
import '../domain/repository/get_profile_repository.dart' as _i770;
import '../domain/repository/register_repository.dart' as _i582;
import '../domain/repository/send_otp_repository.dart' as _i943;
import '../domain/repository/transaction_repository.dart' as _i132;
import '../domain/use_case/create_contact_use_case.dart' as _i770;
import '../domain/use_case/create_transaction_use_case.dart' as _i807;
import '../domain/use_case/delete_contact_use_case.dart' as _i1053;
import '../domain/use_case/get_contact_by_id_use_case.dart' as _i804;
import '../domain/use_case/get_contact_profile_use_case.dart' as _i307;
import '../domain/use_case/get_contacts_use_case.dart' as _i646;
import '../domain/use_case/get_list_transaction_use_case.dart' as _i463;
import '../domain/use_case/get_profile_use_case.dart' as _i673;
import '../domain/use_case/get_transaction_by_id_use_case.dart' as _i1060;
import '../domain/use_case/get_vip_contacts_use_case.dart' as _i1063;
import '../domain/use_case/logout_use_case.dart' as _i235;
import '../domain/use_case/register_use_case.dart' as _i224;
import '../domain/use_case/select_user_type_use_case.dart' as _i684;
import '../domain/use_case/send_otp_use_case.dart' as _i508;
import '../domain/use_case/toggle_vip_contact_use_case.dart' as _i493;
import '../domain/use_case/update_contact_use_case.dart' as _i52;
import '../domain/use_case/verify_otp_use_case.dart' as _i484;
import '../presentation/auth_verification/verify_otp_cubit/verify_otp_cubit.dart'
    as _i705;
import '../presentation/customers/contact_form_cubit/contact_form_cubit.dart'
    as _i215;
import '../presentation/customers/contact_profile_cubit/contact_profile_cubit.dart'
    as _i906;
import '../presentation/customers/contacts_cubit/contacts_cubit.dart' as _i232;
import '../presentation/get_profile/cubit/get_profile_cubit.dart' as _i1007;
import '../presentation/logout/logout_cubit/logout_cubit.dart' as _i995;
import '../presentation/register/cubit/register_cubit.dart' as _i298;
import '../presentation/select_user_type/select_user_type_cubit/select_user_type_cubit.dart'
    as _i710;
import '../presentation/send_otp/cubit/send_otp_cubit/send_otp_cubit.dart'
    as _i531;
import '../presentation/splash/splash_cubit/splash_cubit.dart' as _i822;
import '../presentation/transactions/get_list_transaction/get_list_transaction_cubit.dart'
    as _i877;
import '../presentation/transactions/get_transaction_by_id/get_transaction_by_id_cubit.dart'
    as _i212;
import '../presentation/transactions/transaction_form_cubit/transaction_form_cubit.dart'
    as _i472;
import 'app_module.dart' as _i460;
import 'session_manager.dart' as _i989;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final appModule = _$AppModule();
    gh.lazySingleton<_i973.InternetConnectionChecker>(
      () => appModule.internetConnectionChecker,
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => appModule.provideSecureStorage,
    );
    gh.lazySingleton<_i989.SessionManager>(() => _i989.SessionManager());
    gh.lazySingleton<_i1028.TokenLocalDataSource>(
      () => _i388.SecureTokenLocalDataSource(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i371.NetworkInfo>(
      () => _i371.NetworkInfoImpl(gh<_i973.InternetConnectionChecker>()),
    );
    gh.lazySingleton<_i603.OnboardingLocalDataSource>(
      () =>
          _i398.SharedPrefsOnboardingDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i765.DioFactory>(
      () => _i765.DioFactory(
        gh<_i1028.TokenLocalDataSource>(),
        gh<_i989.SessionManager>(),
      ),
    );
    gh.factory<_i822.SplashCubit>(
      () => _i822.SplashCubit(
        gh<_i1028.TokenLocalDataSource>(),
        gh<_i603.OnboardingLocalDataSource>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(() => appModule.dio(gh<_i765.DioFactory>()));
    gh.lazySingleton<_i563.AppServiceClient>(
      () => appModule.appServiceClient(gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i1006.RegisterRemoteDataSource>(
      () => _i1006.RegisterRemoteDataSourceImpl(gh<_i563.AppServiceClient>()),
    );
    gh.lazySingleton<_i197.GetProfileDataSource>(
      () => _i197.GetProfileDataSourceImpl(gh<_i563.AppServiceClient>()),
    );
    gh.lazySingleton<_i770.GetProfileRepository>(
      () => _i379.GetProfileRepositoryImpl(
        gh<_i197.GetProfileDataSource>(),
        gh<_i371.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i582.RegisterRepository>(
      () => _i432.RegisterRepositoryImpl(
        gh<_i1006.RegisterRemoteDataSource>(),
        gh<_i371.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i93.TransactionRemoteDataSource>(
      () => _i93.TransactionRemoteDataSourceImpl(gh<_i563.AppServiceClient>()),
    );
    gh.lazySingleton<_i371.SendOtpRemoteDataSource>(
      () => _i371.SendOtpRemoteDataSourceImpl(gh<_i563.AppServiceClient>()),
    );
    gh.lazySingleton<_i1010.AuthRemoteDataSource>(
      () => _i1010.AuthRemoteDataSourceImpl(gh<_i563.AppServiceClient>()),
    );
    gh.lazySingleton<_i943.SendOtpRepository>(
      () => _i1060.SendOtpRepositoryImpl(
        gh<_i371.SendOtpRemoteDataSource>(),
        gh<_i371.NetworkInfo>(),
      ),
    );
    gh.lazySingleton<_i696.GetListTransactionsRemoteDataSource>(
      () => _i696.GetListTransactionsRemoteDataSourceImpl(
        gh<_i563.AppServiceClient>(),
      ),
    );
    gh.lazySingleton<_i1006.ContactRemoteDataSource>(
      () => _i1006.ContactRemoteDataSourceImpl(gh<_i563.AppServiceClient>()),
    );
    gh.lazySingleton<_i621.ContactRepository>(
      () => _i956.ContactRepositoryImpl(
        gh<_i1006.ContactRemoteDataSource>(),
        gh<_i371.NetworkInfo>(),
      ),
    );
    gh.factory<_i673.GetProfileUsecase>(
      () => _i673.GetProfileUsecase(gh<_i770.GetProfileRepository>()),
    );
    gh.factory<_i770.CreateContactUseCase>(
      () => _i770.CreateContactUseCase(gh<_i621.ContactRepository>()),
    );
    gh.factory<_i1053.DeleteContactUseCase>(
      () => _i1053.DeleteContactUseCase(gh<_i621.ContactRepository>()),
    );
    gh.factory<_i804.GetContactByIdUseCase>(
      () => _i804.GetContactByIdUseCase(gh<_i621.ContactRepository>()),
    );
    gh.factory<_i307.GetContactProfileUseCase>(
      () => _i307.GetContactProfileUseCase(gh<_i621.ContactRepository>()),
    );
    gh.factory<_i646.GetContactsUseCase>(
      () => _i646.GetContactsUseCase(gh<_i621.ContactRepository>()),
    );
    gh.factory<_i1063.GetVipContactsUseCase>(
      () => _i1063.GetVipContactsUseCase(gh<_i621.ContactRepository>()),
    );
    gh.factory<_i493.ToggleVipContactUseCase>(
      () => _i493.ToggleVipContactUseCase(gh<_i621.ContactRepository>()),
    );
    gh.factory<_i52.UpdateContactUseCase>(
      () => _i52.UpdateContactUseCase(gh<_i621.ContactRepository>()),
    );
    gh.lazySingleton<_i132.TransactionRepository>(
      () => _i905.TransactionRepositoryImpl(
        gh<_i93.TransactionRemoteDataSource>(),
        gh<_i371.NetworkInfo>(),
      ),
    );
    gh.factory<_i906.ContactProfileCubit>(
      () => _i906.ContactProfileCubit(
        gh<_i307.GetContactProfileUseCase>(),
        gh<_i493.ToggleVipContactUseCase>(),
        gh<_i1053.DeleteContactUseCase>(),
      ),
    );
    gh.factory<_i232.ContactsCubit>(
      () => _i232.ContactsCubit(
        gh<_i646.GetContactsUseCase>(),
        gh<_i1063.GetVipContactsUseCase>(),
        gh<_i493.ToggleVipContactUseCase>(),
        gh<_i1053.DeleteContactUseCase>(),
      ),
    );
    gh.factory<_i224.RegisterUseCase>(
      () => _i224.RegisterUseCase(gh<_i582.RegisterRepository>()),
    );
    gh.lazySingleton<_i92.GetListTransactionsRepository>(
      () => _i543.GetListTransactionsRepositoryImpl(
        gh<_i696.GetListTransactionsRemoteDataSource>(),
        gh<_i371.NetworkInfo>(),
      ),
    );
    gh.factory<_i508.SendOtpUseCase>(
      () => _i508.SendOtpUseCase(gh<_i943.SendOtpRepository>()),
    );
    gh.factory<_i1007.GetProfileCubit>(
      () => _i1007.GetProfileCubit(gh<_i673.GetProfileUsecase>()),
    );
    gh.factory<_i215.ContactFormCubit>(
      () => _i215.ContactFormCubit(
        gh<_i770.CreateContactUseCase>(),
        gh<_i52.UpdateContactUseCase>(),
      ),
    );
    gh.lazySingleton<_i306.AuthRepository>(
      () => _i970.AuthRepositoryImpl(
        gh<_i1010.AuthRemoteDataSource>(),
        gh<_i371.NetworkInfo>(),
        gh<_i1028.TokenLocalDataSource>(),
      ),
    );
    gh.factory<_i298.RegisterCubit>(
      () => _i298.RegisterCubit(gh<_i224.RegisterUseCase>()),
    );
    gh.factory<_i807.CreateTransactionUseCase>(
      () => _i807.CreateTransactionUseCase(gh<_i132.TransactionRepository>()),
    );
    gh.factory<_i1060.GetTransactionByIdUseCase>(
      () => _i1060.GetTransactionByIdUseCase(gh<_i132.TransactionRepository>()),
    );
    gh.factory<_i531.SendOtpCubit>(
      () => _i531.SendOtpCubit(gh<_i508.SendOtpUseCase>()),
    );
    gh.factory<_i235.LogoutUseCase>(
      () => _i235.LogoutUseCase(gh<_i306.AuthRepository>()),
    );
    gh.factory<_i684.SelectUserTypeUseCase>(
      () => _i684.SelectUserTypeUseCase(gh<_i306.AuthRepository>()),
    );
    gh.factory<_i484.VerifyOtpUseCase>(
      () => _i484.VerifyOtpUseCase(gh<_i306.AuthRepository>()),
    );
    gh.factory<_i472.TransactionFormCubit>(
      () => _i472.TransactionFormCubit(gh<_i807.CreateTransactionUseCase>()),
    );
    gh.factory<_i705.VerifyOtpCubit>(
      () => _i705.VerifyOtpCubit(gh<_i484.VerifyOtpUseCase>()),
    );
    gh.lazySingleton<_i463.GetListTransactionsUseCase>(
      () => _i463.GetListTransactionsUseCase(
        gh<_i92.GetListTransactionsRepository>(),
      ),
    );
    gh.factory<_i212.GetTransactionByIdCubit>(
      () =>
          _i212.GetTransactionByIdCubit(gh<_i1060.GetTransactionByIdUseCase>()),
    );
    gh.factory<_i995.LogoutCubit>(
      () => _i995.LogoutCubit(gh<_i235.LogoutUseCase>()),
    );
    gh.factory<_i710.SelectUserTypeCubit>(
      () => _i710.SelectUserTypeCubit(gh<_i684.SelectUserTypeUseCase>()),
    );
    gh.factory<_i877.GetListTransactionCubit>(
      () =>
          _i877.GetListTransactionCubit(gh<_i463.GetListTransactionsUseCase>()),
    );
    return this;
  }
}

class _$AppModule extends _i460.AppModule {}
