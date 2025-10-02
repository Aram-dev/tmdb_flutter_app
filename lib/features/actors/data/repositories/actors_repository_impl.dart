import 'package:dio/dio.dart';
import 'package:tmdb_flutter_app/features/actors/domain/models/actor_details.dart';
import 'package:tmdb_flutter_app/features/actors/domain/models/actor_credit.dart';
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
    final detailsEndpoint = '/person/$actorId';
    final creditsEndpoint = '/person/$actorId/combined_credits';
    final params = {
      'api_key': apiKey,
      'language': language,
    };

    try {
      final responses = await Future.wait([
        dio.get(detailsEndpoint, queryParameters: params),
        dio.get(creditsEndpoint, queryParameters: params),
      ]);

      final detailsData =
          Map<String, dynamic>.from(responses[0].data as Map<String, dynamic>);
      final creditsData =
          Map<String, dynamic>.from(responses[1].data as Map<String, dynamic>);

      final castJson = (creditsData['cast'] as List?) ?? const [];
      final crewJson = (creditsData['crew'] as List?) ?? const [];

      final cast = castJson
          .whereType<Map<String, dynamic>>()
          .map(_mapCredit)
          .toList();
      final crew = crewJson
          .whereType<Map<String, dynamic>>()
          .map(_mapCredit)
          .toList();

      final alsoKnownAs = ((detailsData['also_known_as'] as List?) ?? const [])
          .whereType<String>()
          .toList();

      return ActorDetails(
        id: (detailsData['id'] as num?)?.toInt() ?? actorId,
        name: detailsData['name'] as String?,
        biography: detailsData['biography'] as String?,
        profilePath: detailsData['profile_path'] as String?,
        knownForDepartment: detailsData['known_for_department'] as String?,
        placeOfBirth: detailsData['place_of_birth'] as String?,
        birthday: detailsData['birthday'] as String?,
        deathday: detailsData['deathday'] as String?,
        homepage: detailsData['homepage'] as String?,
        alsoKnownAs: alsoKnownAs,
        cast: cast,
        crew: crew,
      );
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final msg = _readableDioMessage(e);
      throw FetchActorsException(message: msg, statusCode: status);
    } catch (e) {
      throw FetchActorsException(message: e.toString());
    }
  }

  ActorCredit _mapCredit(Map<String, dynamic> json) {
    final releaseDate = (json['release_date'] as String?) ??
        (json['first_air_date'] as String?);
    return ActorCredit(
      creditId: json['credit_id'] as String?,
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String? ?? json['name'] as String?,
      originalTitle:
          json['original_title'] as String? ?? json['original_name'] as String?,
      mediaType: json['media_type'] as String?,
      character: json['character'] as String?,
      job: json['job'] as String?,
      posterPath: json['poster_path'] as String?,
      releaseDate: releaseDate,
      voteAverage: (json['vote_average'] as num?)?.toDouble(),
    );
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
