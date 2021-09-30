import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:music_app_lover/details_view.dart';

void main() => runApp(new MyApp());

//Our MyApp class. Represents our application
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "ListView SearchView",
      home: new Home(),
      theme: ThemeData(primaryColor: Colors.orange),
    );
  }
}
//Represents the Homepage widget
class Home extends StatefulWidget {
  //`createState()` will create the mutable state for this widget at
  //a given location in the tree.
  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {
  var _searchview = new TextEditingController();
  bool isLoading = false;
  bool searchActive = true;
  bool isCrossActive = false;
  bool isApiCall = false;
  List _filterList = [];
  List filterName = [];
  static const BASE_URL = 'https://ws.audioscrobbler.com';
  static const API_KEY = '5acfc384a0d510a4fe1f5842fda97b23';



  @override
  void initState() {
    super.initState();
  }

  Future _getList(String search) async {
    setState(() {
      isApiCall = true;
    });
    var uri = BASE_URL +
        "" + "/2.0/?method=album.search&album=$search&api_key=$API_KEY&format=json";
    var url = Uri.parse(uri);
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        var finalData = decodedData['results']['albummatches'];
        List dataRes = [];
        var dataLength=finalData['album'].length;
        for (int i = 0; i < finalData['album'].length; i++) {
          dataRes.add(finalData['album'][i]);
        }
        print('ALL DATA RESPONSE ==========>>>>>>>${dataRes}');
        setState(() {
          _filterList.addAll(dataRes);
           filterName = _filterList;
           isApiCall = false;
        });

      } else {
        return 'failed';
      }
    } catch (e) {
      return 'failed';
    }

  }

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isLoading ? 1.0 : 00,
          child: new CupertinoActivityIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Center(child: new Text("Music Lovers")),
      ),
      body: new Container(
        margin: EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
        child: new Column(
          children: <Widget>[
            _createSearchView(),
           _createListView(),
            // _firstSearch ? _createListView() : _performSearch()
          ],
        ),
      ),
    );
  }
  //Create a SearchView
  Widget _createSearchView() {
    return new Container(
      decoration: BoxDecoration(border: Border.all(width: 1.0),
      ),
      child: new TextField(
        controller: _searchview,
        decoration: InputDecoration(
          suffixIcon: searchActive ?IconButton(
            icon: Icon(Icons.search_sharp),
            onPressed: () {
              _getList(_searchview.text);
              //_searchview.text = "";
              setState(() {
                isCrossActive = true;
                searchActive = false;
              });

            },
          ):IconButton(
            icon: Icon(Icons.cancel),
            onPressed: () {
              //_getList(_searchview.text);
              setState(() {
                _searchview.text = "";
                filterName = [];
                isCrossActive = false;
                searchActive = true;
              });

            },
          ),
          hintText: "Search Album or Artist",
          hintStyle: new TextStyle(color: Colors.grey[300]),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
  //Create a ListView widget
  Widget _createListView() {
    return Flexible(
      child: filterName.length == 0 ? Center(child: Container(alignment: Alignment.center,child: Text("Search Your Favorite Album"))):isApiCall == true ? _buildProgressIndicator() :GridView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
          itemCount: filterName.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 5.0,
            crossAxisSpacing: 5.0,),
          itemBuilder: (BuildContext context, int index) {
            return new GestureDetector(
              onTap: (){
                print('shahid --- ${filterName[index]['name']}');
                print('shahid --- ${filterName[index]['artist']}');
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailView(
                        name: filterName[index]['name'],
                        artist: filterName[index]['artist']),
                  ),
                );
              },
              child: new Card(
                child: new GridTile(
                  footer: Center(child: new Text(filterName[index]['name'],style: TextStyle(color: Colors.white),)),
                  child: Image.network(filterName[index]['image'][2]['#text']), //just for testing, will fill with image later
                ),
              ),
            );
          },
        ),
    );
  }
}