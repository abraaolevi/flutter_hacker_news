import 'dart:async';
import 'dart:collection';

import 'article.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class HackerNewsBloc {
  final _articlesSubject = BehaviorSubject<UnmodifiableListView<Article>>();

  var _articles = <Article>[];

  HackerNewsBloc() {
    _updateArticles().then((_) {
      _articlesSubject.add(UnmodifiableListView(_articles));
    });
  }

  Stream<UnmodifiableListView<Article>> get articles => _articlesSubject.stream;

  List<int> _ids = [
    20246258,
    20246779,
    20245913,
    20245672,
    20246665,
    20240900,
    20244287,
    20247077,
    20244961,
    20244459
  ];

  Future<Article> _getArticle(int id) async {
    final itemUrl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final itemResponse = await http.get(itemUrl);
    return Article.fromJson(itemResponse.body);
  }

  Future<Null> _updateArticles() async {
    final futureArticles = _ids.map((i) => _getArticle(i));
    final articles = await Future.wait(futureArticles);
    _articles = articles;
  }
}
