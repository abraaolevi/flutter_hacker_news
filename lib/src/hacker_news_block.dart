import 'dart:async';
import 'dart:collection';

import 'article.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

enum StoriesType {
  newStories,
  topStories,
}

class HackerNewsBloc {
  var _articles = <Article>[];

  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;

  Sink<StoriesType> get storiesType => _storiesTypeController.sink;

  final _storiesTypeController = StreamController<StoriesType>();

  static List<int> _topStoriesIds = [
    20246258,
    20246779,
    20245913,
    20245672,
    20246665,
  ];

  static List<int> _newStoriesIds = [
    20240900,
    20244287,
    20247077,
    20244961,
    20244459,
  ];

  HackerNewsBloc() {
    _getArticlesAndUpdate(_topStoriesIds);

    _storiesTypeController.stream.listen((storiesType) {
      if (storiesType == StoriesType.newStories) {
        _getArticlesAndUpdate(_newStoriesIds);
      } else {
        _getArticlesAndUpdate(_topStoriesIds);
      }
    });
  }

  _getArticlesAndUpdate(List<int> ids) {
    _updateArticles(ids).then((_) {
      _articlesSubject.add(UnmodifiableListView(_articles));
    });
  }

  Future<Article> _getArticle(int id) async {
    final itemUrl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final itemResponse = await http.get(itemUrl);
    return Article.fromJson(itemResponse.body);
  }

  Future<Null> _updateArticles(List<int> articlesIds) async {
    final futureArticles = articlesIds.map((i) => _getArticle(i));
    final articles = await Future.wait(futureArticles);
    _articles = articles;
  }
}
