import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class DetailView extends StatefulWidget {
  final name;
  final artist;
  const DetailView({Key? key, this.name, this.artist}) : super(key: key);

  @override
  _DetailViewState createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
bool isApiCall = false;
static const BASE_URL = 'https://ws.audioscrobbler.com';
static const API_KEY = '5acfc384a0d510a4fe1f5842fda97b23';
var listeners;
var playCount;
var mbid;
var image;
var published;
var summary;
bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getDetails();
  }
///https://ws.audioscrobbler.com
  Future _getDetails() async {
    setState(() {
      isApiCall = true;
    });
    var getUrl = BASE_URL +
        "" + "/2.0/?method=album.getinfo&api_key=$API_KEY&artist=${widget.artist}&album=${widget.name}&format=json";
    var url = Uri.parse(getUrl);
    http.Response response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        String data = response.body;
        var decodedData = jsonDecode(data);
        var finalData = decodedData['album'];
        var listener  = finalData['listeners'];
        var playCoun = finalData['playcount'];
        var mbi= finalData['mbid'];
        var publishd = finalData['wiki']['published'];
        var sumry = finalData['wiki']['summary'];
        var imge= finalData['image'][4]['#text'];
        print('ALL DATA RESPONSE ==========>>>>>>>${finalData['listeners']}');
        setState(() {
          if(finalData!= null){
            isApiCall = false;
            listeners = listener;
            playCount = playCoun;
            mbid = mbi;
            image = imge;
            published = publishd;
            summary = sumry;
          }
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
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
          title: new Text("Album Details"),
        ),
        body: isApiCall ?_buildProgressIndicator() :
        SingleChildScrollView(
          child: Container(
            height: 900,
            child: Column(children: [
              Container(
                //color: Colors.red,
                height: 250,
                width: 400,
                //width: responsiveWidth(374),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(0),
                  image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                          Colors.black.withOpacity(1.0), BlendMode.lighten),
                      image:NetworkImage("$image"),
                      fit: BoxFit.fill
                  ), //profilePic.png
                ),
              ),
              Text("Artist - ${widget.artist}",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 7,),
              Text("Name - ${widget.name}",
                style: TextStyle(fontSize: 15),
              ),
              Text("Listeners - $listeners",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 7,),
              Text("playcount - $playCount",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 7,),
              Text("Listeners - $listeners",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 7,),
              Text("Published - $published",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 7,),
              Text("mbid - $mbid",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(height: 7,),
              Text("Summary - $summary",
                style: TextStyle(fontSize: 15),
              ),
              SizedBox(
                height: 10,
              ),
              // Container(
              //   alignment: Alignment.center,
              //   color: Colors.red,
              //   padding: EdgeInsets.all(0),
              //   width: 200,
              //   height: 60,
              //   child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       //mainAxisSize: MainAxisSize.max,
              //       mainAxisAlignment: MainAxisAlignment.end,
              //       children: [
              //         Text(
              //           widget.artist,
              //           style: TextStyle(fontSize: 12),
              //         ),
              //         SizedBox(
              //           height: 10,
              //         ),
              //         Text(
              //           widget.name,
              //           style: TextStyle(fontSize: 15),
              //         ),
              //         SizedBox(
              //           height: 10,
              //         ),
              //       ]),
              // )
            ]),
          ),
        ),
    );
  }
}
