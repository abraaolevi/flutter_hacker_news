import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter_hacker_news/src/shared/api_provider.dart';
import 'package:flutter_hacker_news/src/shared/models/article.dart';

class ArticlesRepository extends Disposable {
  ApiProvider _api;
  Map<String, List<int>> _storiesIdCache = {};
  Map<int, Article> _articlesCache = {};

  ArticlesRepository({ApiProvider api}) {
    this._api = api ?? ApiProvider();
  }

  List<int> _paginate (List<int> array, int pageNumber, int perPage) {
    --pageNumber;
    return array.sublist(pageNumber * perPage, (pageNumber + 1) * perPage);
  }

  Future<List<Article>> getArticles(StoriesType type, int page) async {
    final response = List<Article>();

    if (_storiesIdCache[type.toString()] == null) {
        _storiesIdCache[type.toString()] = await _api.fetchArticlesStories(type);
    }
    
    final storiesIds = _storiesIdCache[type.toString()];
    final itemsPerPage = 10;

    for (int id in _paginate(storiesIds, page, itemsPerPage)) {
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
