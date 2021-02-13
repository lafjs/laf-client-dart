import 'package:dio/dio.dart';
import 'package:less_api_client/cloud.dart';
import 'package:less_api_client/database/param.dart';
import 'package:less_api_client/database/types.dart';

class Request implements CloudRequestInterface {
  Dio _http;

  @override
  String entryUrl;

  @override
  GetTokenFunction getTokenFunction;

  @override
  int timeout;

  Request(this.entryUrl, {this.getTokenFunction, this.timeout}) {
    this._configHttpInstance();
  }

  @override
  Future<ResponseResult> send(String action, Param param) async {
    final res = await _http.post(this.entryUrl, data: param.toJson());
    final res_data = res.data;
    final ret =
        ResponseResult(res_data?.code, res_data['data'], res_data?.requestId);
    return ret;
  }

  _configHttpInstance() {
    final options = new BaseOptions(
      connectTimeout: timeout,
      receiveTimeout: timeout,
      contentType: 'application/json',
    );

    _http = new Dio(options);
    _http.interceptors.add(
      InterceptorsWrapper(
        onRequest: (RequestOptions options) async {
          final auth = options.headers['Authorization'];
          if (auth == null || auth == "") {
            final token = await getTokenFunction();
            options.headers['Authorization'] = "Bearer $token";
          }

          _log('HTTP Request | ${options.method} ${options.uri.toString()}');
          _log('             | baseUrl: ' + options.baseUrl);
          _log('             | contentType: ' + options.contentType);
          _log('             | query: ' + options.queryParameters.toString());
          _log('             | headers: ' + options.headers.toString());

          // Do something before request is sent
          return options; //continue
          // If you want to resolve the request with some custom data，
          // you can return a `Response` object or return `dio.resolve(data)`.
          // If you want to reject the request with a error message,
          // you can return a `DioError` object or return `dio.reject(errMsg)`
        },
        onResponse: (Response response) async {
          // Do something with response data
          _log(
              'HTTP Response  | ${response.request.method} ${response.request.uri.toString()}');
          _log('               | statusCode: ${response.statusCode}');
          _log('               | headers: ' + response.headers.toString());
          _log('               | data: ' + response.data.toString());
          return response; // continue
        },
        onError: (DioError e) async {
          _log(
              'HTTP Response Error | ${e.request.method} ${e.request.uri.toString()}');
          _log('HTTP Response Error: ' + e.toString());

          // Do something with response error
          return e; //continue
        },
      ),
    );
  }

  _log(dynamic object) {
    print(object);
  }
}
