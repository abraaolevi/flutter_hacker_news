import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/src/home/home_bloc.dart';
import 'package:flutter_hacker_news/src/home/home_module.dart';
import 'package:flutter_hacker_news/src/shared/models/article.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeBloc bloc = HomeModule.to.bloc<HomeBloc>();
  final _scrollController = ScrollController();

  int _tabCurrentIndex = 0;

  @override
  void initState() {
    super.initState();
    bloc.loadData();
  }

  void _onTapBottomNavigationBar(int index) {
    setState(() {
      _tabCurrentIndex = index;
    });
  }

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

            return NotificationListener<ScrollNotification>(
                onNotification: _handleScrollNotification,
                child: StreamBuilder(
                  stream: bloc.articles,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Article>> snapshot) {
                    if (snapshot.hasData) {
                      return _articlesListView(snapshot.data);
                    }
                    return Container();
                  },
                ));

            // return ArticlesListView(bloc: bloc);
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _tabCurrentIndex,
          onTap: _onTapBottomNavigationBar,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.arrow_upward), 
              title: Text("Top Stories"),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.new_releases), 
              title: Text("New Stories"),
            ),
          ],
        ),
        );
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        _scrollController.position.extentAfter == 0) {
      bloc.nextPage();
    }
    return false;
  }

  ListView _articlesListView(List<Article> articles) {
    return ListView(
      children: [
        ...articles.map((article) => _articleCell(article)).toList(),
        Center(
          child: CircularProgressIndicator(),
        )
      ],
      controller: _scrollController,
    );
  }

  Widget _articleCell(Article article) {
    return ListTile(
      title: Text(article.title),
      subtitle: Text(article.type),
      trailing: Icon(Icons.launch),
      onTap: () {
        launch(article.url);
      },
    );
  }
}
