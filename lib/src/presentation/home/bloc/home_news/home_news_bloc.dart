import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:news_app/src/domain/usecases/news/get_everything_case.dart';

import '../../../../core/core.dart';
import '../../../../domain/domain.dart';
import '../enum_home_bloc.dart';

part 'home_news_event.dart';
part 'home_news_state.dart';

class HomeNewsBloc extends Bloc<HomeNewsEvent, HomeNewsState> {
  final GetTrendingCase getTrendingCase;
  final GetHotCase hotCase;
  final GetRecommendationCase recommendationCase;
  final GetEverythingCase everythingCase;
  HomeNewsBloc({
    required this.getTrendingCase,
    required this.hotCase,
    required this.recommendationCase,
    required this.everythingCase,
  }) : super(const HomeNewsState()) {
    on<HomeNewsEvent>((event, emit) {});
    on<GetRecommendationNews>(_onGetRecommendationNews);
    on<GetEverythingNews>(_onGetEverythingNews);
    on<GetHotNews>(_onGetHotNews);
    on<GetTrendingNews>(_onGetTrendingNews);
  }

  void _onGetTrendingNews(
      GetTrendingNews event, Emitter<HomeNewsState> emit) async {
    emit(state.copyWith(statusTrending: HomeBlocStatus.loading));
    await getTrendingCase(NoParams()).then(
      (value) => value.fold(
        (l) => emit(
          state.copyWith(
            statusTrending: HomeBlocStatus.failure,
            message: Guide.failureToMessage(l),
          ),
        ),
        (r) => emit(
          state.copyWith(
            trending: r,
            statusTrending: HomeBlocStatus.loaded,
          ),
        ),
      ),
    );
    return;
  }

  void _onGetEverythingNews(
      GetEverythingNews event, Emitter<HomeNewsState> emit) async {
    emit(state.copyWith(statusEverything: HomeBlocStatus.loading));

    await everythingCase(
      GetEverythingParams(
        query: event.query,
        limit: event.limit,
        page: event.page,
      ),
    ).then(
      (value) => value.fold(
        (l) => emit(
          state.copyWith(
            message: Guide.failureToMessage(l),
            statusEverything: HomeBlocStatus.failure,
          ),
        ),
        (r) => emit(
          state.copyWith(
            statusEverything: HomeBlocStatus.loaded,
            everything: r,
          ),
        ),
      ),
    );
  }

  void _onGetRecommendationNews(
      GetRecommendationNews event, Emitter<HomeNewsState> emit) async {
    emit(state.copyWith(statusRecommendation: HomeBlocStatus.loading));

    await recommendationCase(
      GetRecommendationParams(
        query: event.query,
        limit: event.limit,
        page: event.page,
      ),
    ).then(
      (value) => value.fold(
        (l) => emit(
          state.copyWith(
            message: Guide.failureToMessage(l),
            statusRecommendation: HomeBlocStatus.failure,
          ),
        ),
        (r) => emit(
          state.copyWith(
            statusRecommendation: HomeBlocStatus.loaded,
            recommendation: r,
          ),
        ),
      ),
    );
  }

  void _onGetHotNews(GetHotNews event, Emitter<HomeNewsState> emit) async {
    emit(state.copyWith(statusHot: HomeBlocStatus.loading));

    await hotCase(NoParams()).then(
      (value) => value.fold(
        (l) => emit(
          state.copyWith(
            message: Guide.failureToMessage(l),
            statusHot: HomeBlocStatus.failure,
          ),
        ),
        (r) => emit(
          state.copyWith(
            statusHot: HomeBlocStatus.loaded,
            hot: r,
          ),
        ),
      ),
    );
    return;
  }
}
