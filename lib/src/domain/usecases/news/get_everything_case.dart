import 'package:dartz/dartz.dart';

import '../../../core/core.dart';
import '../../domain.dart';

class GetEverythingCase implements UseCase<NewsEntities, GetEverythingParams> {
  final NewsRepository repository;

  GetEverythingCase(this.repository);
  @override
  Future<Either<Failure, NewsEntities>> call(GetEverythingParams params) async {
    return await repository.getEverything(
      query: params.query,
      limit: params.limit,
      page: params.page,
    );
  }
}

class GetEverythingParams {
  final String? query;
  final int? limit;
  final int? page;

  GetEverythingParams({this.query, this.limit, this.page});
}
