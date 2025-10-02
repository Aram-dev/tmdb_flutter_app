import 'package:dio/dio.dart';
import 'package:tmdb_flutter_app/features/actors/domain/models/actor_details.dart';
import 'package:tmdb_flutter_app/features/actors/domain/models/actors_list_result.dart';
import 'package:tmdb_flutter_app/features/actors/domain/repositories/actors_repository.dart';

import '../../domain/models/actors_list_entity.dart';

class ActorsRepositoryImpl extends ActorsRepository {
  ActorsRepositoryImpl({required this.dio});

  final Dio dio;
  // int _maxPages = 1;
  // int _currentPage = 1;

  @override
  Future<ActorsListEntity> getPopularActors(
    int page,
    String apiKey,
    String language,
  ) async {
    final String endpoint = '/person/popular';
    final params = {
      'api_key': apiKey,
      'language': language,
      'page': page, // caller controls pagination
    };

    try {
      final response = await dio.get(endpoint, queryParameters: params);
      final data = response.data as Map<String, dynamic>;

      // current page from server, fallback to requested page
      final currentPage = (data['page'] as num?)?.toInt() ?? page;
      final totalPages = (data['total_pages'] as num?)?.toInt();
      final totalResults = (data['total_results'] as num?)?.toInt();

      final resultsJson = (data['results'] as List?) ?? const [];
      final results = resultsJson
          .whereType<Map<String, dynamic>>()
          .map((json) => ActorsListResults.fromJson(json))
          .toList();

      return ActorsListEntity(
        page: currentPage,
        results: results,
        totalPages: totalPages,
        totalResults: totalResults, hasMore: false,
      );
    } on DioException catch (e) {
      // Map DioException to a domain error or rethrow with context
      final status = e.response?.statusCode;
      final msg = _readableDioMessage(e);
      throw FetchActorsException(message: msg, statusCode: status);
    } catch (e) {
      throw FetchActorsException(message: e.toString());
    }


    // return _fetchActorsFromApi(endpoint, params);
  }

  @override
  Future<ActorDetails> getActorDetails(
    int actorId,
    String apiKey,
    String language,
  ) async {
    final String endpoint = '/person/$actorId';
    final params = {
      'api_key': apiKey,
      'language': language,
    };

    try {
      final response = await dio.get(endpoint, queryParameters: params);
      final data = response.data as Map<String, dynamic>;
      return ActorDetails.fromJson(data);
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final msg = _readableDioMessage(e);
      throw FetchActorsException(message: msg, statusCode: status);
    } catch (e) {
      throw FetchActorsException(message: e.toString());
    }
  }

  String _readableDioMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Network timeout. Please try again.';
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        return 'Server error${code != null ? ' ($code)' : ''}.';
      case DioExceptionType.cancel:
        return 'Request was cancelled.';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.badCertificate:
        return 'Bad SSL certificate.';
      case DioExceptionType.unknown:

      return 'Unexpected error occurred.';
    }
  }

  // Future<ActorsListEntity> _fetchActorsFromApi(
  //     String endpoint,
  //     Map<String, Object> queryParams) async {
  //
  //   queryParams.putIfAbsent('page', () => _currentPage);
  //   final response = await dio.get(endpoint, queryParameters: queryParams);
  //
  //   final data = response.data as Map<String, dynamic>;
  //   _currentPage =  data.containsKey('page') ? data['page'] + 1 as int : _currentPage;
  //   final results = (data.containsKey('results') ? data['results'] as List : null)
  //       ?.map((json) => ActorsListResults.fromJson(json))
  //       .toList();
  //   final totalPages = data.containsKey('total_pages') ? data['total_pages'] as int : null;
  //   final totalResults = data.containsKey('total_results') ? data['total_results'] as int : null;
  //
  //   final entity = ActorsListEntity(
  //     page: _currentPage,
  //     results: results,
  //     totalPages: totalPages,
  //     totalResults: totalResults,
  //   );
  //
  //   return entity;
  // }
}

/// Optional domain exception to bubble up to UI/state layer.
class FetchActorsException implements Exception {
  FetchActorsException({required this.message, this.statusCode});
  final String message;
  final int? statusCode;

  @override
  String toString() =>
      'FetchActorsException(statusCode: $statusCode, message: $message)';
}
