import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/src/home/home_bloc.dart';
import 'package:flutter_hacker_news/src/home/home_module.dart';
import 'package:flutter_hacker_news/src/shared/models/article.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final HomeBloc bloc = HomeModule.to.bloc<HomeBloc>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hacker News"),
      ),
      body: StreamBuilder(
        stream: bloc.isLoading,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (!snapshot.hasData || snapshot.data) {
              return Center(child: CircularProgressIndicator());
            }
            return ArticlesListView(bloc: bloc);
        },
      )
    );
  }
}

class ArticlesListView extends StatelessWidget {

  const ArticlesListView({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final HomeBloc bloc;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: bloc.articles,
        builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
          if (snapshot.hasData) {
            return _articlesListView(snapshot.data);
          }
          return Container();
        },
      );
  }

  ListView _articlesListView(List<Article> articles) {
    return ListView(
      children: articles.map((article) => _articleCell(article)).toList(),
    );
  }

  Widget _articleCell(Article article) {
    return ListTile(
      title: Text(article.title),
      subtitle: Text(article.type),
    );
  }
}
