import 'package:bloc_pattern/bloc_pattern.dart';
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
        stream: bloc.isLoadingStream,
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.data) {
              return CircleAvatar();
            }
            return StreamBuilder(
                stream: bloc.articleStream,
                builder: (BuildContext context, AsyncSnapshot<List<Article>> snapshot) {
                  if (!snapshot.hasData) {
                    return Text("Carregando");
                  }
                  return _articlesListView(snapshot.data);
                },
              );
        },
      )
      
      
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
