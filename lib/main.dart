import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_hacker_news/src/article.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  List<int> _ids = [20246258,20246779,20245913,20245672,20246665,20240900,20244287,20247077,20244961,20244459];

  Future<Article> _getArticle (int id) async {
    final itemUrl = 'https://hacker-news.firebaseio.com/v0/item/$id.json';
    final itemResponse = await http.get(itemUrl);
    return Article.fromJson(itemResponse.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView(
          children: _ids.map((i) =>
              FutureBuilder<Article>(
                future: _getArticle(i),
                builder: (BuildContext context, AsyncSnapshot<Article> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return _buildItem(snapshot.data);
                  }
                  return Center(child: CircularProgressIndicator());
                },
              )
          ).toList()
        )
    );
  }

  Widget _buildItem(Article article) {
    return ExpansionTile(
      title: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(article.title, style: TextStyle(fontSize: 24)),
      ),
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(article.type),
            IconButton(
              icon: Icon(Icons.launch),
              onPressed: () async {
                if (await canLaunch(article.url)) {
                  launch(article.url);
                }
              },
            ),
          ],
        )
      ],
    );
  }
}
