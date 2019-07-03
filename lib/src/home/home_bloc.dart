
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_hacker_news/src/shared/api_provider.dart';
import 'package:flutter_hacker_news/src/shared/models/article.dart';
import 'package:flutter_hacker_news/src/shared/repositories/articles_repository.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends BlocBase {

  ArticlesRepository _articlesRepository = ArticlesRepository();

  // HomeBloc(ArticlesRepository articlesRepository) {
  //   this._articlesRepository = articlesRepository;
  //   this.start();
  // }

  HomeBloc() {
    start();
  }

  var _articlesController = BehaviorSubject<List<Article>>.seeded([]);
  Stream<List<Article>> get articleStream => _articlesController.stream;
  
  var _isLoadingController = BehaviorSubject<bool>.seeded(false);
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  start() async {
    _isLoadingController.sink.add(true);
    var response = await _articlesRepository.getArticles(StoriesType.newStories);
    _articlesController.sink.add(response);
    _isLoadingController.sink.add(false);
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    super.dispose();
  }
}
