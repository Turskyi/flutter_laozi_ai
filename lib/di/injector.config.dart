// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:laozi_ai/application_services/blocs/chat_bloc.dart' as _i12;
import 'package:laozi_ai/application_services/repositories/chat_repository_impl.dart'
    as _i9;
import 'package:laozi_ai/application_services/repositories/email_repository_impl.dart'
    as _i11;
import 'package:laozi_ai/application_services/repositories/settings_repository_impl.dart'
    as _i7;
import 'package:laozi_ai/di/preferences_module.dart' as _i13;
import 'package:laozi_ai/di/retrofit_client_module.dart' as _i14;
import 'package:laozi_ai/domain_services/chat_repository.dart' as _i8;
import 'package:laozi_ai/domain_services/email_repository.dart' as _i10;
import 'package:laozi_ai/domain_services/settings_repository.dart' as _i6;
import 'package:laozi_ai/infrastructure/web_services/rest/logging_interceptor.dart'
    as _i4;
import 'package:laozi_ai/infrastructure/web_services/rest/retrofit_client/retrofit_client.dart'
    as _i5;
import 'package:shared_preferences/shared_preferences.dart' as _i3;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> initDependencyInjection({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final sharedPreferencesModule = _$SharedPreferencesModule();
    final retrofitClientModule = _$RetrofitClientModule();
    await gh.factoryAsync<_i3.SharedPreferences>(
      () => sharedPreferencesModule.prefs,
      preResolve: true,
    );
    gh.factory<_i4.LoggingInterceptor>(() => const _i4.LoggingInterceptor());
    gh.factory<_i5.RetrofitClient>(
        () => retrofitClientModule.getRestClient(gh<_i4.LoggingInterceptor>()));
    gh.factory<_i6.SettingsRepository>(
        () => _i7.SettingsRepositoryImpl(gh<_i3.SharedPreferences>()));
    gh.factory<_i8.ChatRepository>(
        () => _i9.ChatRepositoryImpl(gh<_i5.RetrofitClient>()));
    gh.factory<_i10.EmailRepository>(
        () => _i11.EmailRepositoryImpl(gh<_i5.RetrofitClient>()));
    gh.factory<_i12.ChatBloc>(() => _i12.ChatBloc(
          gh<_i8.ChatRepository>(),
          gh<_i6.SettingsRepository>(),
          gh<_i10.EmailRepository>(),
        ));
    return this;
  }
}

class _$SharedPreferencesModule extends _i13.SharedPreferencesModule {}

class _$RetrofitClientModule extends _i14.RetrofitClientModule {}
