import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
import 'dart:async';
import 'dart:convert';



Future<List<GithubRepository>> _searchRepositories(String repos0,String repos1,String repos2,String language) async {
  String searchWord ="";
  String searchWord2="";
  if(language!='all language'){searchWord2='+language:$language';}
  if(repos1==""&&repos2==""){searchWord=repos0;}
  else if(repos2==""){searchWord='$repos0+$repos1';}
  else{searchWord='$repos0+$repos1+$repos2';}
  final response = await http.get(Uri.parse('https://api.github.com/search/repositories?q=$searchWord$searchWord2&sort=stars&order=desc'));
  if (response.statusCode == 200) {
    List<GithubRepository>? list = [];
    Map<String, dynamic> decoded = json.decode(response.body);
    for (var item in decoded['items']) {
      list.add(GithubRepository.fromJson(item));
    }
    return list;
  } else {
    throw Exception('Fail to search repository');
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GithubRepository>? _repositories =[] ;
  int tap =1;
  String repos0="";
  String repos1="";
  String repos2="";
  String language ='all language';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Github Repository"),
      ),
      body:Column(
          children:[
            DropdownButton(
              value: language,
              items: const [
                //5
                DropdownMenuItem(value: 'all language',child: Text('all language'),),
                DropdownMenuItem(value: 'python',child: Text('python'),),
                DropdownMenuItem(value: 'java',child: Text('java'),),
                DropdownMenuItem(value: 'javascript',child: Text('javascript'),),
                DropdownMenuItem(value: 'dart',child: Text('dart'),),
                DropdownMenuItem(value: 'c',child: Text('c'),),
                DropdownMenuItem(value: 'html',child: Text('html'),),
                DropdownMenuItem(value: 'ruby',child: Text('ruby'),),
                DropdownMenuItem(value: 'css',child: Text('css'),),
              ], onChanged: (String? value) {
              setState(() {
                language = value!;
                _searchRepositories(repos0,repos1,repos2,language).then((repositories) {
                  _repositories = repositories;
                });
              });
            },
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tap,
              itemBuilder: (BuildContext context, int index){
                return _buildInput(index);
              },
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  // （2） 実際に表示するページ(ウィジェット)を指定する
                    builder: (context) => _buildRepositoryList()
                ));
              },
              // タッチ検出対象のWidget
              child: const Card(
                margin: EdgeInsets.all(30),
                child:Text(
                  'GO searching',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ]

      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          if(tap<3){
            setState(() {
              tap++;
            });
          }
        },
      ),
    );
  }

  Widget _buildInput(int index) {
    int indexx =index +1;
    return Container(
        margin: EdgeInsets.all(16.0),
        child: TextField(
            decoration:  InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: 'Please enter a search repository name.',
              labelText: 'word $indexx',
            ),
            onChanged: (inputString) {

                setState(() {
                  if(index==0){repos0=inputString;}
                  if(index==1){repos1=inputString;}
                  if(index==2){repos2=inputString;}
                });
            },
            onSubmitted:(String str) {
              _searchRepositories(repos0,repos1,repos2,language).then((repositories) {
                _repositories = repositories;
              });
            }
        )
    );
  }


  Widget _buildRepositoryList(){
    return Scaffold(
      appBar: AppBar(
        leading: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {Navigator.of(context).pop();},
              );
            },
          ),
        ),
        title: Text(
          'word1:$repos0  word2:$repos1  word3:$repos2',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16.0
          ),
        ),
      ),
      body: Center(
        child: ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            final repository = _repositories![index];
            return _buildCard(repository);
          },
          itemCount: _repositories?.length,
        ),
      ),
    );
  }



  Widget _buildCard(GithubRepository repository) {
    return GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
            // （2） 実際に表示するページ(ウィジェット)を指定する
              builder: (context) => _buildInputt(repository)
          ));
        },
        child:Card(
          margin: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  repository.fullName ?? 'a',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
              repository.language != null ? Padding(
                padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                child: Text(
                  repository.language ?? 'a',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 12.0
                  ),
                ),
              ) : Container(),
              repository.description != null ? Padding(
                padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                child: Text(
                    repository.description ?? 'a',
                    style: TextStyle(
                        fontWeight: FontWeight.w200,
                        color: Colors.grey
                    )
                ),
              ) : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Icon(Icons.star),
                  SizedBox(
                    width: 50.0,
                    child: Text(repository.stargazersCount.toString()),
                  ),
                  Icon(Icons.remove_red_eye),
                  SizedBox(
                    width: 50.0,
                    child: Text(repository.watchersCount.toString()),
                  ),
                  Text("Fork:"),
                  SizedBox(
                    width: 50.0,
                    child: Text(repository.forksCount.toString()),
                  ),
                ],
              ),
              SizedBox(height: 16.0,)
            ],
          )
          ,)
    );
  }
  Widget _buildInputt(GithubRepository repository) {
    return Scaffold(
      appBar: AppBar(
        leading: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {Navigator.of(context).pop();},
              );
            },
          ),
        ),
        title: Text(
          repository.fullName ?? 'a',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16.0
          ),
        ),
      ),
      body: Column(
        children:  <Widget>[
          Container(
            margin: const EdgeInsets.all(20),
            width: 150.0,
            height: 150.0,
            decoration:  BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: NetworkImage(repository.owner!["avatar_url"]),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            height: 80,
            decoration: BoxDecoration(border: Border.all(
              color: Colors.black,
              width: 4.0,
            ),
            ),
            child:Column(
              children:<Widget> [
                Text(
                  "repository name: ${repository.name}",
                  overflow: TextOverflow.visible,
                  style: const TextStyle(fontSize: 18),),
                Text(
                  "${repository.description}",
                  overflow: TextOverflow.visible,
                  style: const TextStyle(fontSize: 12),),
              ],
            ) ,
          ),
          Text("lunguage : ${repository.language}",
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 18),),
          Text("starcount: ${repository.stargazersCount.toString()}",
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 18),),
          Text("watchercount: ${repository.watchersCount.toString()}",
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 18),),
          Text("forkcount: ${repository.forksCount.toString()}",
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 18),),
          Text("issuecount: ${repository.openissuescount.toString()}",
            overflow: TextOverflow.visible,
            style: TextStyle(fontSize: 18),),
        ],

      ),
    );
  }

}