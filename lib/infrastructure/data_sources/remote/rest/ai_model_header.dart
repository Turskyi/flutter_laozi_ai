import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

/// Holds the model name from the most recent chat response (`X-AI-Model`).
@lazySingleton
class AiModelHeaderStore {
  String? latest;
}

@Injectable()
class AiModelHeaderInterceptor extends Interceptor {
  AiModelHeaderInterceptor(this._store);

  final AiModelHeaderStore _store;

  @override
  void onResponse(
    Response<Object?> response,
    ResponseInterceptorHandler handler,
  ) {
    final String? model = response.headers.value('x-ai-model');
    if (model != null && model.isNotEmpty) {
      _store.latest = model;
    }
    super.onResponse(response, handler);
  }
}
