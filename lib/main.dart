import 'dart:async';
import 'dart:convert';

import 'package:cirrus_map_view/figure_joint_type.dart';
import 'package:cirrus_map_view/map_view.dart';
import 'package:cirrus_map_view/polygon.dart';
import 'package:cirrus_map_view/polygon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geo_location/Model/Geometry.dart';
import 'package:geo_location/Model/Result.dart';
import 'package:latlong/latlong.dart';
var myKey = 'AIzaSyDuLQta4bmLunan6nyUIcQcQf1Og-rfnpg';

void main() {
  MapView.setApiKey(myKey);
  runApp(new MyApp());
}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var allDataList = new List<dynamic>();
  List<Geomerty> geomertyList = new List();
  String assetsPath="assets/hub.json";
  MapView mapView = new MapView();
  LatLng tap=LatLng(50.8200879, -0.1504184);
  List<Marker> markers = <Marker>[
    new Marker("1", "Great",50.8404969, -0.15041841,
        color: Colors.green, draggable: true)
  ];
  @override
  void initState() {
    super.initState();
    Timer.run(() {loadJson();});

  }

  // ignore: missing_return
  Future<String> loadJson() async {
    String configJson = await DefaultAssetBundle.of(context).loadString("assets/hub3.json");
    var list =  json.decode(configJson);
    allDataList.addAll(list['results']['geometry'][0]);
    for(var i=0;i<allDataList.length;i++){
      geomertyList.add(new Geomerty.fromJson(allDataList[i]));
    }
    print(isLocationWithinArea(LatLng(50.8404969, -0.1504184),geomertyList));
  }
  bool isLocationWithinArea(LatLng tap, Geomerty) {
    int intersectCount = 0;
    for (int j = 0; j < geomertyList.length - 1; j++) {
      if (rayCastIntersect(tap, geomertyList[j], geomertyList[j + 1])) {
        intersectCount++;
      }
    }

    return ((intersectCount % 2) == 1); // odd = inside, even = outside;
  }

  bool rayCastIntersect(LatLng tap, Geomerty vertA, Geomerty vertB) {

    double aY = vertA.lat;
    double bY = vertB.lat;
    double aX = vertA.lng;
    double bX = vertB.lng;
    double pY = tap.latitude;
    double pX = tap.longitude;

    if ((aY > pY && bY > pY) || (aY < pY && bY < pY)
        || (aX < pX && bX < pX)) {
      return false; // a and b can't both be above or below pt.y, and a or
      // b must be east of pt.x
    }

    double m = (aY - bY) / (aX - bX); // Rise over run
    double bee = (-aX) * m + aY; // y = mx + b
    double x = (pY - bee) / m; // algebra is neat!

    return x > pX;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Google Maps'),
      ),
      body: new Center(
        child: Container(
          child: RaisedButton(
            child: Text('Tap me'),
            color: Colors.blue,
            textColor: Colors.white,
            elevation: 7.0,
            onPressed: null,
          ),
        ),
      ),
    );
  }
}
