// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retrofit_client.dart';

// dart format off

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers,unused_element,unnecessary_string_interpolations,unused_element_parameter,avoid_unused_constructor_parameters,unreachable_from_main

class _RetrofitClient implements RetrofitClient {
  _RetrofitClient(this._dio, {this.baseUrl, this.errorLogger});

  final Dio _dio;

  String? baseUrl;

  final ParseErrorLogger? errorLogger;

  @override
  Stream<List<int>> sendEnglishAndroidChatMessage(
    ChatRequest chatRequest,
  ) async* {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(chatRequest.toJson());
    final _options = _setStreamType<List<int>>(
      Options(
        method: 'POST',
        headers: _headers,
        extra: _extra,
        responseType: ResponseType.stream,
      )
      .compose(
        _dio.options,
        'chat-android-en',
        queryParameters: queryParameters,
        data: _data,
      )
      .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<ResponseBody>(_options);
    yield* _result.data!.stream;
  }

  @override
  Stream<List<int>> sendUkrainianAndroidChatMessage(
    ChatRequest chatRequest,
  ) async* {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(chatRequest.toJson());
    final _options = _setStreamType<List<int>>(
      Options(
        method: 'POST',
        headers: _headers,
        extra: _extra,
        responseType: ResponseType.stream,
      )
      .compose(
        _dio.options,
        'chat-android-ua',
        queryParameters: queryParameters,
        data: _data,
      )
      .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<ResponseBody>(_options);
    yield* _result.data!.stream;
  }

  @override
  Stream<List<int>> sendEnglishIosChatMessage(ChatRequest chatRequest) async* {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(chatRequest.toJson());
    final _options = _setStreamType<List<int>>(
      Options(
        method: 'POST',
        headers: _headers,
        extra: _extra,
        responseType: ResponseType.stream,
      )
      .compose(
        _dio.options,
        'chat-ios-en',
        queryParameters: queryParameters,
        data: _data,
      )
      .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<ResponseBody>(_options);
    yield* _result.data!.stream;
  }

  @override
  Stream<List<int>> sendUkrainianIosChatMessage(
    ChatRequest chatRequest,
  ) async* {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(chatRequest.toJson());
    final _options = _setStreamType<List<int>>(
      Options(
        method: 'POST',
        headers: _headers,
        extra: _extra,
        responseType: ResponseType.stream,
      )
      .compose(
        _dio.options,
        'chat-ios-ua',
        queryParameters: queryParameters,
        data: _data,
      )
      .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<ResponseBody>(_options);
    yield* _result.data!.stream;
  }

  @override
  Stream<List<int>> sendEnglishWebChatMessage(ChatRequest chatRequest) async* {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(chatRequest.toJson());
    final _options = _setStreamType<List<int>>(
      Options(
        method: 'POST',
        headers: _headers,
        extra: _extra,
        responseType: ResponseType.stream,
      )
      .compose(
        _dio.options,
        'chat-web-app-en',
        queryParameters: queryParameters,
        data: _data,
      )
      .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<ResponseBody>(_options);
    yield* _result.data!.stream;
  }

  @override
  Stream<List<int>> sendUkrainianWebChatMessage(
    ChatRequest chatRequest,
  ) async* {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(chatRequest.toJson());
    final _options = _setStreamType<List<int>>(
      Options(
        method: 'POST',
        headers: _headers,
        extra: _extra,
        responseType: ResponseType.stream,
      )
      .compose(
        _dio.options,
        'chat-web-app-ua',
        queryParameters: queryParameters,
        data: _data,
      )
      .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<ResponseBody>(_options);
    yield* _result.data!.stream;
  }

  @override
  Stream<List<int>> sendChatMessage(ChatRequest chatRequest) async* {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(chatRequest.toJson());
    final _options = _setStreamType<List<int>>(
      Options(
        method: 'POST',
        headers: _headers,
        extra: _extra,
        responseType: ResponseType.stream,
      )
      .compose(
        _dio.options,
        'chat',
        queryParameters: queryParameters,
        data: _data,
      )
      .copyWith(baseUrl: _combineBaseUrls(_dio.options.baseUrl, baseUrl)),
    );
    final _result = await _dio.fetch<ResponseBody>(_options);
    yield* _result.data!.stream;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(String dioBaseUrl, String? baseUrl) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}

// dart format on
