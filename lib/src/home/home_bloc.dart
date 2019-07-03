
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_hacker_news/src/shared/api_provider.dart';
import 'package:flutter_hacker_news/src/shared/models/article.dart';
import 'package:flutter_hacker_news/src/shared/repositories/articles_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends BlocBase {

  ArticlesRepository _articlesRepository;

  HomeBloc({ArticlesRepository articlesRepo}) {
    this._articlesRepository = articlesRepo;
    this.start();

    _pageController.stream.listen((_) {
      start();
    });
  }

  final _articlesController = BehaviorSubject<List<Article>>.seeded([]);
  Stream<List<Article>> get articles => _articlesController.stream;
  
  final _isLoadingController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isLoading => _isLoadingController.stream;

  final _pageController = BehaviorSubject<int>.seeded(1);

  start() async {
    _isLoadingController.sink.add(true);

    final currentPage = _pageController.stream.value;
    final response = await _articlesRepository.getArticles(StoriesType.newStories, currentPage);
    _articlesController.sink.add(response);

    _isLoadingController.sink.add(false);
  }

  nextPage() {
    final currentPage = _pageController.stream.value;
    _pageController.sink.add(currentPage + 1);
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    super.dispose();
    _articlesController.close();
    _isLoadingController.close();
    _pageController.close();
  }
}
