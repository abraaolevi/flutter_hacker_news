import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_hacker_news/src/shared/api_provider.dart';
import 'package:flutter_hacker_news/src/shared/models/article.dart';

class ArticlesRepository extends Disposable {
  ApiProvider _api;
  Map<int, Article> _articlesCache = {};

  ArticlesRepository({ApiProvider api}) {
    this._api = api ?? ApiProvider();
  }

  Future<List<Article>> getArticles(StoriesType type) async {
    List<Article> response = [];

    List<int> storiesIds = await _api.fetchArticlesStories(type);
    for (int id in storiesIds) {
      Article article = await getArticle(id);
      response.add(article);
    }

    return response;
  }

  Future<Article> getArticle(int id) async {
    if (_articlesCache[id] == null) {
      Article article = await _api.fetchArticle(id);
      _articlesCache[id] = article;
    }
    return _articlesCache[id];
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {}
}
