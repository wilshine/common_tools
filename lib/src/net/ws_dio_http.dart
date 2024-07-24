import 'dart:convert';

import 'package:dio/dio.dart';

/// dio封装
class WsDioHttp {
  static const String methodGet = 'get';
  static const String methodPost = 'post';
  static const String methodPut = 'put';
  static const String methodPatch = 'patch';
  static const String methodDelete = 'delete';

  late Dio dio;

  WsDioHttp(this.dio);

  /// 自定义默认请求头
  Map<String, dynamic> getDefaultHeaders() {
    Map<String, dynamic> headers = {};

    return headers;
  }

  /// get method
  Future<dynamic> get(String url,
      {Map<String, dynamic>? params,
      Map<String, dynamic>? headers,
      dynamic data,
      Options? options,
      CancelToken? cancelToken,
      bool getResponse = false}) async {
    options ??= Options();
    options.extra ??= {};
    headers = headers ??= {};
    return _request(url,
        method: methodGet,
        params: params,
        data: data,
        options: options,
        cancelToken: cancelToken,
        headers: headers,
        getResponse: getResponse);
  }

  Future<dynamic> getByOptionsJson(String url,
      {dynamic data,
      Map<String, dynamic>? headers,
      Map<String, dynamic>? params,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgressCallback}) async {
    options ??= Options();
    options.contentType = Headers.jsonContentType;

    options.extra ??= {};
    headers ??= {};

    return _request(url,
        method: methodGet,
        headers: headers,
        params: params,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onSendProgressCallback: onSendProgressCallback);
  }

  Future<dynamic> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgressCallback,
    Map<String, dynamic>? headers,
    bool getResponse = false,
  }) async {
    options ??= Options();
    options.extra ??= {};

    return _request(
      url,
      method: methodPost,
      params: params,
      headers: headers,
      data: data ?? options.extra?['body'],
      options: options,
      cancelToken: cancelToken,
      onSendProgressCallback: onSendProgressCallback,
      getResponse: getResponse,
    );
  }

  /// json格式请求
  Future<dynamic> postByOptionsJson(String url,
      {dynamic data,
      Map<String, dynamic>? headers,
      Map<String, dynamic>? params,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgressCallback}) async {
    options ??= Options();
    options.contentType = Headers.jsonContentType;
    dio.options.contentType = Headers.jsonContentType;
    dio.options.method = methodPost;
    options.extra ??= {};
    headers = headers ??= {};
    return _request(url,
        method: methodPost,
        headers: headers,
        params: params,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onSendProgressCallback: onSendProgressCallback);
  }

  Future<dynamic> delete(String url,
      {dynamic data,
      Map<String, dynamic>? params,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgressCallback}) async {
    return _request(url,
        method: methodDelete,
        params: params,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onSendProgressCallback: onSendProgressCallback);
  }

  Future<dynamic> _request(
    String url, {
    String? method,
    dynamic data,
    Map<String, dynamic>? params,
    Options? options,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    ProgressCallback? onSendProgressCallback,
    bool getResponse = false, //返回未处理数据
  }) async {
    headers ??= {};
    headers.addAll(getDefaultHeaders());
    params ??= {};
    String errorMsg = '';
    int statusCode = -1;
    Response? response = await _getResponse(url,
        method: method,
        data: data,
        params: params,
        headers: headers,
        options: options,
        cancelToken: cancelToken,
        onSendProgressCallback: onSendProgressCallback);
    if (getResponse == true) {
      return response;
    }
    statusCode = response?.statusCode ?? -1;
    if (statusCode < 0) {
      errorMsg = 'Network request error, code: $statusCode';
      throw errorMsg;
    }
    if (response?.data is Map<String, dynamic>) {
      return response?.data;
    }
    Map<String, dynamic>? map;
    try {
      map = json.decode(response?.data);
    } catch (error) {
      try {
        map = jsonDecode(response?.data);
      } catch (error) {
        // Logger.debug('===http error===> $error');
      }
    }
    return map ?? response?.data;
  }

  Future<Response?> _getResponse(String url,
      {String? method,
      dynamic data,
      Map<String, dynamic>? params,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgressCallback,
      Map<String, dynamic>? headers}) async {
    Response? response;
    options ??= Options();
    options.headers ??= headers;
    // WSLogger.debug('>>>>>start:'
    //     '$url-----headers=${options.headers}--params=$params--------data=$data--------------------->');
    switch (method) {
      case methodGet:
        response = await dio.get(url, data: data, queryParameters: params, options: options, cancelToken: cancelToken);
        break;
      case methodPost:
        response = await dio.post(url,
            data: data,
            queryParameters: params,
            options: options,
            cancelToken: cancelToken,
            onSendProgress: onSendProgressCallback);
        break;
      case methodPatch:
        response =
            await dio.patch(url, data: data, queryParameters: params, options: options, cancelToken: cancelToken);
        break;
      case methodPut:
        response = await dio.put(url, data: data, queryParameters: params, options: options, cancelToken: cancelToken);
        break;
      case methodDelete:
        response =
            await dio.delete(url, data: data, queryParameters: params, options: options, cancelToken: cancelToken);
        break;
      default:
        throw 'error';
    }
    return response;
  }
}
