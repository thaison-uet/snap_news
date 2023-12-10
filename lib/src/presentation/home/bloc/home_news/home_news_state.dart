part of 'home_news_bloc.dart';

class HomeNewsState extends Equatable {
  final HomeBlocStatus statusTrending;
  final HomeBlocStatus statusHot;
  final HomeBlocStatus statusRecommendation;
  final HomeBlocStatus statusEverything;
  final NewsEntities? trending;
  final NewsEntities? recommendation;
  final NewsEntities? everything;
  final NewsEntities? hot;

  final String message;
  const HomeNewsState({
    this.statusTrending = HomeBlocStatus.initial,
    this.statusHot = HomeBlocStatus.initial,
    this.statusRecommendation = HomeBlocStatus.initial,
    this.statusEverything = HomeBlocStatus.initial,
    this.message = "",
    this.trending,
    this.recommendation,
    this.everything,
    this.hot,
  });

  HomeNewsState copyWith({
    HomeBlocStatus? statusTrending,
    HomeBlocStatus? statusHot,
    HomeBlocStatus? statusRecommendation,
    HomeBlocStatus? statusEverything,
    NewsEntities? trending,
    NewsEntities? recommendation,
    NewsEntities? everything,
    NewsEntities? hot,
    String? message,
  }) {
    return HomeNewsState(
      statusHot: statusHot ?? this.statusHot,
      statusTrending: statusTrending ?? this.statusTrending,
      statusRecommendation: statusRecommendation ?? this.statusRecommendation,
      statusEverything: statusEverything ?? this.statusEverything,
      trending: trending ?? this.trending,
      hot: hot ?? this.hot,
      recommendation: recommendation ?? this.recommendation,
      everything: everything ?? this.everything,
      message: message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        statusTrending,
        statusHot,
        statusRecommendation,
        statusEverything,
        trending,
        message,
        recommendation,
        everything,
        hot
      ];
}
