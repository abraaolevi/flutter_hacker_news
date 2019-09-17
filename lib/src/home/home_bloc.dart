
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_hacker_news/src/shared/api_provider.dart';
import 'package:flutter_hacker_news/src/shared/models/article.dart';
import 'package:flutter_hacker_news/src/shared/repositories/articles_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends BlocBase {

  ArticlesRepository _articlesRepository;

  HomeBloc({ArticlesRepository articlesRepo}) {
    this._articlesRepository = articlesRepo;
    _pageController.stream.listen((_) {
      loadData();
    });
  }

  var _currentStoryType = StoriesType.topStories;
  final _articlesSource = _ArticlesSource();

  final _articlesController = BehaviorSubject<List<Article>>.seeded([]);
  Stream<List<Article>> get articles => _articlesController.stream;
  
  final _isLoadingController = BehaviorSubject<bool>.seeded(true);
  Stream<bool> get isLoading => _isLoadingController.stream;

  final _pageController = BehaviorSubject<int>.seeded(1);

  loadData() async {
    // Future.delayed(Duration(seconds: 3));

    final currentPage = _pageController.stream.value;
    final response = await _articlesRepository.getArticles(_currentStoryType, currentPage);
    final articles = _articlesSource.appendArticles(_currentStoryType, response);

    // Set Articles to Stream
    _articlesController.sink.add(articles);

    _isLoadingController.sink.add(false);
  }

  nextPage() {
    final currentPage = _pageController.stream.value;
    _pageController.sink.add(currentPage + 1);
  }

  changeStoryType(StoriesType storyType) {
    _currentStoryType = storyType;

    final articles = _articlesSource.getArticles(_currentStoryType);

    if (articles.length == 0) {
      _isLoadingController.sink.add(true);
      loadData();
    } else {
      _articlesController.sink.add(articles);
    }
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

class _ArticlesSource {
  var _articles = Map<StoriesType, List<Article>>();

  List<Article> getArticles(StoriesType type) {
    if (_articles[type] == null) {
      _articles[type] = [];
    }
    return _articles[type];
  }

  List<Article> appendArticles(StoriesType type, List<Article> newArticles) {
    final articles = getArticles(type);
    _articles[type] = [...articles, ...newArticles];
    return _articles[type];
  }
}
