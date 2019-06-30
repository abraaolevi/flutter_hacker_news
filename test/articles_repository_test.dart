import 'dart:convert';

import 'package:flutter_hacker_news/src/shared/api_provider.dart';
import 'package:flutter_hacker_news/src/shared/repositories/articles_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() async {
  final client = MockClient();

  when(client.get('https://hacker-news.firebaseio.com/v0/item/20317825.json'))
      .thenAnswer((_) async {
        String response = '{"by":"Anon84","descendants":2,"id":2,"kids":[20318023],"score":58,"time":1561897439,"title":"Graphs and Geometry [pdf]","type":"story","url":"http://web.cs.elte.hu/~lovasz/bookxx/geomgraphbook/geombook2019.01.11.pdf"}';
        http.Response(response, 200);
  });

  var temp = await client.get('https://hacker-news.firebaseio.com/v0/item/20317825.json');
  print(temp);

  ApiProvider api = ApiProvider();
  api.client = client;

  ArticlesRepository repo = ArticlesRepository(api: api);
  // ArticlesRepository repo = ArticlesRepository();

  test('test getArticle', () async {
    final response = await repo.getArticle(20317825);

    print(response);
  });
}
