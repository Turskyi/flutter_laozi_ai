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
import 'package:laozi_ai/application_services/blocs/chat/chat_bloc.dart'
    as _i776;
import 'package:laozi_ai/application_services/blocs/settings/settings_bloc.dart'
    as _i355;
import 'package:laozi_ai/application_services/blocs/support/support_bloc.dart'
    as _i976;
import 'package:laozi_ai/application_services/repositories/chat_repository_impl.dart'
    as _i848;
import 'package:laozi_ai/application_services/repositories/email_repository_impl.dart'
    as _i174;
import 'package:laozi_ai/application_services/repositories/settings_repository_impl.dart'
    as _i731;
import 'package:laozi_ai/di/preferences_module.dart' as _i475;
import 'package:laozi_ai/di/resend_module.dart' as _i79;
import 'package:laozi_ai/di/retrofit_client_module.dart' as _i609;
import 'package:laozi_ai/domain_services/chat_repository.dart' as _i732;
import 'package:laozi_ai/domain_services/email_repository.dart' as _i252;
import 'package:laozi_ai/domain_services/settings_repository.dart' as _i301;
import 'package:laozi_ai/infrastructure/data_sources/local/local_data_source.dart'
    as _i451;
import 'package:laozi_ai/infrastructure/data_sources/remote/rest/logging_interceptor.dart'
    as _i908;
import 'package:laozi_ai/infrastructure/data_sources/remote/rest/retrofit_client/retrofit_client.dart'
    as _i375;
import 'package:resend/resend.dart' as _i176;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> initDependencyInjection({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final sharedPreferencesModule = _$SharedPreferencesModule();
    final resendModule = _$ResendModule();
    final retrofitClientModule = _$RetrofitClientModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => sharedPreferencesModule.prefs,
      preResolve: true,
    );
    gh.factory<_i176.Resend>(() => resendModule.resend);
    gh.factory<_i908.LoggingInterceptor>(
      () => const _i908.LoggingInterceptor(),
    );
    gh.factory<_i252.EmailRepository>(
      () => _i174.EmailRepositoryImpl(gh<_i176.Resend>()),
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
    gh.factory<_i976.SupportBloc>(
      () => _i976.SupportBloc(gh<_i252.EmailRepository>()),
    );
    gh.factory<_i355.SettingsBloc>(
      () => _i355.SettingsBloc(gh<_i301.SettingsRepository>()),
    );
    gh.factory<_i776.ChatBloc>(
      () => _i776.ChatBloc(
        gh<_i732.ChatRepository>(),
        gh<_i301.SettingsRepository>(),
      ),
    );
    return this;
  }
}

class _$SharedPreferencesModule extends _i475.SharedPreferencesModule {}

class _$ResendModule extends _i79.ResendModule {}

class _$RetrofitClientModule extends _i609.RetrofitClientModule {}
