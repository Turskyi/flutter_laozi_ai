import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:laozi_ai/infrastructure/data_sources/remote/rest/ai_model_header.dart';
import 'package:laozi_ai/infrastructure/data_sources/remote/rest/logging_interceptor.dart';
import 'package:laozi_ai/infrastructure/data_sources/remote/rest/retrofit_client/retrofit_client.dart';
import 'package:laozi_ai/res/constants.dart' as constants;

@module
abstract class RetrofitClientModule {
  RetrofitClient getRestClient(
    LoggingInterceptor loggingInterceptor,
    AiModelHeaderInterceptor aiModelHeaderInterceptor,
  ) {
    final Dio dio = Dio()
      ..interceptors.addAll(<Interceptor>[
        loggingInterceptor,
        aiModelHeaderInterceptor,
      ]);

    return RetrofitClient(dio, baseUrl: constants.baseUrl);
  }
}
