// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:laozi_ai/application_services/blocs/chat_bloc.dart' as _i841;
import 'package:laozi_ai/application_services/repositories/chat_repository_impl.dart'
    as _i848;
import 'package:laozi_ai/application_services/repositories/settings_repository_impl.dart'
    as _i731;
import 'package:laozi_ai/di/preferences_module.dart' as _i475;
import 'package:laozi_ai/di/retrofit_client_module.dart' as _i609;
import 'package:laozi_ai/domain_services/chat_repository.dart' as _i732;
import 'package:laozi_ai/domain_services/settings_repository.dart' as _i301;
import 'package:laozi_ai/infrastructure/web_services/rest/logging_interceptor.dart'
    as _i890;
import 'package:laozi_ai/infrastructure/web_services/rest/retrofit_client/retrofit_client.dart'
    as _i222;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> initDependencyInjection({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final sharedPreferencesModule = _$SharedPreferencesModule();
    final retrofitClientModule = _$RetrofitClientModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => sharedPreferencesModule.prefs,
      preResolve: true,
    );
    gh.factory<_i890.LoggingInterceptor>(
        () => const _i890.LoggingInterceptor());
    gh.factory<_i301.SettingsRepository>(
        () => _i731.SettingsRepositoryImpl(gh<_i460.SharedPreferences>()));
    gh.factory<_i222.RetrofitClient>(() =>
        retrofitClientModule.getRestClient(gh<_i890.LoggingInterceptor>()));
    gh.factory<_i732.ChatRepository>(
        () => _i848.ChatRepositoryImpl(gh<_i222.RetrofitClient>()));
    gh.factory<_i841.ChatBloc>(() => _i841.ChatBloc(
          gh<_i732.ChatRepository>(),
          gh<_i301.SettingsRepository>(),
        ));
    return this;
  }
}

class _$SharedPreferencesModule extends _i475.SharedPreferencesModule {}

class _$RetrofitClientModule extends _i609.RetrofitClientModule {}
