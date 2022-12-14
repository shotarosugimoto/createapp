import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'homepage.dart';
import 'dart:async';
import 'dart:convert';


///main関数
void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      home: HomePage(),
    );
  }
}



class GithubRepository {
  final String? name;
  final String? fullName;
  final String? description;
  final String? language;
  final String? htmlUrl;
  final int stargazersCount;
  final int watchersCount;
  final int forksCount;
  final int openissuescount;
  final Map? owner;

  GithubRepository.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        fullName = json['full_name'],
        description = json['description'],
        language = json['language'],
        htmlUrl = json['html_url'],
        stargazersCount = json['stargazers_count'],
        watchersCount = json['watchers_count'],
        forksCount = json['forks_count'],
        owner =json['owner'],
        openissuescount =json['open_issues_count'];
}