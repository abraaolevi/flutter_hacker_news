import 'dart:async';
import 'dart:collection';

import 'package:flutter_hacker_news/json_parsing.dart';

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

  var _topStoriesIds = List<int>();
  var _newStoriesIds = List<int>();
  var _cacheArticles = Map<int, Article>();

  HackerNewsBloc() {
    _getStories(StoriesType.topStories);

    _storiesTypeController.stream.listen((storiesType) {
      _getStories(storiesType);
    });
  }

  _getStories(StoriesType storyType) async {

    List<int> ids;

    if ((storyType == StoriesType.newStories && _newStoriesIds.isNotEmpty) 
    || (storyType == StoriesType.topStories && _topStoriesIds.isNotEmpty)) {
      
      ids = storyType == StoriesType.newStories ? _newStoriesIds : _topStoriesIds;

    } else {
      final jsonName = storyType == StoriesType.newStories ? 'newstories' : 'topstories';
      final storyUrl = 'https://hacker-news.firebaseio.com/v0/$jsonName.json';
      final storyResponse = await http.get(storyUrl);
      
      ids = parseTopStories(storyResponse.body);

      if (storyType == StoriesType.newStories) {
        _newStoriesIds = ids;
      } else {
        _topStoriesIds = ids;
      }
    }

    _getArticlesAndUpdate(ids);
  }

  _getArticlesAndUpdate(List<int> ids) {
    _updateArticles(ids).then((_) {
      _articlesSubject.add(UnmodifiableListView(_articles));
    });
  }

  Future<Article> _getArticle(int id) async {
    if (_cacheArticles[id] == null) {
      final itemUrl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
      final itemResponse = await http.get(itemUrl);
      _cacheArticles[id] = Article.fromJson(itemResponse.body);
    }

    return _cacheArticles[id];
  }

  Future<Null> _updateArticles(List<int> articlesIds) async {
    final futureArticles = articlesIds.map((i) => _getArticle(i));
    final articles = await Future.wait(futureArticles);
    _articles = articles;
  }
}
