import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:laozi_ai/infrastructure/web_services/rest/logging_interceptor.dart';
import 'package:laozi_ai/infrastructure/web_services/rest/retrofit_client/retrofit_client.dart';
import 'package:laozi_ai/res/constants.dart' as constants;

@module
abstract class RetrofitClientModule {
  RetrofitClient getRestClient(
    LoggingInterceptor loggingInterceptor,
  ) {
    final Dio dio = Dio();
    dio.interceptors.add(loggingInterceptor);
    return RetrofitClient(dio, baseUrl: constants.baseUrl);
  }
}
