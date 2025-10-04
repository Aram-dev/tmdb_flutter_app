import '../../models/movie_detail.dart';
import '../../repositories/movie_repository.dart';
import 'movie_details_use_case.dart';

class MovieDetailsUseCaseImpl extends MovieDetailsUseCase {
  MovieDetailsUseCaseImpl({required this.repository});

  final MovieRepository repository;

  @override
  Future<MovieDetail> getMovieDetails(
    int movieId,
    String apiKey,
    String language,
  ) {
    return repository.getMovieDetails(movieId, apiKey, language);
  }
}
