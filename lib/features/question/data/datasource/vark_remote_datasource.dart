import 'package:dio/dio.dart';
import '../models/ml_prediction_model.dart';

abstract class VarkRemoteDataSource {
  Future<MLPredictionModel> getPrediction({
    required int visualScore,
    required int auditoryScore,
    required int readingScore,
    required int kinestheticScore,
  });

  Future<bool> healthCheck();
}

class VarkRemoteDataSourceImpl implements VarkRemoteDataSource {
  final Dio dio;
  final String baseUrl;

  VarkRemoteDataSourceImpl({
    required this.dio,
    this.baseUrl = 'http://103.161.184.37:4000', // IP server
  }) {
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);

    // Add logging interceptor
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('REQUEST: ${options.method} ${options.path}');
          print('DATA: ${options.data}');
          return handler.next(options);
        },
        onResponse: (response, handler) {
          print('RESPONSE: ${response.statusCode}');
          print('DATA: ${response.data}');
          return handler.next(response);
        },
        onError: (error, handler) {
          print('ERROR: ${error.message}');
          print('RESPONSE: ${error.response?.data}');
          return handler.next(error);
        },
      ),
    );
  }

  @override
  Future<MLPredictionModel> getPrediction({
    required int visualScore,
    required int auditoryScore,
    required int readingScore,
    required int kinestheticScore,
  }) async {
    print('DEBUG REMOTE: Sending scores to ML server:');
    print('  visual: ${visualScore.toDouble()}');
    print('  auditory: ${auditoryScore.toDouble()}');
    print('  readwrite: ${readingScore.toDouble()}');
    print('  kinesthetic: ${kinestheticScore.toDouble()}');

    try {
      final response = await dio.post(
        '/predict',
        data: {
          'visual': visualScore.toDouble(),
          'auditory': auditoryScore.toDouble(),
          'readwrite': readingScore.toDouble(),
          'kinesthetic': kinestheticScore.toDouble(),
        },
      );

      if (response.statusCode == 200) {
        return MLPredictionModel.fromJson(response.data);
      } else {
        throw ServerException(
          message: 'Prediction failed: ${response.statusCode}',
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error: $e');
    }
  }

  @override
  Future<bool> healthCheck() async {
    try {
      final response = await dio.get('/health');
      return response.statusCode == 200 && response.data['status'] == 'healthy';
    } catch (e) {
      return false;
    }
  }

  ServerException _handleDioException(DioException error) {
    if (error.response != null) {
      final data = error.response!.data;
      String message = 'Request failed';

      if (data is Map && data.containsKey('detail')) {
        message = data['detail'].toString();
      }

      return ServerException(message: message);
    } else if (error.type == DioExceptionType.connectionTimeout) {
      return ServerException(
        message: 'Connection timeout. Check your internet.',
      );
    } else if (error.type == DioExceptionType.receiveTimeout) {
      return ServerException(message: 'Server timeout.');
    } else {
      return ServerException(message: 'Network error: ${error.message}');
    }
  }
}

class ServerException implements Exception {
  final String message;
  ServerException({required this.message});

  @override
  String toString() => 'ServerException: $message';
}
