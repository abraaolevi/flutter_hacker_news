import 'package:flutter_hacker_news/src/shared/api_provider.dart';
import 'package:flutter_hacker_news/src/shared/models/article.dart';
import 'package:flutter_hacker_news/src/shared/repositories/articles_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() async {
  final client = MockClient();

  when(client.get('https://hacker-news.firebaseio.com/v0/item/20317825.json'))
      .thenAnswer((_) async {
    var response =
        '{"by":"Anon84","descendants":2,"id":2,"kids":[20318023],"score":58,"time":1561897439,"title":"Graphs and Geometry [pdf]","type":"story","url":"http://web.cs.elte.hu/~lovasz/bookxx/geomgraphbook/geombook2019.01.11.pdf"}';
    return http.Response(response, 200);
  });

  when(client.get('https://hacker-news.firebaseio.com/v0/newstories.json'))
      .thenAnswer((_) async => http.Response('[1]', 200));

  when(client.get('https://hacker-news.firebaseio.com/v0/topstories.json'))
      .thenAnswer((_) async => http.Response('[2]', 200));

  when(client.get('https://hacker-news.firebaseio.com/v0/item/1.json'))
      .thenAnswer((_) async => http.Response('{"id":1}', 200));

  when(client.get('https://hacker-news.firebaseio.com/v0/item/2.json'))
      .thenAnswer((_) async => http.Response('{"id":2}', 200));

  ApiProvider api = ApiProvider();
  api.client = client;

  ArticlesRepository repo = ArticlesRepository(api: api);

  test('test getArticle', () async {
    final article = await repo.getArticle(20317825);

    expect(article, isInstanceOf<Article>());
    expect(2, article.id);
  });

  test('test getArticles new stories ', () async {
    final articles = await repo.getArticles(StoriesType.newStories);

    expect(articles, isInstanceOf<List<Article>>());
    expect(articles.length, 1);
    expect(articles.first.id, 1);
  });

  test('test getArticles top stories ', () async {
    final articles = await repo.getArticles(StoriesType.topStories);

    expect(articles, isInstanceOf<List<Article>>());
    expect(articles.length, 1);
    expect(articles.first.id, 2);
  });
}
