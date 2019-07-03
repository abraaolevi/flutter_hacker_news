import 'package:flutter_hacker_news/src/app_module.dart';
import 'package:flutter_hacker_news/src/home/home_bloc.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hacker_news/src/home/home_page.dart';
import 'package:flutter_hacker_news/src/shared/repositories/articles_repository.dart';

class HomeModule extends ModuleWidget {
  @override
  List<Bloc> get blocs => [
        Bloc((i) => HomeBloc(
          articlesRepo: AppModule.to.getDependency<ArticlesRepository>())
        ),
      ];

  @override
  List<Dependency> get dependencies => [
  ];

  @override
  Widget get view => HomePage();

  static Inject get to => Inject<HomeModule>.of();
}
