// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:laozi_ai/application_services/blocs/chat_bloc.dart' as _i841;
import 'package:laozi_ai/application_services/blocs/settings_bloc.dart'
    as _i1032;
import 'package:laozi_ai/application_services/repositories/chat_repository_impl.dart'
    as _i848;
import 'package:laozi_ai/application_services/repositories/settings_repository_impl.dart'
    as _i731;
import 'package:laozi_ai/di/preferences_module.dart' as _i475;
import 'package:laozi_ai/di/retrofit_client_module.dart' as _i609;
import 'package:laozi_ai/domain_services/chat_repository.dart' as _i732;
import 'package:laozi_ai/domain_services/settings_repository.dart' as _i301;
import 'package:laozi_ai/infrastructure/data_sources/local/local_data_source.dart'
    as _i451;
import 'package:laozi_ai/infrastructure/data_sources/remote/rest/logging_interceptor.dart'
    as _i908;
import 'package:laozi_ai/infrastructure/data_sources/remote/rest/retrofit_client/retrofit_client.dart'
    as _i375;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> initDependencyInjection({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final sharedPreferencesModule = _$SharedPreferencesModule();
    final retrofitClientModule = _$RetrofitClientModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => sharedPreferencesModule.prefs,
      preResolve: true,
    );
    gh.factory<_i908.LoggingInterceptor>(
      () => const _i908.LoggingInterceptor(),
    );
    gh.factory<_i301.SettingsRepository>(
      () => _i731.SettingsRepositoryImpl(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i375.RetrofitClient>(
      () => retrofitClientModule.getRestClient(gh<_i908.LoggingInterceptor>()),
    );
    gh.factory<_i451.LocalDataSource>(
      () => _i451.LocalDataSource(gh<_i460.SharedPreferences>()),
    );
    gh.factory<_i732.ChatRepository>(
      () => _i848.ChatRepositoryImpl(
        gh<_i375.RetrofitClient>(),
        gh<_i451.LocalDataSource>(),
      ),
    );
    gh.factory<_i1032.SettingsBloc>(
      () => _i1032.SettingsBloc(gh<_i301.SettingsRepository>()),
    );
    gh.factory<_i841.ChatBloc>(
      () => _i841.ChatBloc(gh<_i732.ChatRepository>()),
    );
    return this;
  }
}

class _$SharedPreferencesModule extends _i475.SharedPreferencesModule {}

class _$RetrofitClientModule extends _i609.RetrofitClientModule {}
