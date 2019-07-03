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
    var response = List<Article>();

    var storiesIds = await _api.fetchArticlesStories(type);

    // TEMP
    storiesIds = storiesIds.sublist(0,10);

    for (int id in storiesIds) {
      var article = await getArticle(id);
      response.add(article);
    }

    return response;
  }

  Future<Article> getArticle(int id) async {
    if (_articlesCache[id] == null) {
      var article = await _api.fetchArticle(id);
      _articlesCache[id] = article;
    }
    return _articlesCache[id];
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {}
}
