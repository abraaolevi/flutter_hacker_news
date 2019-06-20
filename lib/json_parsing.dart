import 'package:flutter_hacker_news/src/article.dart';
import 'dart:convert' as convert;

// https://hacker-news.firebaseio.com/v0/topstories.json
List<int> parseTopStories(String json) {
  final parsed = convert.jsonDecode(json);
  return List<int>.from(parsed);
}

// https://hacker-news.firebaseio.com/v0/item/8863.json
Article parseArticle(String json) {
  final parsed = convert.jsonDecode(json);
  Article article = Article.fromJson(parsed);
  return article;
}
