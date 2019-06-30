import 'package:flutter_hacker_news/src/shared/api_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'dart:convert';

void main() {
  final apiProvider = ApiProvider();

  test('test fetchArticlesStories', () async {
    // Given
    apiProvider.client = MockClient((request) async {
      final mapJson = [3, 20317825, 20317736, 20317884, 20316803];
      return Response(json.encode(mapJson), 200);
    });

    // When
    final response = await apiProvider.fetchArticlesStories(StoriesType.topStories);

    // Then
    expect(3, response.first);
  });

  test('test fetchArticle', () async {
    // Given
    apiProvider.client = MockClient((request) async {
      final mapJson = {"by":"braised_babbage","descendants":3,"id":20317884,"kids":[20318341,20318370,20318379],"score":30,"time":1561898295,"title":"Why factoring may be easier than you think","type":"story","url":"http://math.mit.edu/~cohn/Thoughts/factoring.html"};
      return Response(json.encode(mapJson), 200);
    });

    // When
    final article = await apiProvider.fetchArticle(20317884);

    // Then
    expect(20317884, article.id);
  });
}
