import 'package:flutter_hacker_news/model/article.dart';
import 'package:flutter_hacker_news/model/serializers.dart';
import 'dart:convert' as convert;

// https://hacker-news.firebaseio.com/v0/topstories.json
List<int> parseTopStories(String jsonStr) {
  final parsed = convert.jsonDecode(jsonStr);
  return List<int>.from(parsed);
}

// https://hacker-news.firebaseio.com/v0/item/8863.json
Article parseArticle(String jsonStr) {
  final parsed = convert.jsonDecode(jsonStr);
  Article article = serializers.deserializeWith(Article.serializer, parsed);
  return article;
}
