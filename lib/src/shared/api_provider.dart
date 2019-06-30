import 'package:http/http.dart' show Client;
import 'dart:convert';
import 'package:flutter_hacker_news/src/shared/models/article.dart';

enum StoriesType {
  newStories,
  topStories,
}

class ApiProvider {
  Client client = Client();

  Future<List<int>> fetchArticlesStories(StoriesType type) async {
    String storyType = StoriesType.newStories == type ? 'newstories' : 'topstories';
    final response = await client.get('https://hacker-news.firebaseio.com/v0/$storyType.json');
    return List<int>.from(json.decode(response.body)) ;
  }

  Future<Article> fetchArticle(int id) async {
    final url = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final response = await client.get(url);
    return Article.fromJson(response.body);
  }
}