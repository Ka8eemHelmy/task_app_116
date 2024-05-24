import 'package:dio/dio.dart';
import 'package:task_app_116/view_model/data/local/shared_helper.dart';
import 'package:task_app_116/view_model/data/local/shared_keys.dart';
import 'package:task_app_116/view_model/data/network/end_points.dart';

class DioHelper {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: EndPoints.baseUrl,
      receiveDataWhenStatusError: true,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ),
  );

  static Future<Response> get({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool? withToken = false,
  }) async {
    try {
      if (withToken!) {
        _dio.options.headers.addAll({
          'Authorization': 'Bearer ${SharedHelper.getData(SharedKeys.token)}',
        });
      }
      Response response = await _dio.get(
        path,
        data: body,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> post({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    FormData? formData,
    bool? withToken = false,
  }) async {
    try {
      if (withToken!) {
        _dio.options.headers.addAll({
          'Authorization': 'Bearer ${SharedHelper.getData(SharedKeys.token)}',
        });
      }
      Response response = await _dio.post(
        path,
        data: formData ?? body,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> put({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool? withToken = false,
  }) async {
    try {
      if (withToken!) {
        _dio.options.headers.addAll({
          'Authorization': 'Bearer ${SharedHelper.getData(SharedKeys.token)}',
        });
      }
      Response response = await _dio.put(
        path,
        data: body,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> patch({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool? withToken = false,
  }) async {
    try {
      if (withToken!) {
        _dio.options.headers.addAll({
          'Authorization': 'Bearer ${SharedHelper.getData(SharedKeys.token)}',
        });
      }
      Response response = await _dio.patch(
        path,
        data: body,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  static Future<Response> delete({
    required String path,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool? withToken = false,
  }) async {
    try {
      if (withToken!) {
        _dio.options.headers.addAll({
          'Authorization': 'Bearer ${SharedHelper.getData(SharedKeys.token)}',
        });
      }
      Response response = await _dio.delete(
        path,
        data: body,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
